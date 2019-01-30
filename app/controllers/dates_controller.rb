class DatesController < ApplicationController

  def index
    # @dates = Day.all.order("created_at DESC")
    @dates = Day.all
    @date = Day.new
    @records = Record.all
    feeding_total_time = Record.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total)
    if feeding_total_time.count >= 1
      @feeding_average = feeding_total_time.reduce(:+).fdiv(feeding_total_time.size).round(0)
    else
      @feeding_average = 0
    end

    @feeding_max = Record.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).max
    @feeding_min = Record.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).min
    zone_array = Record.pluck(:zone)
    @most_frequented_zone = zone_array.max_by { |i| zone_array.count(i) }

  end

  def create
    @date = Day.new(date_params)
    if @date.save
      redirect_to date_path(id: @date.id)
    else
      render :index
    end
  end

  def edit
    @date = Day.find(params[:id])
  end

  def update
    @date = Day.find(params[:id])
    if @date.update(date_params)
      redirect_to date_path(id: @date.id)
    else
      render :edit
    end
  end

  def destroy
    @date = Day.find(params[:id])
    @date.destroy
    redirect_to root_path
  end

  def show
    @date = Day.find(params[:id])
    @record = @date.records.new
    @records = Day.find(params[:id]).records
  end

  private

  def date_params
    params.require(:day).permit(:date)
  end

end
