#encoding : utf-8
class FieldItem < ActiveRecord::Base
  belongs_to :table_field, :foreign_key => 'field_id'
  attr_accessible :field_id, :item_name, :item_turn
end
