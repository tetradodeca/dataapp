class FeedpodRecordsController < ApplicationController

  def create
    @date = FeedpodDate.find(params[:feedpod_date_id])
    @record = @date.feedpodrecords.create(record_params)
    redirect_to feedpod_date_path(id: @date.id)
  end

  def destroy
    @date = FeedpodDate.find(params[:feedpod_date_id])
    @record = Feedpodrecord.find(params[:id])
    @record.destroy
    redirect_to feedpod_date_path(id: @date.id)
  end

  private

  def record_params
    params.require(:feedpodrecord).permit(:zone, :time_start, :time_end, :activity)
  end

end
