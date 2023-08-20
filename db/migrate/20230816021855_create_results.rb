class CreateResults < ActiveRecord::Migration[7.0]
  def change
    create_table :results do |t|
      t.references :daily, foreign_key: true
      t.references :user, foreign_key: true
      t.date :date, null: false
      t.integer :temperature
      t.references :timing, foreign_key: true
      t.text :content
      t.float :distance
      # t.string :time
      # t.string :pace
      t.integer :time_h
      t.integer :time_m
      t.integer :time_s
      t.integer :pace_m
      t.integer :pace_s
      t.string :place
      t.string :shoes
      t.text :note
      t.integer :deleted, null: false, default: 0

      t.timestamps
    end
  end
end
