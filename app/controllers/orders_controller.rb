class OrdersController < ApplicationController
  before_action :load_cart, only: [:new, :create]
  before_action :require_cart_not_empty, only: [:new, :create]
  before_action :authenticate_user!



  def index
    @orders = current_user.orders
  end

  def new
    @order = Order.new
    @provinces = Province.all

    if user_signed_in?
      @order.province = current_user.province
    end
  end

  def create
    province = find_province

    @order = Order.new(order_params)
    @order.user = current_user   # Allow nil for guest
    @order.province = province
    @order.status = "new"

    subtotal   = calculate_subtotal
    gst_amount = subtotal * province.gst
    pst_amount = subtotal * province.pst
    hst_amount = subtotal * province.hst
    total      = subtotal + gst_amount + pst_amount + hst_amount

    @order.subtotal   = subtotal
    @order.gst_amount = gst_amount
    @order.pst_amount = pst_amount
    @order.hst_amount = hst_amount
    @order.total      = total

    ActiveRecord::Base.transaction do
      @order.save!

      @cart.each do |product_id, qty|
        product = Product.find(product_id)

        @order.order_items.create!(
          product: product,
          quantity: qty,
          # 💡 FIX: Use display_price for price at purchase
          price_at_purchase: product.display_price
        )
      end
    end

    session[:cart] = {}
    redirect_to order_path(@order), notice: "Order placed!"

  rescue ActiveRecord::RecordInvalid
    @provinces = Province.all
    flash.now[:alert] = "Could not complete order."
    render :new, status: :unprocessable_entity
  end

  def show
    @order = Order.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:address, :city, :postal_code, :province_id)
  end

  def load_cart
    @cart = session[:cart] || {}
  end

  def require_cart_not_empty
    redirect_to root_path, alert: "Your cart is empty." if @cart.blank?
  end

  def calculate_subtotal
    Product.where(id: @cart.keys).sum do |product|
      qty = @cart[product.id.to_s].to_i
      product.display_price * qty
    end
  end

  def find_province
    current_user.province || Province.find(order_params[:province_id])

  end
end
