class Club < ActiveRecord::Base
  belongs_to :city
  belongs_to :technology
  has_many :talks
end
