namespace :fake_data do
  desc "Fill database with sample data"
  task populate: :environment do
    3000.times do |n|
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
        text = Faker::Lorem.characters
        Question.create!(title: title, text: text, user_id: User.last.id)

      end
    end
  end

  task after_deploy: :environment do

    # User.all.each do |user|
    #   user.remote_avatar_url = Faker::Avatar.image
    #   user.update(date_of_birth: Faker::Date.between(Random.rand(10000).days.ago, Date.today),
    #   place_of_birth: Faker::Address.city)
    # end

    Question.all.each do |question|
      # question.tag_list = Faker::Lorem.words(Random.rand(20)).join(',') if question.tag_list.blank?
      question.update!(category_id: Category.all.map(&:id).sample, rate: Random.rand(100), views: Random.rand(10000))
      10.times do |a|
        question.answers.create!(user_id: User.all.map(&:id).sample, text: Faker::Lorem.paragraph, rate: Random.rand(1000))
        10.times do |c|
          question.answers.last.comments.create!(text: Faker::Lorem.paragraph)
        end
      end
      10.times do |qc|
        question.comments.create!(text: Faker::Lorem.paragraph)
      end
    end
  end
end