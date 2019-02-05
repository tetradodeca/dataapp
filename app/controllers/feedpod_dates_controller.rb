class FeedpodDatesController < ApplicationController

  def index
    @dates = FeedpodDate.all.order("created_at DESC")
    @date = FeedpodDate.new
    @feedpodrecords = Feedpodrecord.all
    feeding_total_time = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total)
    if feeding_total_time.count >= 1
      @feeding_average = feeding_total_time.reduce(:+).fdiv(feeding_total_time.size).round(0)
    else
      @feeding_average = 0
    end

    @feeding_max = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).max
    @feeding_min = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).min
    zone_array = Feedpodrecord.pluck(:zone)
    hash_count = zone_array.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    empt_arr = []
    hash_count.each do |k,v|
      if v == hash_count.values.max
        empt_arr << k
      end
    end

    if empt_arr.count > 1
      @most_frequented_zone = empt_arr.join(", ")
    else 
      @most_frequented_zone = empt_arr[0]
    end
    # @most_frequented_zone = zone_array.max_by { |i| zone_array.count(i) }

  end

  def create
    @date = FeedpodDate.new(date_params)
    if @date.save
      redirect_to feedpod_date_path(id: @date.id)
    else
      render :index
    end
  end

  def edit
    @date = FeedpodDate.find(params[:id])
  end

  def update
    @date = FeedpodDate.find(params[:id])
    if @date.update(date_params)
      redirect_to feedpod_date_path(id: @date.id)
    else
      render :edit
    end
  end

  def destroy
    @date = FeedpodDate.find(params[:id])
    @date.destroy
    redirect_to feedpod_dates_path
  end

  def show
    @date = FeedpodDate.find(params[:id])
    @feedpodrecord = @date.feedpodrecords.new
    @feedpodrecords = FeedpodDate.find(params[:id]).feedpodrecords
  end

  private

  def date_params
    params.require(:feedpod_date).permit(:date)
  end

end
