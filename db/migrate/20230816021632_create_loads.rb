class CreateLoads < ActiveRecord::Migration[7.0]
  def change
    create_table :loads do |t|
      t.string :name, null: false
      t.integer :sort, null: false

      t.timestamps
    end
  end
end
