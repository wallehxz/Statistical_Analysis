#encoding : utf-8
class FieldItemsController < ApplicationController
  before_filter :user_login!
  # GET /field_items
  # GET /field_items.json
  def index

    if session[:field_id].blank?
      flash[:alert] = '请选择一个表自字段！'
      redirect_to table_fields_path
    else
      @table = IdentityTable.find_by_id(session[:table_id])
      @field = TableField.find_by_id(session[:field_id])
      
      @field_items = FieldItem.where(field_id: session[:field_id]).order('item_turn')

      respond_to do |format|
        format.html # index.html.erb
      end
    end

  end

  # GET /field_items/1
  # GET /field_items/1.json
  def show
    @field_item = FieldItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @field_item }
    end
  end

  # GET /field_items/new
  # GET /field_items/new.json
  def new

    @table = IdentityTable.find_by_id(session[:table_id])
    @field = TableField.find_by_id(session[:field_id])
    @field_item = FieldItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @field_item }
    end
  end

  # GET /field_items/1/edit
  def edit
    @table = IdentityTable.find_by_id(session[:table_id])
    @field = TableField.find_by_id(session[:field_id])
    @field_item = FieldItem.find(params[:id])
  end

  # POST /field_items
  # POST /field_items.json
  def create
    @table = IdentityTable.find_by_id(session[:table_id])
    @field = TableField.find_by_id(session[:field_id])
    if FieldItem.where(field_id: session[:field_id]).nil?
      number = 0
    else
      number = FieldItem.where(field_id: session[:field_id]).count
    end
    @field_item = FieldItem.new(params[:field_item])
    @field_item.item_turn = (number+1).to_i
    @field_item.field_id = session[:field_id]

    respond_to do |format|
      if @field_item.save
        format.html { redirect_to table_fields_path, alert: '字段选项添加成功！'  }
        format.json { render json: @field_item, status: :created, location: @field_item }
      else
        format.html { render action: "new" }
        format.json { render json: @field_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /field_items/1
  # PUT /field_items/1.json
  def update

    @table = IdentityTable.find_by_id(session[:table_id])
    @field = TableField.find_by_id(session[:field_id])
    @field_item = FieldItem.find(params[:id])

    respond_to do |format|
      if @field_item.update_attributes(params[:field_item])
        format.html { redirect_to field_items_path, alert: '字段选项更新成功！' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @field_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /field_items/1
  # DELETE /field_items/1.json
  def destroy
    @field_item = FieldItem.find(params[:id])
    @field_item.destroy

    respond_to do |format|
      format.html { redirect_to table_fields_path, alert: '字段选项删除成功！'  }
      format.json { head :no_content }
    end
  end
end
