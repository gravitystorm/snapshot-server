# == Schema Information
#
# Table name: admins
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(128)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

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
