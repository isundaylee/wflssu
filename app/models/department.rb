class Department < ActiveRecord::Base
  attr_accessible :name

  has_many :members

  validates :name, presence: true, length: {maximum: 50}

  def self.names
    @departments = self.all
    names = {} 
    @departments.each do |department|
      names[department.id] = department.name
    end
    names
  end
end
