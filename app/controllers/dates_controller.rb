class DatesController < ApplicationController

  def index
    @dates = Day.all
    @date = Day.new
  end

  def create
    @date = Day.new(date_params)
    if @date.save
      redirect_to date_path(id: @date.id)
    else
      redirect_to root_path
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
