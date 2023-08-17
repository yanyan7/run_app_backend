class CreateDailies < ActiveRecord::Migration[7.0]
  def change
    create_table :dailies do |t|
      t.date :date, null: false
      t.references :sleep_pattern, foreign_key: true
      t.float :weight
      t.text :note
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end
