class Month < ApplicationRecord
  has_many :runs
  belongs_to :user 
end
