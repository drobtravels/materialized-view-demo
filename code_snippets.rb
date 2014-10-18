# Highest Scoring Talk, only count filled out comments

577ms
results = Feedback.filled_out \
  .select('talk_id, avg(score) as overall_score') \
  .group('talk_id').order('overall_score desc') \
  .limit(10)

results.first.inspect


1ms
results = TalkReport.order(overall_score: :desc) \
          .limit(10)

<<-SQL
  # without materializved view - 665ms
  SELECT talk_id, avg(score) as overall_score FROM "feedbacks"
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  GROUP BY talk_id  ORDER BY overall_score desc LIMIT 10;

  # with materializved view - <1ms
  SELECT * FROM mv_talks_report ORDER BY overall_score desc LIMIT 10;
SQL

# Worst talks in Philly, only count filled out comments
Feedback.filled_out.joins(talk: { club: :city } ) \
  .select('feedbacks.talk_id, avg(feedbacks.score) as overall_score') \
  .where("cities.name = '?'", 'Philadelphia') \
  .group('feedbacks.talk_id') \
  .order('overall_score asc') \
  .limit(10)

<<-SQL
  # no materializved view - 430ms
  SELECT feedbacks.talk_id, avg(feedbacks.score) as overall_score FROM "feedbacks"
  INNER JOIN "talks" ON "talks"."id" = "feedbacks"."talk_id"
  INNER JOIN "clubs" ON "clubs"."id" = "talks"."club_id"
  INNER JOIN "cities" ON "cities"."id" = "clubs"."city_id"
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  AND (cities.name = 'Philadelphia')
  GROUP BY feedbacks.talk_id  ORDER BY overall_score asc LIMIT 10;

  # materializved view - <1ms
  SELECT * FROM mv_talks_report WHERE city_name = 'Philadelphia' ORDER BY overall_score asc LIMIT 10;
SQL

# Top Talks in PA by autheors named Parker
400ms
Feedback.filled_out.joins(talk: [:author, { club: :city }] ) \
  .select('feedbacks.talk_id, avg(feedbacks.score) as overall_score') \
  .where("cities.state_abbr = ?", 'PA') \
  .where("authors.name LIKE '%?%'", 'Parker') \
  .group('feedbacks.talk_id') \
  .order('overall_score desc') \
  .limit(10)

19ms
TalkReport.where(state_abbr: 'PA') \
  .where("author_name LIKE '%?%'", 'Parker') \
  .order(overall_score: :desc).limit(10)


<<-SQL
  # no materialized view - 450ms
  SELECT  feedbacks.talk_id, avg(feedbacks.score) as overall_score FROM "feedbacks"
  INNER JOIN "talks" ON "talks"."id" = "feedbacks"."talk_id"
  INNER JOIN "authors" ON "authors"."id" = "talks"."author_id"
  INNER JOIN "clubs" ON "clubs"."id" = "talks"."club_id"
  INNER JOIN "cities" ON "cities"."id" = "clubs"."city_id"
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  AND (cities.state_abbr = 'PA')
  AND (authors.name LIKE '%Parker%')
  GROUP BY feedbacks.talk_id  ORDER BY overall_score desc LIMIT 10;

  # materializved view -13ms
  SELECT * FROM mv_talks_report
  WHERE state_abbr = 'PA'
  AND author_name LIKE '%Parker%'

SQL



Feedback.filled_out

<<-SQL
  # no materialized view - 410ms
  SELECT "feedbacks".* FROM "feedbacks"  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'));

  # with materializved view - 175ms
  SELECT * FROM mv_feedback_report;
SQL

Feedback.filled_out.joins(talk: :author) \
  .where("authors.name = ?", 'Rhiannon Parker')

<<-SQL
  # no materialized view - 680ms
  SELECT "feedbacks".* FROM "feedbacks" 
  INNER JOIN "talks" ON "talks"."id" = "feedbacks"."talk_id"
  INNER JOIN "authors" ON "authors"."id" = "talks"."author_id" 
  WHERE ("feedbacks"."comment" NOT IN ('', 'NA', 'N/A', 'not applicable'))
  AND (authors.name = 'Rhiannon Parker');

  # materializved view - 245ms
  SELECT * FROM mv_feedback_report where author_name = 'Rhiannon Parker';
SQL


Feedback.filled_out.joins(talk: { club: :city } ) \
  .where("cities.name = ?", 'Philadelphia')

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
  .where("cities.state_abbr = ?", 'PA') \
  .where("feedbacks.comment LIKE '%?%'", 'ipsum') \
  .where("authors.name LIKE '%?%'", 'Parker')

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
