# encoding: utf-8
class HomeController < ApplicationController
  before_filter :user_login!
    def index
    end
end
