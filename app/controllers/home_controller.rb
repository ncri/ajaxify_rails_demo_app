class HomeController < ApplicationController
  def index
    sleep 1
  end

  def page1
    sleep 1
  end

  def page2
    sleep 1
  end

  def page3
    flash[:notice] = 'Redirected to Page 1'
    redirect_to '/home/page1'
  end
end
