FactoryGirl.define do
  factory :user do
    sequence(:surname)  { |n| "Surname#{n}" }
    name      "Name"
    sequence(:email)    { |n| "vforvad#{n}@gmail.com" }
    password  "12345"

    trait :confirmed do
      is_confirmed true
    end

    trait :unconfirmed do
      is_confirmed false
    end

    trait :admin do
      role "admin"
    end
  end
end
