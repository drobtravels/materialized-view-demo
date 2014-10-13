class City < ActiveRecord::Base
  has_many :clubs

  def to_s
    "#{name}, #{state_abbr}"
  end
end
