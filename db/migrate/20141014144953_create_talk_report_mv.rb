class CreateTalkReportMv < ActiveRecord::Migration
  def up
    connection.execute <<-SQL
      CREATE MATERIALIZED VIEW mv_talks_report AS
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
                      feedback_agg.overall_score as overall_score
              FROM (
                  SELECT talk_id, avg(score) as overall_score
                  FROM feedbacks
                  WHERE feedbacks.comment NOT IN ('', 'NA', 'N/A', 'not applicable')
                  GROUP BY talk_id
              ) as feedback_agg
              INNER JOIN talks ON feedback_agg.talk_id = talks.id
              INNER JOIN authors ON talks.author_id = authors.id
              INNER JOIN clubs ON talks.club_id = clubs.id
              INNER JOIN cities ON clubs.city_id = cities.id
              INNER JOIN technologies ON clubs.technology_id = technologies.id;
      CREATE INDEX ON mv_talks_report (overall_score);
    SQL
  end

  def down
    connection.execute 'DROP MATERIALIZED VIEW IF EXISTS mv_talks_report'
  end
end
