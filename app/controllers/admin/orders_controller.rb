class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @orders = Order.includes(:user, :order_items, :province).order(created_at: :desc)
  end

  def toggle_shipping
    @order = Order.find(params[:id])

    if @order.status == "paid"
      @order.update(status: "paid-shipped")
    elsif @order.status == "paid-shipped"
      @order.update(status: "paid")
    end

    redirect_to admin_orders_path, notice: "Order status updated."
  end

  private

  def require_admin!
    redirect_to root_path, alert: "You are not authorized." unless current_user&.admin?
  end
end
