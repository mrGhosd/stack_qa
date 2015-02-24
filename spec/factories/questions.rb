FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "QuestionTitle#{n}" }
    text    "QuestionText"
    rate 0

    trait :closed do
      is_closed true
    end

    trait :unclosed do
      is_closed false
    end
  end
end