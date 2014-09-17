#encoding : utf-8
class SessionController < ApplicationController
  layout 'login'

  def user_login
    if !session[:user_id].blank?
      user = User.find_by_id(session[:user_id])
      flash[:success] = "！欢迎回来、亲爱的【#{user.name}】！"
      redirect_to identity_tables_path
    end
  end

  def user_session
    if params[:account].blank?
      flash[:alert] = '登录账户为空'
      redirect_to user_login_path
    elsif params[:password].blank?
      flash[:alert] = '登录密码为空'
      redirect_to user_login_path
    elsif User.find_by_account(params[:account]).nil?
      flash[:alert] = '账户不存在，请联系管理员！'
      redirect_to user_login_path
    else
      @user = User.find_by_account(params[:account])
      if @user.password == Digest::MD5.hexdigest(params[:password])
        @user.lately_login = Time.now.strftime('%Y-%m-%d %H:%M:%S')
        @user.save
        session[:user_id] = @user.id
        if @user.role == 'administrator'
          flash[:alert] = '系统管理员、欢迎您来视察工作！'
          redirect_to users_path
        else
          flash[:alert] = '欢迎登录数据监控中心！'
          redirect_to identity_tables_path
        end
      else
        flash[:alert] = '密码错误！'
        redirect_to user_login_path
      end
    end
  end

  def destroy_session
    session.delete(:user_id)
    flash[:alert] = '您已经成功退出！'
    redirect_to user_login_path
  end

end