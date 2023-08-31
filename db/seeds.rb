# テーブルデータを削除
Result.delete_all
Daily.delete_all
Load.delete_all
Timing.delete_all
SleepPattern.delete_all
User.delete_all

# オートインクリメントをリセット
def reset_id(tablename)
  connection = ActiveRecord::Base.connection()
  connection.execute("ALTER TABLE #{tablename} auto_increment = 1;")
end
reset_id('results')
reset_id('dailies')
reset_id('loads')
reset_id('timings')
reset_id('sleep_patterns')
reset_id('users')

# データを追加

# usersテーブル
User.create!(
  email: 'test@example.com',
  password: 'Pass1234'
)
User.create!(
  email: 'test2@example.com',
  password: 'Pass1234'
)

# sleep_patternsテーブル
SleepPattern.create!(
  name: '◯',
  sort: 1
)
SleepPattern.create!(
  name: '△',
  sort: 2
)
SleepPattern.create!(
  name: '✕',
  sort: 3
)

# timingsテーブル
Timing.create!(
  name: '早朝',
  sort: 1
)
Timing.create!(
  name: '午前',
  sort: 2
)
Timing.create!(
  name: '午後',
  sort: 3
)

# loadsテーブル
Load.create!(
  name: '高',
  sort: 1
)
Load.create!(
  name: '中',
  sort: 2
)
Load.create!(
  name: '低',
  sort: 3
)

# dailiesテーブル
Daily.create!(
  user_id: 1,
  date: '2023/08/01',
  sleep_pattern_id: 1,
  weight: 51,
  note: '仕事が忙しかった',
  deleted: 0
)
Daily.create!(
  user_id: 1,
  date: '2023/08/02',
  sleep_pattern_id: 2,
  weight: 50.5,
  note: '平和な一日だった',
  deleted: 0
)
Daily.create!(
  user_id: 2,
  date: '2023/08/03',
  sleep_pattern_id: 3,
  weight: nil,
  note: nil,
  deleted: 0
)

# resultsテーブル
Result.create!(
  user_id: 1,
  daily_id: 1,
  date: '2023/08/01',
  temperature: 32,
  timing_id: 1,
  content: 'Jog',
  distance: 10,
  time_h: 1,
  time_m: 10,
  time_s: 0,
  pace_m: 7,
  pace_s: 30,
  place: '皇居',
  shoes: 'ゲルカヤノ29',
  note: '脚が疲れた',
  deleted: 0
)
Result.create!(
  user_id: 1,
  daily_id: 2,
  date: '2023/08/02',
  temperature: 31,
  timing_id: 2,
  content: 'アップ',
  distance: 2,
  time_h: 0,
  time_m: 15,
  time_s: 0,
  pace_m: 7,
  pace_s: 10, 
  place: '旧江戸川',
  shoes: 'ライバルフライ3',
  note: nil,
  deleted: 0
)
Result.create!(
  user_id: 1,
  daily_id: 2,
  date: '2023/08/02',
  temperature: 31,
  timing_id: 2,
  content: '閾値走',
  distance: 8,
  time_h: 0,
  time_m: 37,
  time_s: 15,
  pace_m: 4,
  pace_s: 40, 
  place: '旧江戸川',
  shoes: 'ライバルフライ3',
  note: nil,
  deleted: 0
)
Result.create!(
  user_id: 1,
  daily_id: 2,
  date: '2023/08/02',
  temperature: 31,
  timing_id: 2,
  content: 'ダウン',
  distance: 2,
  time_h: 0,
  time_m: 13,
  time_s: 0,
  pace_m: 7,
  pace_s: 0, 
  place: '旧江戸川',
  shoes: 'ライバルフライ3',
  note: nil,
  deleted: 0
)
Result.create!(
  user_id: 2,
  daily_id: 3,
  date: '2023/08/03',
  temperature: nil,
  timing_id: 3,
  content: '補強運動',
  distance: nil,
  time_h: nil,
  time_m: nil,
  time_s: nil,
  pace_m: nil,
  pace_s: nil, 
  place: nil,
  shoes: nil,
  note: '腹に効いた',
  deleted: 0
)
