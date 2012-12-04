class Member < ActiveRecord::Base
  attr_accessible :admission_year, :birthday, :class_number, :code_number, :department_id, :email, :gender, :memo, :name, :password_digest, :phone_number, :qq, :remember_token, :secondary_school

  belongs_to :department

  EMAIL_REGEXP = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  DATE_REGEXP = /[0-9]{8,8}/i

  GENDERS = {
    0 => 'Unknown', 
    1 => 'Male', 
    2 => 'Female'
  }

  HUMANIZED_ATTRIBUTES = {
    qq: 'QQ',
    secondary_school: 'Secondary school name'
  }

  validates :name, presence: true, length: {in: 2..10}
  validates :admission_year, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 2011, less_than_or_equal_to: 9999} 
  validates :class_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 20}
  validates :phone_number, allow_blank: true, length: {in: 8..11}, numericality: {only_integer: true}
  validates :email, allow_blank: true, length: {in: 5..50}, format: {with: EMAIL_REGEXP}
  validates :gender, presence: true, inclusion: GENDERS.keys
  validates :qq, allow_blank: true, length: {in: 5..15}, numericality: {only_integer: true}
  validates_associated :department
  validates :secondary_school, allow_blank: true, length: {in: 1..100}
  validates :code_number, presence: true, length: {is: 7}, numericality: {only_integer: true}, uniqueness: true
  validate :code_number_is_valid
  validates :memo, allow_blank: true, length: {maximum: 2000} 

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  private

    def code_number_is_valid
      if self.code_number?
        code = self.code_number
        if self.admission_year? and self.admission_year.to_s != code.to_s[0...4]
          self.errors.add :code_number, 'doesn\'t match admission year. '
        end
      end
    end

end
