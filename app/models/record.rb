class Record < ApplicationRecord
  belongs_to :day
  validates :zone, presence: true
  validates :time_start, presence: true
  validates :time_end, presence: true
  validates :activity, presence: true

  before_save :calculate_total

  def calculate_total
    start_mins = time_start.to_s.split("")[-2, 3].join.to_i
    start_hours = time_start.to_s.split("")[0,2].join.to_i

    end_mins = time_end.to_s.split("")[-2, 3].join.to_i
    end_hours = time_end.to_s.split("")[0,2].join.to_i


    if start_mins > end_mins
      end_hours -= 1
      end_mins += 60
      minutes = (end_mins - start_mins).to_s
      hours = (end_hours - start_hours).to_s
      hours + "hours" + ":" + minutes + "minutes"
    else
      minutes = (end_mins - start_mins).to_s
      hours = (end_hours - start_hours).to_s
      hours + "hours" + ":" + minutes + "minutes"
    end

    self.total = (hours.to_i * 60) + minutes.to_i
  end

  # def self.to_csv(options = {})
  #   CSV.generate(options) do |csv|
  #     csv << column_names
  #     all.each do |col|
  #       csv << col.attributes.values_at(*column_names)
  #     end
  #   end
  # end
end
