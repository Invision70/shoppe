module Shoppe
  class OrderItem < ActiveRecord::Base
    def self.item_exists(ordered_item)
      self.where(:ordered_item_id => ordered_item.id, :ordered_item_type => ordered_item.class.to_s, :gift => false).first
    end
  end
end
