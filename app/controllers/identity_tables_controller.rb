#encoding : utf-8
class IdentityTablesController < ApplicationController

  before_filter :user_login!

  def index
    @identity_tables = IdentityTable.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @identity_tables }
    end
  end

  # GET /identity_tables/1
  # GET /identity_tables/1.json
  def show
    @identity_table = IdentityTable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @identity_table }
    end
  end

  # GET /identity_tables/new
  # GET /identity_tables/new.json
  def new
    @identity_table = IdentityTable.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @identity_table }
    end
  end

  # GET /identity_tables/1/edit
  def edit
    @identity_table = IdentityTable.find(params[:id])
  end

  # POST /identity_tables
  # POST /identity_tables.json
  def create
    @identity_table = IdentityTable.new(params[:identity_table])

    respond_to do |format|
      if @identity_table.save
        format.html { redirect_to identity_tables_path, alert: '新表添加成功！' }
        format.json { render json: @identity_table, status: :created, location: @identity_table }
      else
        format.html { render action: "new" }
        format.json { render json: @identity_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /identity_tables/1
  # PUT /identity_tables/1.json
  def update
    @identity_table = IdentityTable.find(params[:id])

    respond_to do |format|
      if @identity_table.update_attributes(params[:identity_table])
        format.html { redirect_to identity_tables_path, alert: '表名更新成功！' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @identity_table.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /identity_tables/1
  # DELETE /identity_tables/1.json
  def destroy
    @identity_table = IdentityTable.find(params[:id])
    @identity_table.destroy
    if session[:table_id].to_i == params[:id].to_i
      session.delete(:table_id)
    end

    respond_to do |format|
      format.html { redirect_to  identity_tables_path, alert: '表数据删除成功！' }
      format.json { head :no_content }
    end
  end

  def table_field
    session[:table_id] = params[:id]
    redirect_to table_fields_path
  end

end
