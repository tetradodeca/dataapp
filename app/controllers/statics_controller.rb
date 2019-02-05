class StaticsController < ApplicationController

  def exhibit
  end

  def dev
    @dates = Day.all
    @feedpod_dates = FeedpodDate.all
  end
end
