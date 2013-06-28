class Member < ActiveRecord::Base
  attr_accessible :admission_year, :birthday, :class_number, :code_number, :department_id, :email, :gender, :memo, :name, :password_digest, :phone_number, :qq, :remember_token, :secondary_school, :password, :password_confirmation, :privilege, :active

  belongs_to :department
  has_many :shortlogs, dependent: :destroy 
  has_many :attendences, dependent: :destroy
  has_many :notifications, dependent: :destroy

  scope :active, -> { where(active: true) }

  after_initialize :default_values

  EMAIL_REGEXP = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
  DATE_REGEXP = /[0-9]{8,8}/i

  GENDERS = {
    0 => 'unknown',
    1 => 'male',
    2 => 'female'
  }

  PRIVILEGES = {
    0 => 'member', 
    10 => 'vice_dpresident', 
    15 => 'dpresident', 
    20 => 'vice_president', 
    25 => 'president', 
    100 => 'administrator'
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
  validates :gender, presence: true, inclusion: {in: GENDERS.keys, message: I18n.t('models.member.validation_message_is_invalid')}
  validates :qq, allow_blank: true, length: {in: 5..15}, numericality: {only_integer: true}
  validates_associated :department
  validates :secondary_school, allow_blank: true, length: {in: 1..100}
  validates :code_number, presence: true, length: {is: 7}, numericality: {only_integer: true}, uniqueness: true
  validate :code_number_is_valid
  validates :memo, allow_blank: true, length: {maximum: 2000} 
  validates :sms_balance, numericality: {only_integer: true}

  validates :password, length: {in: 6..30, if: :password_changed?}
  validates :password_confirmation, presence: {if: :password_changed?}
  validates :privilege, presence: true, inclusion: {in: PRIVILEGES.keys, message: I18n.t('models.member.validation_message_is_invalid')}

  before_save :create_remember_token
  before_save :generate_shortlogs

  def has_privilege_of?(privilege)
    self.privilege >= privilege
  end

  def attend(event)
    attendence = Attendence.new

    attendence.member = self
    attendence.event = event
    attendence.state = Attendence::PENDING_STATE

    attendence.save
  end

  def has_attended?(event)
    self.attendences.map { |a| a.event }.include?(event)
  end

  def unread_notifications_count
    self.notifications.select { |n| n.state == Notification::UNREAD_STATE }.count
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

    def generate_shortlogs
      return if self.new_record?

      if self.privilege_changed?
        old = self.privilege_was
        now = self.privilege

        self.shortlogs.create(content: "Position Change: #{PRIVILEGES[old]} -> #{PRIVILEGES[now]}")
      end

      if self.department_id_changed? 
        old = self.department_id_was
        now = self.department_id

        self.shortlogs.create(content: "Department Change: #{Department.find(old).name} -> #{Department.find(now).name}")
      end
    end

    def default_values
      self.sms_balance = 0 if self.new_record?
      self.active = true if self.new_record? 
    end

end
