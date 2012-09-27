class HomeController < ApplicationController

  before_filter :toggle_ajaxify

  def index
    sleep 0.5
  end

  def page1
    sleep 0.5
  end

  def page2
    sleep 0.5
  end

  def page3
    flash[:notice] = 'Flash notice: Redirected to Page 1'
    redirect_to '/home/page1'
  end


  private

  def toggle_ajaxify
    session[:ajaxify] = true if params[:ajaxify_on]
    session[:ajaxify] = false if params[:ajaxify_off]
  end

end
