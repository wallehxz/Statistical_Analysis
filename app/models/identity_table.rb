#encoding : utf-8
class IdentityTable < ActiveRecord::Base

  has_many :table_fields, :foreign_key => 'table_id',:dependent => :destroy
  has_many :table_forms, :foreign_key => 'table_id',:dependent => :destroy

  attr_accessible :table_name, :user_id

  validates_presence_of       :table_name ,:message =>'表名称为空！'
  validates_uniqueness_of    :table_name , :message =>'表名已经存在！'
end
