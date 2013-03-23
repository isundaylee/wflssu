class Notification < ActiveRecord::Base
  attr_accessible :content, :state, :link, :member_id

  belongs_to :member

  after_initialize :set_unread

  STATES = {
    0 => 'unread', 
    10 => 'read'
  }

  READ_STATE = 10
  UNREAD_STATE = 0

  validates :member, presence: true
  validates :content, length: {maximum: 100}
  validates :link, length: {maximum: 100}
  validates :state, presence: true, inclusion: {in: STATES.keys}

  private

    def set_unread
      self.state = Notification::UNREAD_STATE if self.new_record?
    end

end
