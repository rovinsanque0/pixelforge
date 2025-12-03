class PagesController < ApplicationController
  def about
    @page = Page.find_by!(slug: "about")
  end

  def contact
    @page = Page.find_by!(slug: "contact")
  end

  def contact_submit
    name    = params[:name]
    email   = params[:email]
    message = params[:message]

    
    # does not actually send anything
    flash[:notice] = "Thank you #{name}, your message has been sent!"

    redirect_to contact_path
  end
end
