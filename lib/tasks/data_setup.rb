100.times { Author.create(name: Faker::Name.name) }

Club.all.each do |club|
  200.times do
    rand_author = Author.offset(rand(Author.count)).first
    club.talks.create(author: rand_author, name: Faker::Hacker.say_something_smart.truncate(255))
  end
end


def invalid_comment
  Feedback::INVALID_COMMENTS[rand(Feedback::INVALID_COMMENTS.count)]
end

def valid_comment
  Faker::Lorem.sentence.truncate(255)
end

def generate_comment
  (2 == rand(4)) ? invalid_comment : valid_comment
end

Talk.all.each do |talk|
  200.times do
    comment = generate_comment
    Feedback.create(score: rand(5), comment: comment)
  end
end


city = City.find_by(name: 'Philadelphia')
city.clubs.each do |club|
  1_000.times do
    talk = club.talks.offset(rand(club.talks.count)).first
    talk.feedbacks.create(score: rand(5), comment: generate_comment)
  end
end