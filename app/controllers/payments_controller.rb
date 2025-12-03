class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart

  def create_checkout_session
    # Save checkout info in session so Stripe success can rebuild the order
    session[:checkout_province_id] = params[:province_id]
    session[:checkout_address] = params[:address]
    session[:checkout_city] = params[:city]
    session[:checkout_postal_code] = params[:postal_code]

    province = Province.find(params[:province_id])
    subtotal = calculate_subtotal

    gst = subtotal * province.gst
    pst = subtotal * province.pst
    hst = subtotal * province.hst
    total = subtotal + gst + pst + hst

    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",
      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: "cad",
            product_data: { name: "PixelForge Order" },
            unit_amount: (total * 100).to_i
          }
        }
      ],
      success_url: order_success_url,
      cancel_url: order_cancel_url
    )

    redirect_to stripe_session.url, allow_other_host: true
  end

  def order_success
    Orders::CreateFromStripeService.new(
      current_user,
      session[:cart],
      session
    ).call

    # clear stored info
    session[:checkout_province_id] = nil
    session[:checkout_address] = nil
    session[:checkout_city] = nil
    session[:checkout_postal_code] = nil

    session[:cart] = {}

    redirect_to orders_path, notice: "Payment successful! Your order has been placed."
  end

  def order_cancel
    redirect_to new_order_path, alert: "Payment was canceled."
  end

  private

  def load_cart
    @cart = session[:cart] || {}
  end

  def calculate_subtotal
    @cart.sum do |pid, qty|
      product = Product.find(pid)
      product.display_price * qty.to_i
    end
  end
end
