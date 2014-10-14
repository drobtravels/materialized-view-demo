class TalkReport < ActiveRecord::Base
  # Use associations just like any other ActiveRecord object
  belongs_to :author
  belongs_to :talk
  belongs_to :club
  belongs_to :city
  belongs_to :technology
  # take advantage of talks has_many relationship
  delegate :feedbacks, to: :talk

  self.table_name = 'mv_talks_report'

  def self.repopulate
    connection.execute("REFRESH MATERIALIZED VIEW #{table_name}")
  end
  
  # views cannot be changed since they are virtual
  def readonly
    true
  end
end