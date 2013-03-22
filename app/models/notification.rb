class Notification < ActiveRecord::Base
  attr_accessible :content, :link, :member_id

  belongs_to :member

  validates :member, presence: true
  validates :content, length: {maximum: 100}
  validates :link, length: {maximum: 100}
end
