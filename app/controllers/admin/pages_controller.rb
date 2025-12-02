class Admin::PagesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_page

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_root_path, notice: "Page updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :content)
  end

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
