class StaticsController < ApplicationController

  def exhibit
  end

  def visual
    @visual = true
    @daily_total_feeding_times = Record.group(:day_id).where(activity: ["Feeding", "Scatter Feed"]).sum(:total)
    @feedpod_daily_total_feeding_times = Feedpodrecord.group(:feedpod_date_id).where(activity: ["Feeding", "Scatter Feed"]).sum(:total)
    # change id at x-axis to date of record?
    # needs to be an array of hash or hash
  end

end
