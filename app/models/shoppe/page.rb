module Shoppe
  class Page < ActiveRecord::Base
    # Validations
    validates :title, :permalink, :content, :presence => true
    validates :permalink, :uniqueness => true

    # All pages ordered by priority desending
    scope :ordered, -> { order(:priority => :desc)}
    scope :published, -> { where(:published => true)}
    scope :menu, -> { where(:show_menu => true)}

    def menu_title
      if read_attribute(:menu_title).present?
        read_attribute(:menu_title)
      else
        self.title
      end
    end

  end
end
