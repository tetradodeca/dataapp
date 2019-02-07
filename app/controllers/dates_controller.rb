class DatesController < ApplicationController

  def index
    @dates = Day.all.order("created_at DESC")
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
    hash_count = zone_array.inject(Hash.new(0)) { |h, e| h[e] += 1 ; h }
    empt_arr = []
    hash_count.each do |k,v|
      if v == hash_count.values.max
        empt_arr << k
      end
    end

    if empt_arr.count > 1
      @most_frequented_zone = empt_arr.join(",")
    else 
      @most_frequented_zone = empt_arr[0]
    end
    # @most_frequented_zone = zone_array.max_by { |i| zone_array.count(i) }

    respond_to do |format|
      format.html
      format.csv { send_data @dates.to_csv}
      format.xls { send_data @dates.to_csv(col_sep: "\t")}
    end

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
    redirect_to dates_path
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
