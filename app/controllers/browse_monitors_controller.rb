#encoding: utf-8
require 'to_xls'
require 'will_paginate'
class BrowseMonitorsController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:create]

  def index

    date = Time.now.strftime('%Y-%m-%d')
    @browse_monitors = BrowseMonitor.where("upload='#{date}'").
        order('visit_datetime DESC').
        paginate :page=> params[:page],
                 :per_page => 50
    @all_browse = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').
        where("upload='#{date}'")
    respond_to do |format|
      format.html
      format.xls {send_data @all_browse.to_xls, :filename => "网页浏览时间降序#{date}.xls"}
    end
  end

  def show
    @browse_monitor = BrowseMonitor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @browse_monitor }
    end
  end

  def create

    visit_ip = params[:visit_ip].to_s
    if  visit_ip  == '124.193.181.130'
    elsif visit_ip  == '202.142.16.146'
    else
      @browse_monitor = BrowseMonitor.new(params[:browse_monitor])
      @browse_monitor.load_time = params[:load_time]
      @browse_monitor.page_url = params[:page_url]
      @browse_monitor.visit_datetime = Time.now
      @browse_monitor.visit_city = params[:visit_city]
      @browse_monitor.visit_ip = params[:visit_ip]
      @browse_monitor.upload = Time.now.strftime('%Y-%m-%d')
      @browse_monitor.save
    end

  end

  def destroy
    @browse_monitor = BrowseMonitor.find(params[:id])
    @browse_monitor.destroy

    respond_to do |format|
      format.html { redirect_to browse_monitors_url }
      format.json { head :no_content }
    end
  end
  #按照加载时间，升序排列
  def load_ace
    date = Time.now.strftime('%Y-%m-%d')
    @load_ace = BrowseMonitor.where("upload='#{date}'").
        order('load_time').
        paginate :page=> params[:page],
                 :per_page => 50
    @l_ace = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').where("upload='#{date}'").order('load_time')
    respond_to do |format|
      format.html # index.html.erb
      format.xls {send_data @l_ace.to_xls, :filename => "网页加载速率升序#{date}.xls"}
    end
  end

  #按照加载时间，降序排列
  def load_desc

    date = Time.now.strftime('%Y-%m-%d')
    @load_desc = BrowseMonitor.where("upload='#{date}'").
        order('load_time DESC').
        paginate :page=> params[:page],
                 :per_page => 50
    @l_desc = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').where("upload='#{date}'").order('load_time  DESC')
    respond_to do |format|
      format.html # index.html.erb
      format.xls {send_data @l_desc.to_xls, :filename => '网页加载速率降序.xls'}
    end
  end

  #按照浏览时间，升序排列
  def visit_ace
    date = Time.now.strftime('%Y-%m-%d')
    @visit_ace = BrowseMonitor.where("upload='#{date}'").
        order('visit_datetime').
        paginate :page=> params[:page],
                 :per_page => 50
    @v_ace = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').where("upload='#{date}'").order('visit_datetime')
    respond_to do |format|
      format.html # index.html.erb
      format.xls {send_data @v_ace.to_xls, :filename => "网页浏览时间升序#{date}.xls"}
    end
  end

  #能进行网站名称匹配查询，日期时间时段查询，同时进行网站在某一段时间的查询
  def site_time
    @site_word  = params[:word]
    @site_start = params[:start_time]
    @site_end    = params[:end_time]
    #如果没有网站名称，则进行时间段查询
    if @site_word.blank? && @site_start.blank? && @site_end.blank?
      #三个参数都为空时
      flash[:alert]='请输入查询名称及时间区间！'
      redirect_to browse_monitors_path
    elsif @site_word.blank?
      #名称为空，时间区间选择不全
      if @site_start.blank? || @site_end.blank?
        flash[:alert]='请选择合适的时间区间！'
        redirect_to browse_monitors_path
      else
        @site_times = BrowseMonitor.where("upload between '#{params[:start_time]}' and '#{params[:end_time]}'").
            order('id DESC').
            paginate :page=> params[:page],
                     :per_page => 50
        @site_time_xls = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').
            where("upload between '#{params[:start_time]}' and '#{params[:end_time]}'").
            order('visit_datetime DESC')
        if @site_times.count == 0
          flash[:alert] = '当前时段区间没有数据，请调整区间！'
          redirect_to browse_monitors_path
        else
          respond_to do |format|
            format.html # index.html.erb
            format.xls {send_data @site_time_xls.to_xls, :filename => '时间区间.xls'}
          end
        end
      end
      #----------------------------------------------------------------------
    elsif @site_start.blank? || @site_end.blank?
      if @site_word.blank?
        flash[:alert]='请选择合适的时间区间！'
        redirect_to browse_monitors_path
      else
        @site_times = BrowseMonitor.where("page_url like '%#{params[:word]}%'").
            order('id DESC').
            paginate :page=> params[:page],
                     :per_page => 50
        @site_time_xls = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').
            where("page_url like '%#{params[:word]}%'").
            order('visit_datetime DESC')
        if @site_times.count == 0
          flash[:alert]='请填写合适的网站名称！'
          redirect_to browse_monitors_path
        else
          respond_to do |format|
            format.html # index.html.erb
            format.xls {send_data @site_time_xls.to_xls, :filename => '网站名称.xls'}
          end
        end
      end
      #----------------------------------------------------------------------
    else
      @site_times = BrowseMonitor.where("upload between '#{params[:start_time]}' and '#{params[:end_time]}'").
          where("page_url like '%#{params[:word]}%'").
          order('id DESC').
          paginate :page=> params[:page],
                   :per_page => 50
      @site_time_xls = BrowseMonitor.select('page_url, load_time, visit_datetime,visit_ip,visit_city').
          where("upload between '#{params[:start_time]}' and '#{params[:end_time]}'").
          where("page_url like '%#{params[:word]}%'").
          order('visit_datetime DESC')
      if @site_times.count == 0
        flash[:alert]='没有找到对应的网址和时间区间！'
        redirect_to browse_monitors_path
      else
        respond_to do |format|
          format.html # index.html.erb
          format.xls {send_data @site_time_xls.to_xls, :filename => '网站区间.xls'}
        end
      end
    end

  end

  def date_destroy
    if params[:start_time].blank? || params[:end_time].blank?
      flash[:error] = '请选择要删除时间区间~！'
      redirect_to users_path
    else
      @date_destroy = BrowseMonitor.where("upload between '#{params[:start_time]}' and '#{params[:end_time]}'")
      number = @date_destroy.count
      if @date_destroy.count == 0
        flash[:alert] = '糟糕！没有这段时间的数据~！'
        redirect_to users_path
      else
        @date_destroy.each do |item|
          item.destroy
        end
        flash[:success] = "一共删除【#{number}】条数据~！"
        redirect_to browse_monitors_path
      end
    end

  end

end
