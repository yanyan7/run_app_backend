FactoryBot.define do
  factory :user do
    email                 { Faker::Internet.email }
    password              { 'aaBB1234' }
    # password_confirmation { password }
  end
end