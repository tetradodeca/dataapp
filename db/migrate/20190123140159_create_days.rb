class CreateDays < ActiveRecord::Migration[5.2]
  def change
    create_table :days do |t|
      t.integer :date

      t.timestamps
      # t.references :user, foreign_key: true
    end
  end
end
