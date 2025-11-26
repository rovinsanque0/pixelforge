class Admin::BaseController < ApplicationController
  layout "admin"          # tells Rails to use layouts/admin.html.erb

  before_action :authenticate_user!
  before_action :require_admin!

  private

  def require_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access the admin area."
    end
  end
end
