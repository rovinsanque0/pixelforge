class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart

  def create_checkout_session
    province = current_user.province || Province.find(params[:province_id])

    subtotal = calculate_subtotal
    gst      = subtotal * province.gst
    pst      = subtotal * province.pst
    hst      = subtotal * province.hst
    total    = subtotal + gst + pst + hst

    amount_in_cents = (total * 100).to_i

    session = Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      mode: "payment",

      line_items: [
        {
          quantity: 1,
          price_data: {
            currency: "cad",
            product_data: {
              name: "PixelForge Order"
            },
            unit_amount: amount_in_cents
          }
        }
      ],

      success_url: order_success_url,
      cancel_url: order_cancel_url
    )

    redirect_to session.url, allow_other_host: true
  end

  def order_success
    Orders::CreateFromStripeService.new(current_user, session[:cart]).call

    session[:cart] = {}

    redirect_to orders_path,
      notice: "Payment successful! Your order has been placed."
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
