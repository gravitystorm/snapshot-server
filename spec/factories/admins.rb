
FactoryGirl.define do
  factory :admin do
    sequence(:email) {|n| "user#{n}@example.com" }
    sequence(:password) {|n| "password#{n}" }
    sequence(:password_confirmation) {|n| "password#{n}" }

    factory :stewie do
      email "stewie@example.com"
      password "Victory is mine!"
      password_confirmation "Victory is mine!"

      factory :stewie_with_profile, traits: [:with_profile]
    end
  end
end
