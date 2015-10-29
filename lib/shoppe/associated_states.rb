module Shoppe
  module AssociatedStates
    
    def self.included(base)
      base.serialize :state_ids, Array
      base.before_validation { self.state_ids = self.state_ids.map(&:to_i).select { |i| i > 0} if self.state_ids.is_a?(Array) }
    end
    
    def state?(id)
      id = id.id if id.is_a?(Shoppe::State)
      self.state_ids.is_a?(Array) && self.state_ids.include?(id.to_i)
    end
    
    def states
      return [] unless self.state_ids.is_a?(Array) && !self.state_ids.empty?
      Shoppe::State.where(:id => self.state_ids)
    end
    
  end
end