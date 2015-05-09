namespace :fake_data do
  desc "Fill database with sample data"
  task populate: :environment do
    10.times do |n|
      Category.create!(title: Faker::Lorem.words(1).join,
                      description: Faker::Lorem.paragraph)
      Category.last.remote_image_url = Faker::Avatar.image
    end
    300.times do |n|
      name  = Faker::Name.first_name
      surname = Faker::Name.last_name
      email = "#{Faker::Internet.email}"
      password  = "password"
      User.create!(name: name,
                   surname: surname,
                   email: email,
                   password: password,
                   password_confirmation: password,
                   date_of_birth: Faker::Date.between(Random.rand(10000).days.ago, Date.today),
                   place_of_birth: Faker::Address.city)
      User.last.remote_avatar_url = Faker::Avatar.image
      5.times do |q|
        title = "#{Faker::Hacker.say_something_smart} - #{q}"
        text = Faker::Lorem.paragraph * 5
        Question.create!(title: title, text: text, user_id: User.last.id,
                         category_id: Category.all.map(&:id).sample,
                         rate: Random.rand(100), views: Random.rand(10000))
        5.times do |n|
          Question.last.answers.create!(user_id: User.last.id, text: Faker::Lorem.paragraph, rate: Random.rand(1000))

          5.times do |n|
            Question.last.answers.last.comments.create!(user_id: User.last.id, text: Faker::Lorem.paragraph)
          end
        end
        5.times do |n|
          Question.last.comments.create!(user_id: User.last.id, text: Faker::Lorem.paragraph)
        end
      end
    end
  end
end