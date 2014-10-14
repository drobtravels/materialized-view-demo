Feedback.filled_out

<<-SQL
  # no materialized view - 410ms
  SELECT "feedbacks".* FROM "feedbacks"  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'));

  # with materializved view - 175ms
  SELECT * FROM mv_feedback_report;
SQL

Feedback.filled_out.joins(talk: :author) \
  .where("authors.name = 'Rhiannon Parker'")

<<-SQL
  # no materialized view - 520ms
  SELECT "feedbacks".* FROM "feedbacks" 
  INNER JOIN "talks" ON "talks"."id" = "feedbacks"."talk_id"
  INNER JOIN "authors" ON "authors"."id" = "talks"."author_id" 
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  AND (authors.name = 'Rhiannon Parker');

  # materializved view - 265ms
  SELECT * FROM mv_feedback_report where author_name = 'Rhiannon Parker';
SQL


Feedback.filled_out.joins(talk: { club: :city } ) \
  .where("cities.name = 'Philadelphia'")

<<-SQL
  # no materialized view - 600ms
  SELECT "feedbacks".* FROM "feedbacks"
  INNER JOIN "talks" ON "talks"."id" = "feedbacks"."talk_id"
  INNER JOIN "clubs" ON "clubs"."id" = "talks"."club_id"
  INNER JOIN "cities" ON "cities"."id" = "clubs"."city_id"
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  AND (cities.name = 'Philadelphia');

  # materialized view - 200ms
  SELECT * FROM mv_feedback_report WHERE city_name = 'Philadelphia';
SQL

Feedback.filled_out.joins(talk: [:author, { club: :city }] ) \
  .where("cities.state_abbr = 'PA'") \
  .where("feedbacks.comment LIKE '%ipsum%'") \
  .where("authors.name LIKE '%Parker%'")

<<-SQL
  # no materialized view - 436ms
  SELECT "feedbacks".* FROM "feedbacks"
  INNER JOIN "talks" ON "talks"."id" = "feedbacks"."talk_id"
  INNER JOIN "authors" ON "authors"."id" = "talks"."author_id"
  INNER JOIN "clubs" ON "clubs"."id" = "talks"."club_id"
  INNER JOIN "cities" ON "cities"."id" = "clubs"."city_id"
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  AND (cities.state_abbr = 'PA')
  AND (feedbacks.comment LIKE '%ipsum%')
  AND (authors.name LIKE '%Parker%')

  # materializved view - 
  SELECT * FROM mv_feedback_report
  WHERE state_abbr = 'PA'
  AND comment LIKE '%ipsum%'
  AND author_name LIKE '%Parker%';
SQL
