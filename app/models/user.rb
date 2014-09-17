#encoding : utf-8
class User < ActiveRecord::Base

  attr_accessible :account, :lately_login, :name, :password, :phone, :picture, :role, :sign_time, :password_confirmation

  validates :name, presence: true ,:on => :create
  validates :account, presence: true ,:on => :create
  validates :account, length: {minimum: 6} ,:on => :create
  validates :account, uniqueness: true ,:on => :create
  validates :password, presence: true ,:on => :create
  validates :password, length: {minimum: 6} ,:on => :create
  validates :password, confirmation: true ,:on => :create
  validates :password_confirmation, presence: true ,:on => :create
  validates :role, presence: true ,:on => :create

end
