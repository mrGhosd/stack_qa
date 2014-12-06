FactoryGirl.define do
  factory :user do
    surname   "Surname"
    name      "Name"
    email     "vforvad@gmail.com"
    password  "12345"

    trait :confirmed do
      is_confirmed true
    end

    trait :unconfirmed do
      is_confirmed false
    end
  end
end
