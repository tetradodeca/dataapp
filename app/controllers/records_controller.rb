class RecordsController < ApplicationController

  def create
    @date = Day.find(params[:date_id])
    @record = @date.records.create(record_params)
    redirect_to date_path(id: @date.id)
  end

  def destroy
    @date = Day.find(params[:date_id])
    @record = Record.find(params[:id])
    @record.destroy
    redirect_to date_path(id: @date.id)
  end

  private

  def record_params
    params.require(:record).permit(:zone, :time_start, :time_end, :activity)
  end

end
