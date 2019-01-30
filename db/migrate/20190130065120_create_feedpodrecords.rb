class CreateFeedpodrecords < ActiveRecord::Migration[5.2]
  def change
    create_table :feedpodrecords do |t|
      t.string :zone
      t.integer :time_start
      t.integer :time_end
      t.integer :total
      t.string :activity
      t.references :feedpod_date, foreign_key: true

      t.timestamps
    end
  end
end
