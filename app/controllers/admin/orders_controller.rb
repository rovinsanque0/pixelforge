class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!

  def index
    @orders = Order.includes(:user, :order_items, :province).order(created_at: :desc)
  end

  def update_status
    @order = Order.find(params[:id])
    new_status = params[:status]

    if ["new", "paid", "shipped"].include?(new_status)
      @order.update(status: new_status)
      redirect_to admin_orders_path, notice: "Order ##{@order.id} marked as #{new_status.capitalize}."
    else
      redirect_to admin_orders_path, alert: "Invalid status."
    end
  end

  private

  def require_admin!
    redirect_to root_path, alert: "You are not authorized." unless current_user&.admin?
  end
end
