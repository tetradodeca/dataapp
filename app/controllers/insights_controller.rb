class InsightsController < ApplicationController

  def index
    @dates = Day.all
    @feedpoddates = FeedpodDate.all
  end

end
