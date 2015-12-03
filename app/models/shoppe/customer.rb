module Shoppe
  class Customer < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :confirmable,
           :recoverable, :rememberable, :trackable, :validatable

    self.table_name = "shoppe_customers"

    has_many :addresses, :dependent => :restrict_with_exception, :class_name => "Shoppe::Address"

    has_many :orders, :dependent => :restrict_with_exception, :class_name => "Shoppe::Order"

    # Validations
    validates :email, :presence => true, :uniqueness => true, :format => {:with => /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i}
    validates :phone, :format => {:with => /\A[+?\d\ \-x\(\)]{7,}\z/}, :allow_blank => true
    validates :first_name, :last_name, :presence => true
    validates :first_name, :last_name, :latin => true, :if => Proc.new{ Shoppe.settings.only_latin_address? }

    # All customers ordered by their ID desending
    scope :ordered, -> { order(:id => :desc)}
    # Customers subscribed to newsletter
    scope :subscribed, -> { where(:newsletter_subscribed => true)}

    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end

    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    def self.ransackable_attributes(auth_object = nil)
      ["id", "first_name", "last_name", "company", "email", "phone", "mobile"] + _ransackers.keys
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end

  end
end
