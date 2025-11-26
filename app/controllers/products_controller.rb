class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @selected_category_id = params[:category_id]
    @query = params[:q]

    @products = Product.all

    # search keyword
    if @query.present?
      @products = @products.where(
        "name ILIKE :q OR description ILIKE :q",
        q: "%#{@query}%"
      )
    end

    # filter by category (2.6)
    if @selected_category_id.present?
      @products = @products.where(category_id: @selected_category_id)
    end

    @products = @products.order(:name).page(params[:page]).per(12) # Kaminari later
  end

  def show
    @product = Product.find(params[:id])
  end
end
