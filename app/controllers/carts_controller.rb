class CartsController < ApplicationController
  before_action :load_cart

  def show; end

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

  def save_cart
    session[:cart] = @cart
  end
end
