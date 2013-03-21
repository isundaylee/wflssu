class Event < ActiveRecord::Base
  attr_accessible :memo, :on_date, :title

  has_many :attendences

  validates :title, presence: true, length: {in: 2..20}
  validates :on_date, presence: true
  validates :memo, allow_blank: true, length: {maximum: 2000}
end
