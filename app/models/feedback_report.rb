# Used for reporting only
class FeedbackReport < ActiveRecord::Base
  # Use associations just like any other ActiveRecord object
  belongs_to :feedback
  belongs_to :author
  belongs_to :talk
  belongs_to :club
  belongs_to :city
  belongs_to :technology

  self.table_name = 'mv_feedback_report'

  def self.repopulate
    connection.execute("REFRESH MATERIALIZED VIEW #{table_name}")
  end

  # materialized views cannot be changed
  def readonly
    true
  end
end