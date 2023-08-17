FactoryBot.define do
  factory :result do
    date { '2023/08/01' }
    temperature { 30 }
    content { 'Jog' }
    distance { 10.25 }
    time_h { 10 }
    time_m { 59 }
    time_s { 59 }
    pace_m { 59 }
    pace_s { 59 }
    place { '皇居' }
    shoes { 'ゲルカヤノ' }
    note { '疲れた' }
    deleted { 0 }

    association :daily, strategy: :create
    association :timing, strategy: :create
  end
end
