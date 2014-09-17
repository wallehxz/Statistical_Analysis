#encoding : utf-8
class TableField < ActiveRecord::Base

  belongs_to :identity_table, :foreign_key => 'table_id'
  has_many :field_items, :foreign_key => 'field_id', :dependent => :destroy

  attr_accessible :field_name, :field_type, :table_id, :field_turn

  validates_presence_of       :field_name ,:message =>'字段名称不能为空！'
  validates_presence_of       :field_type ,:message =>'字段类型不能为空！'
end
