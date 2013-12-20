class Attendence < ActiveRecord::Base
  attr_accessible :event_id, :member_id, :state

  belongs_to :member
  belongs_to :event

  STATES = {
    0  => 'pending',
    10 => 'accepted',
    20 => 'rejected'
  }

  PENDING_STATE  = 0
  ACCEPTED_STATE = 10
  REJECTED_STATE = 20

  validates :state, presence: true, inclusion: {in: STATES.keys}

  validates :member, presence: true
  validates :event, presence: true

  validates :event_id, uniqueness: {scope: :member_id}

  def accept
    self.state = ACCEPTED_STATE
    self.save
  end

  def reject
    self.state = REJECTED_STATE
    self.save
  end

end
