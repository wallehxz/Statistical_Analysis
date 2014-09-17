#encoding : utf-8
class TableFieldsController < ApplicationController
  before_filter :user_login!
  # GET /table_fields
  # GET /table_fields.json
  def index
    if session[:table_id].blank?
      flash[:alert] = '请选择一个表单！'
      redirect_to identity_tables_path
    else
      @table = IdentityTable.find_by_id(session[:table_id])

      @table_fields = TableField.where(table_id: session[:table_id]).order('field_turn')
      respond_to do |format|
        format.html
      end
    end

  end

  # GET /table_fields/1
  # GET /table_fields/1.json
  def show
    @table_field = TableField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @table_field }
    end
  end

  # GET /table_fields/new
  # GET /table_fields/new.json
  def new
    @table = IdentityTable.find_by_id(session[:table_id])
    @table_field = TableField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @table_field }
    end
  end

  # GET /table_fields/1/edit
  def edit
    @table = IdentityTable.find_by_id(session[:table_id])
    @table_field = TableField.find(params[:id])
  end

  # POST /table_fields
  # POST /table_fields.json
  def create
    @table = IdentityTable.find_by_id(session[:table_id])
     if TableField.where(table_id: session[:table_id]).nil?
       number =0
     else
       number = TableField.where(table_id: session[:table_id]).count
     end
    @table_field = TableField.new(params[:table_field])
    @table_field.field_turn = (number+1).to_i
    @table_field.table_id = session[:table_id]

    respond_to do |format|
      if @table_field.save
        if  ['radio','select','checkbox'].include?(@table_field.field_type)
          number =0
          params[:default].split('|').each do |item|
            @new_item = FieldItem.new(params[:field_item])
            @new_item.item_turn = (number+=1).to_i
            @new_item.field_id = @table_field.id.to_i
            @new_item.item_name = item.to_s
            @new_item.save
          end
        end
        format.html { redirect_to table_fields_path, alert: "'新字段添加成功！' "}
        format.json { render json: @table_field, status: :created, location: @table_field }
      else
        format.html { render action: "new" }
        format.json { render json: @table_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /table_fields/1
  # PUT /table_fields/1.json
  def update
    @table = IdentityTable.find_by_id(session[:table_id])
    @table_field = TableField.find(params[:id])

    respond_to do |format|
      if @table_field.update_attributes(params[:table_field])
        format.html { redirect_to table_fields_path, alert: '表字段更新成功！'  }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @table_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /table_fields/1
  # DELETE /table_fields/1.json
  def destroy
    @table_field = TableField.find(params[:id])
    @table_field.destroy

    respond_to do |format|
      format.html { redirect_to table_fields_path, alert: '表字段删除成功！'  }
      format.json { head :no_content }
    end
  end

  def field_item
    session[:field_id] = params[:id]
    redirect_to field_items_path
  end
end
