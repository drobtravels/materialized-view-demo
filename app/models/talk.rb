class Talk < ActiveRecord::Base
  belongs_to :club
  belongs_to :author
  has_many :feedbacks
end
