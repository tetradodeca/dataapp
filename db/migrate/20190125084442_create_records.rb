class CreateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :records do |t|
      t.integer :zone
      t.integer :time_start
      t.integer :time_end
      t.integer :total
      t.string :activity
      t.references :day, foreign_key: true

      t.timestamps
    end
  end
end
