# PUBLIC
# 
class PagesController < ApplicationController
  def about
    @page = Page.find_by!(slug: "about")
  end

  def contact
    @page = Page.find_by!(slug: "contact")
  end
end
