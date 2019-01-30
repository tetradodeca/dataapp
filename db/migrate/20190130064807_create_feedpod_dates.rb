class CreateFeedpodDates < ActiveRecord::Migration[5.2]
  def change
    create_table :feedpod_dates do |t|
      t.integer :date

      t.timestamps
    end
  end
end
