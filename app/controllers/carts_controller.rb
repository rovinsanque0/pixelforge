class CartsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart

  def show
    # Province tax preview
    if params[:province_id].present?
      @selected_province = Province.find(params[:province_id])

      @subtotal = calculate_subtotal
      @gst_amount = @subtotal * @selected_province.gst
      @pst_amount = @subtotal * @selected_province.pst
      @hst_amount = @subtotal * @selected_province.hst
      @total = @subtotal + @gst_amount + @pst_amount + @hst_amount
    end
  end

  def add_item
    product_id = params[:product_id].to_s
    @cart[product_id] ||= 0
    @cart[product_id] += 1
    save_cart

    redirect_back fallback_location: root_path, notice: "Added to cart."
  end

  def update_item
    product_id = params[:product_id].to_s
    quantity = params[:quantity].to_i

    if quantity <= 0
      @cart.delete(product_id)
    else
      @cart[product_id] = quantity
    end

    save_cart
    redirect_to cart_path, notice: "Cart updated."
  end

  def remove_item
    product_id = params[:product_id].to_s
    @cart.delete(product_id)
    save_cart
    redirect_to cart_path, notice: "Item removed."
  end

  private

  def load_cart
    session[:cart] ||= {}
    @cart = session[:cart]

    @cart_items = Product.where(id: @cart.keys).map do |product|
      qty = @cart[product.id.to_s]
      [product, qty]
    end
  end

  def calculate_subtotal
    @cart.sum do |pid, qty|
      product = Product.find(pid)
      product.display_price * qty.to_i
    end
  end

  def save_cart
    session[:cart] = @cart
  end
end
