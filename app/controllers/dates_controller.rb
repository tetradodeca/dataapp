class DatesController < ApplicationController

  def index
    @dates = Day.all
    @date = Day.new
  end

  # def new
  #   @date = Day.new
  # end

  def create
    @date = Day.new(date_params)
    if @date.save
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    @date = Day.find(params[:id])
    @date.destroy
    redirect_to root_path
  end

  def show
    @date = Day.find(params[:id])
  end

  private

  def date_params
    params.require(:day).permit(:date)
  end

end
