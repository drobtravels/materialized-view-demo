class Author < ActiveRecord::Base
  has_many :talks
end
