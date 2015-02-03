FactoryGirl.define do
  factory :user do
    surname   "Surname"
    name      "Name"
    email     "vforvad@gmailadawdaw.com"
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
