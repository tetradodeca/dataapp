class InsightsController < ApplicationController

  def index
    # count number of days
    @dates = Day.all
    @records = Record.all
    
    # count number of records
    @feedpoddates = FeedpodDate.all
    @feedpodrecords = Feedpodrecord.all
    
    # count max and min feeding times
    @feeding_max = Record.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).max
    @feeding_min = Record.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).min
    @feedpodfeeding_max = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).max
    @feedpodfeeding_min = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).min
    
    # count average feeding time per night
    feeding_total_time = Record.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).reduce(:+)
    num_of_days = Day.all.count
    @feedingaveperday = feeding_total_time / num_of_days
    feedpod_feeding_total_time = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"]).pluck(:total).reduce(:+)
    feedpod_num_of_days = FeedpodDate.all.count
    @feedpod_feedingaveperday = feedpod_feeding_total_time / feedpod_num_of_days

    # find most frequented zone
    zone_array = Record.pluck(:zone)
    @most_frequented_zone = zone_array.max_by { |i| zone_array.count(i) }
    feedpod_zone_array = Feedpodrecord.pluck(:zone)
    @feedpod_most_frequented_zone = feedpod_zone_array.max_by { |i| feedpod_zone_array.count(i) }

    # activity:other no.of records
    @other = Record.where(activity: "Other").count
    @feedpod_other = Feedpodrecord.where(activity: "Other").count

    # find which feeder he goes first to the most
    feedpoddays = FeedpodDate.all
    arr_of_sec_zone = []
    feedpoddays.each do |day|
        arr_of_sec_zone << day.feedpodrecords[0][:zone]
    end
    @feedpod_first_box = arr_of_sec_zone.max_by { |i| arr_of_sec_zone.count(i) }

    
    def location_sequence(num)
      days = Day.all
      arr_of_zone = []
      days.each do |day|
        arr_of_zone << day.records[num][:zone]
      end
      return arr_of_zone.max_by { |i| arr_of_zone.count(i) }
    end

    def feedpod_location_sequence(num)
      days = FeedpodDate.all
      arr_of_zone = []
      days.each do |day|
        arr_of_zone << day.feedpodrecords[num][:zone]
      end
      return arr_of_zone.max_by { |i| arr_of_zone.count(i) }
    end

    @first_box = location_sequence(0)
    @feedpod_first_box = location_sequence(0)
    @second_box = location_sequence(1)
    @feedpod_second_box = location_sequence(1)
    @third_box = location_sequence(2)
    @feedpod_third_box = location_sequence(2)
    #-----------------------------------------------------------------------


    def total_times_visited(location)
      return Record.where(zone: location).count
    end

    def feedpod_total_times_visited(location)
      return Feedpodrecord.where(zone: location).count
    end

    def average_times_per_night_visited(location)
      num_of_normal_days = Day.all.count.to_f
      total = Record.where(zone: location).count
      return (total / num_of_normal_days).round(1)
    end

    def feedpod_average_times_per_night_visited(location)
      feedpodnum_of_days = FeedpodDate.all.count.to_f
      total = Feedpodrecord.where(zone: location).count
      return (total / feedpodnum_of_days).round(1)
    end

    def max_feeding_time(location)
      feeding_times = Record.where(activity: ["Feeding", "Scatter Feed"], zone: location).pluck(:total)
      if feeding_times.count >= 1
        return feeding_times.max
      else
        return 0
      end
    end

    def feedpod_max_feeding_time(location)
      feeding_times = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"], zone: location).pluck(:total)
      if feeding_times.count >= 1
        return feeding_times.max
      else
        return 0
      end
    end

    def min_feeding_time(location)
      feeding_times = Record.where(activity: ["Feeding", "Scatter Feed"], zone: location).pluck(:total)
      if feeding_times.count >= 1
        return feeding_times.min
      else
        return 0
      end
    end

    def feedpod_min_feeding_time(location)
      feeding_times = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"], zone: location).pluck(:total)
      if feeding_times.count >= 1
        return feeding_times.min
      else
        return 0
      end
    end

    def average_feeding_time(location)
      total_arr = Record.where(activity: ["Feeding", "Scatter Feed"], zone: location).pluck(:total)
      if total_arr.count >= 1
        return total_arr.reduce(:+).fdiv(total_arr.size).round(0)
      else
        return 0
      end
    end

    def feedpod_average_feeding_time(location)
      total_arr = Feedpodrecord.where(activity: ["Feeding", "Scatter Feed"], zone: location).pluck(:total)
      if total_arr.count >= 1
        return total_arr.reduce(:+).fdiv(total_arr.size).round(0)
      else
        return 0
      end
    end

    #-----------------------------------------------------------------------
    # feedpod details

    @feedpod = total_times_visited("Feedpod")
    @feedpod_feedpod = feedpod_total_times_visited("Feedpod")
    @feedpod_ave = average_times_per_night_visited("Feedpod")
    @ave_feedpod_feedpod = feedpod_average_times_per_night_visited("Feedpod")
    @feedpod_max_total = max_feeding_time("Feedpod")
    @feedpod_feedpod_max_total = feedpod_max_feeding_time("Feedpod")
    @feedpod_min_total = min_feeding_time("Feedpod")
    @feedpod_feedpod_min_total = feedpod_min_feeding_time("Feedpod")
    @feedpod_average_feeding_time = average_feeding_time("Feedpod")
    @feedpod_feedpod_average_feeding_time = feedpod_average_feeding_time("Feedpod")

    #-----------------------------------------------------------------------
    # grassbox details

    @grassbox = total_times_visited("Grass Feeder Box")
    @feedpod_grassbox = feedpod_total_times_visited("Grass Feeder Box")
    @ave_grassbox = average_times_per_night_visited("Grass Feeder Box")
    @ave_feedpod_grassbox = feedpod_average_times_per_night_visited("Grass Feeder Box")
    @grassbox_max_total = max_feeding_time("Grass Feeder Box")
    @feedpod_grassbox_max_total = feedpod_max_feeding_time("Grass Feeder Box")
    @grassbox_min_total = min_feeding_time("Grass Feeder Box")
    @feedpod_grassbox_min_total = feedpod_min_feeding_time("Grass Feeder Box")
    @grassbox_average_feeding_time = average_feeding_time("Grass Feeder Box")
    @feedpod_grassbox_average_feeding_time = feedpod_average_feeding_time("Grass Feeder Box")

    #-----------------------------------------------------------------------
    # Hay box pool details

    @boxpool = total_times_visited("Hay Feeder Box Pool")
    @feedpod_boxpool = feedpod_total_times_visited("Hay Feeder Box Pool")
    @ave_boxpool = average_times_per_night_visited("Hay Feeder Box Pool")
    @ave_feedpod_boxpool = feedpod_average_times_per_night_visited("Hay Feeder Box Pool")
    @boxpool_max_total = max_feeding_time("Hay Feeder Box Pool")
    @feedpod_boxpool_max_total = feedpod_max_feeding_time("Hay Feeder Box Pool")
    @boxpool_min_total = min_feeding_time("Hay Feeder Box Pool")
    @feedpod_boxpool_min_total = feedpod_min_feeding_time("Hay Feeder Box Pool")
    @boxpool_average_feeding_time = average_feeding_time("Hay Feeder Box Pool")
    @feedpod_boxpool_average_feeding_time = feedpod_average_feeding_time("Hay Feeder Box Pool")

    #-----------------------------------------------------------------------
    # Hay box front details

    @boxfront = total_times_visited("Hay Feeder Box Front")
    @feedpodboxfront = feedpod_total_times_visited("Hay Feeder Box Front")
    @ave_haybox_front_per_night = average_times_per_night_visited("Hay Feeder Box Front")
    @feedpod_ave_haybox_front_per_night = feedpod_average_times_per_night_visited("Hay Feeder Box Front")
    @haybox_front_max_total = max_feeding_time("Hay Feeder Box Front")
    @feedpod_haybox_front_max_total = feedpod_max_feeding_time("Hay Feeder Box Front")
    @haybox_front_min_total = min_feeding_time("Hay Feeder Box Front")
    @feedpod_haybox_front_min_total = feedpod_min_feeding_time("Hay Feeder Box Front")
    @haybox_front_average_feeding_time = average_feeding_time("Hay Feeder Box Front")
    @feedpod_haybox_front_average_feeding_time = feedpod_average_feeding_time("Hay Feeder Box Front")

    #-----------------------------------------------------------------------
    # Front of exhibit details

    @exhibitfront = total_times_visited("Front of exhibit")
    @feedpodexhibitfront = feedpod_total_times_visited("Front of exhibit")
    @ave_exhibitfront = average_times_per_night_visited("Front of exhibit")
    @feedpod_ave_exhibitfront = feedpod_average_times_per_night_visited("Front of exhibit")
    @exhibitfront_max_total = max_feeding_time("Front of exhibit")
    @feedpod_exhibitfront_max_total = feedpod_max_feeding_time("Front of exhibit")
    @exhibitfront_min_total = min_feeding_time("Front of exhibit")
    @feedpod_exhibitfront_min_total = feedpod_min_feeding_time("Front of exhibit")
    @exhibitfront_average_feeding_time = average_feeding_time("Front of exhibit")
    @feedpod_exhibitfront_average_feeding_time = feedpod_average_feeding_time("Front of exhibit")

    #-----------------------------------------------------------------------
    # exhibit left facing details

    @leftfacing = total_times_visited("Exhibit Left Facing")
    @feedpod_leftfacing = feedpod_total_times_visited("Exhibit Left Facing")
    @leftfacing_ave = average_times_per_night_visited("Exhibit Left Facing")
    @feedpod_leftfacing_ave = feedpod_average_times_per_night_visited("Exhibit Left Facing")
    @leftfacing_max = max_feeding_time("Exhibit Left Facing")
    @feedpod_leftfacing_max = feedpod_max_feeding_time("Exhibit Left Facing")
    @leftfacing_min = min_feeding_time("Exhibit Left Facing")
    @feedpod_leftfacing_min = feedpod_min_feeding_time("Exhibit Left Facing")
    @leftfacing_ave_feeding_time = average_feeding_time("Exhibit Left Facing")
    @feedpod_leftfacing_ave_feeding_time = feedpod_average_feeding_time("Exhibit Left Facing")

    #-----------------------------------------------------------------------
    # exhibit right facing details

    @rightfacing = total_times_visited("Exhibit Right Facing")
    @feedpod_rightfacing = feedpod_total_times_visited("Exhibit Right Facing")
    @rightfacing_ave = average_times_per_night_visited("Exhibit Right Facing")
    @feedpod_rightfacing_ave = feedpod_average_times_per_night_visited("Exhibit Right Facing")
    @rightfacing_max = max_feeding_time("Exhibit Right Facing")
    @feedpod_rightfacing_max = feedpod_max_feeding_time("Exhibit Right Facing")
    @rightfacing_min = min_feeding_time("Exhibit Right Facing")
    @feedpod_rightfacing_min = feedpod_min_feeding_time("Exhibit Right Facing")
    @rightfacing_ave_feeding_time = average_feeding_time("Exhibit Right Facing")
    @feedpod_rightfacing_ave_feeding_time = feedpod_average_feeding_time("Exhibit Right Facing")

    #-----------------------------------------------------------------------
    # exhibit BOH facing details

    @bohfacing = total_times_visited("Exhibit BOH Facing")
    @feedpod_bohfacing = feedpod_total_times_visited("Exhibit BOH Facing")
    @bohfacing_ave = average_times_per_night_visited("Exhibit BOH Facing")
    @feedpod_bohfacing_ave = feedpod_average_times_per_night_visited("Exhibit BOH Facing")
    @bohfacing_max = max_feeding_time("Exhibit BOH Facing")
    @feedpod_bohfacing_max = feedpod_max_feeding_time("Exhibit BOH Facing")
    @bohfacing_min = min_feeding_time("Exhibit BOH Facing")
    @feedpod_bohfacing_min = feedpod_min_feeding_time("Exhibit BOH Facing")
    @bohfacing_ave_feeding_time = average_feeding_time("Exhibit BOH Facing")
    @feedpod_bohfacing_ave_feeding_time = feedpod_average_feeding_time("Exhibit BOH Facing")






















  end
end
