#encoding : utf-8
class TableForm < ActiveRecord::Base
  belongs_to :identity_table, :foreign_key => 'table_id'
  attr_accessible :table_id, :value1, :value10, :value11, :value12, :value13, :value14, :value15,
                  :value2, :value3, :value4, :value5, :value6, :value7, :value8, :value9
end
