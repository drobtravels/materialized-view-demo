class Feedback < ActiveRecord::Base
  belongs_to :talk
  INVALID_COMMENTS = ['', 'NA', 'N/A', 'not applicable']

  scope :filled_out,
    -> { where.not(comment: INVALID_COMMENTS) }

  scope :no_feedback,
    -> { where(comment: INVALID_COMMENTS) }
end
