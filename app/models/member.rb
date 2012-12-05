class Member < ActiveRecord::Base
  attr_accessible :admission_year, :birthday, :class_number, :code_number, :department_id, :email, :gender, :memo, :name, :password_digest, :phone_number, :qq, :remember_token, :secondary_school, :password, :password_confirmation, :privilege

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

  PRIVILEGES = {
    0 => 'Member', 
    10 => 'Vice Deparmental President', 
    15 => 'Departmental President', 
    20 => 'Vice President', 
    25 => 'President', 
    100 => 'Administrator'
  }

  MEMBER_PRIVILEGE = 0
  VICE_DPRESIDENT_PRIVILEGE = 10
  DPRESIDENT_PRIVILEGE = 15
  VICE_PRESIDENT_PRIVILEGE = 20
  PRESIDENT_PRIVILEGE = 25
  ADMINISTRATOR_PRIVILEGE = 100

  has_secure_password

  validates :name, presence: true, length: {in: 2..10}
  validates :admission_year, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 2011, less_than_or_equal_to: 9999} 
  validates :class_number, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 20}
  validates :phone_number, allow_blank: true, length: {in: 8..11}, numericality: {only_integer: true}
  validates :email, allow_blank: true, length: {in: 5..50}, format: {with: EMAIL_REGEXP}
  validates :gender, presence: true, inclusion: {in: GENDERS.keys, message: 'is invalid. '}
  validates :qq, allow_blank: true, length: {in: 5..15}, numericality: {only_integer: true}
  validates_associated :department
  validates :secondary_school, allow_blank: true, length: {in: 1..100}
  validates :code_number, presence: true, length: {is: 7}, numericality: {only_integer: true}, uniqueness: true
  validate :code_number_is_valid
  validates :memo, allow_blank: true, length: {maximum: 2000} 

  validates :password, length: {in: 6..30, if: :password_changed?}
  validates :password_confirmation, presence: {if: :password_changed?}
  validates :privilege, presence: true, inclusion: {in: PRIVILEGES.keys, message: 'is invalid. '}

  before_save :create_remember_token

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def has_privilege_of?(privilege)
    self.privilege >= privilege
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

    def password_changed? 
      !self.password.blank?
    end

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
