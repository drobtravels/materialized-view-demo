class CreateFeedbackReportMv < ActiveRecord::Migration
  def up
    connection.execute <<-SQL
      CREATE MATERIALIZED VIEW mv_feedback_report AS
        SELECT  cities.id as city_id,
                cities.name as city_name,
                cities.state_abbr as state_abbr,
                technologies.id as technology_id,
                clubs.id as club_id,
                clubs.name as club_name,
                talks.id as talk_id,
                talks.name as talk_name,
                authors.id as author_id,
                authors.name as author_name,
                feedbacks.id as feedback_id,
                feedbacks.score as score,
                feedbacks.comment as comment
        FROM feedbacks
        INNER JOIN talks ON feedbacks.talk_id = talks.id
        INNER JOIN authors ON talks.author_id = authors.id
        INNER JOIN clubs ON talks.club_id = clubs.id
        INNER JOIN cities ON clubs.city_id = cities.id
        INNER JOIN technologies ON clubs.technology_id = technologies.id
        WHERE feedbacks.comment NOT IN ('', 'NA', 'N/A', 'not applicable')
    SQL
  end

  def down
    connection.execute 'DROP MATERIALIZED VIEW IF EXISTS mv_feedback_report'
  end
end
