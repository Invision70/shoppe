module Shoppe
  class State < ActiveRecord::Base
    self.table_name = 'shoppe_states'

    # All orders which have this state set as their billing state
    has_many :billed_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'billing_state_id'

    # All orders which have this state set as their delivery state
    has_many :delivered_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'delivery_state_id'

    # All states ordered by their name asending
    scope :ordered, -> { order(:name => :asc) }

    # Validations
    validates :name, :code, :presence => true

  end
end
