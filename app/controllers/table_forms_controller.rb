#encoding : utf-8
class TableFormsController < ApplicationController
  before_filter :user_login!
  before_filter :find_table_id

  before_filter :user_login!, :except => [:create]

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index

      @table = IdentityTable.find_by_id(@identity_table.id)
      session[:table_id] = @table.id
      @table_forms = TableForm.where(table_id: @table.id).order('id')
      respond_to do |format|
        format.html # index.html.erb
      end

  end

  # GET /table_forms/1
  # GET /table_forms/1.json
  def show
    @table = IdentityTable.find_by_id(@identity_table.id)
    @table_form = TableForm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @table_form }
    end
  end

  # GET /table_forms/new
  # GET /table_forms/new.json
  def new

    @table = IdentityTable.find_by_id(@identity_table.id)
    @table_form = TableForm.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @table_form }
    end
  end

  # GET /table_forms/1/edit
  def edit

    @table = IdentityTable.find_by_id(@identity_table.id)

    @table_form = TableForm.find(params[:id])
  end

  # POST /table_forms
  # POST /table_forms.json
  def create

    @table_form = TableForm.new(params[:table_form])
    @table_form.table_id = params[:table_id]
    @table_form.value1 = params[:value1]
    @table_form.value2 = params[:value2]
    @table_form.value3 = params[:value3]
    @table_form.value4 = params[:value4]
    @table_form.value5 = params[:value5]
    @table_form.value6 = params[:value6]
    @table_form.value7 = params[:value7]
    @table_form.value8 = params[:value8]
    @table_form.value9 = params[:value9]
    @table_form.value10 = params[:value10]
    @table_form.value11 = params[:value11]
    @table_form.value12 = params[:value12]
    @table_form.value13 = params[:value13]
    @table_form.value14 = params[:value14]
    @table_form.value15 = params[:value15]
    @table_form.save
    flash[:alert] = '表单数据添加成功！'
    redirect_to identity_table_table_forms_path(@identity_table)

  end

  # PUT /table_forms/1
  # PUT /table_forms/1.json
  def update

    @table = IdentityTable.find_by_id(session[:table_id])
    @table_form = TableForm.find(params[:id])
    @table_form.value1 = params[:value1]
    @table_form.value2 = params[:value2]
    @table_form.value3 = params[:value3]
    @table_form.value4 = params[:value4]
    @table_form.value5 = params[:value5]
    @table_form.value6 = params[:value6]
    @table_form.value7 = params[:value7]
    @table_form.value8 = params[:value8]
    @table_form.value9 = params[:value9]
    @table_form.value10 = params[:value10]
    @table_form.value11 = params[:value11]
    @table_form.value12 = params[:value12]
    @table_form.value13 = params[:value13]
    @table_form.value14 = params[:value14]
    @table_form.value15 = params[:value15]
    @table_form.save
    flash[:alert] = '表单数据更新成功！'
    redirect_to identity_table_table_forms_path(@identity_table)

  end

  # DELETE /table_forms/1
  # DELETE /table_forms/1.json
  def destroy
    @table_form = TableForm.find(params[:id])
    @table_form.destroy

    respond_to do |format|
      format.html { redirect_to identity_table_table_forms_path(@identity_table), alert: '表单数据删除成功！' }
    end
  end

  def find_table_id
    @identity_table = IdentityTable.find(params[:identity_table_id])
  end

end
