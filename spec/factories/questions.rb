FactoryGirl.define do
  factory :question do
    title   "QuestionTitle"
    text    "QuestionText"

    trait :closed do
      is_closed true
    end

    trait :unclosed do
      is_closed false
    end
  end
end