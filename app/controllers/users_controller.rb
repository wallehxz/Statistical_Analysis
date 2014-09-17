#encoding : utf-8
require 'rack/auth/digest/md5'
class UsersController < ApplicationController

  before_filter :user_login!

  def index
    @users = User.order('id')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.password =  Digest::MD5.hexdigest(params[:user][:password])
    @user.password_confirmation =  Digest::MD5.hexdigest(params[:user][:password_confirmation])
    @user.sign_time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    @user.picture = 'http://dzftp.static1.xiaoma.com/tuofujj/201403/QQ20140327105958.jpg'
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, alert: '用户增加成功！' }
      else
        format.html { render action: 'new' }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, alert: '用户信息更新成功' }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @session = User.find_by_id(session[:user_id])
    if @session.role == 'administrator'
      if @user.role == 'administrator'
        flash[:error] = '管理员数据不能删除！'
        redirect_to users_path
      else
        @user.destroy
        flash[:alert] = '用户数据删除成功！'
        redirect_to users_path
      end
    else
      flash[:error] = '您还没有删除用户数据的权限！'
      redirect_to users_path
    end
  end

end
