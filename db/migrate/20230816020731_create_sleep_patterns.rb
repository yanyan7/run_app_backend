class CreateSleepPatterns < ActiveRecord::Migration[7.0]
  def change
    create_table :sleep_patterns do |t|
      t.string :name, null: false
      t.integer :sort, null: false

      t.timestamps
    end
  end
end
