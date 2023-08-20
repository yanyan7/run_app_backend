FactoryBot.define do
  factory :daily do
    date { '2023/08/01' }
    weight { 50.1 }
    note { '備考' }
    deleted { 0 }

    association :user, strategy: :create
    association :sleep_pattern, strategy: :create
  end
end
