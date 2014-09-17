# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def user_login!
    if session[:user_id].nil?
      flash[:alert] = '请您登录账户完成后操作！'
      redirect_to user_login_path
    end
  end

end
