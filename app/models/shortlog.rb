class Shortlog < ActiveRecord::Base
  attr_accessible :content, :member_id

  belongs_to :member

  validates :member, presence: true

  validates :content, presence: true, length: {in: 2..200}
end
