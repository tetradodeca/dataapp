class FeedpodDate < ApplicationRecord
  has_many :feedpodrecords, dependent: :destroy
  validates :date, presence: true

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << record_column_names = %w{id date created_at updated_at zone time_start time_end total activity}

      all.each do |date|
        date.feedpodrecords.each do |record|
          csv << date.attributes.values_at(*column_names)
          csv << record.attributes.values_at(*record_column_names)
        end
      end
    end
  end
end
