class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @selected_category_id = params[:category_id]
    @query = params[:q]
    @filter = params[:filter]

    @products = Product.all

    # Keyword search
    if @query.present?
      @products = @products.where(
        "name ILIKE :q OR description ILIKE :q",
        q: "%#{@query}%"
      )
    end

    # Navigate by category (different from search filter)
    if @selected_category_id.present?
      @products = @products.where(category_id: @selected_category_id)
    end

    # Filters
    case @filter
    when "new"
      @products = @products.where("created_at >= ?", 3.days.ago)
    when "recently_updated"
      @products = @products.where("updated_at >= ?", 3.days.ago)
    when "on_sale"
      # Add boolean :on_sale column or use logic based on price
      @products = @products.where(on_sale: true)
    end

    # Pagination 
    @products = @products.order(:name).page(params[:page]).per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end
