class StaticsController < ApplicationController

  def exhibit
  end

  def visual
    @visual = true
    @daily_total_feeding_times = Record.group(:day_id).where(activity: ["Feeding", "Scatter Feed"]).sum(:total)
    @feedpod_daily_total_feeding_times = Feedpodrecord.group(:feedpod_date_id).where(activity: ["Feeding", "Scatter Feed"]).sum(:total)
    # change id at x-axis to date of record?
    # needs to be an array of hash or hash

    def thirty_records(hash_data)
    	hash_data.keep_if { |k,v| k <= 30}
    	return hash_data
  	end
    
    def longest_feeding_chart(pod_database, id)
    	records = pod_database.where(activity: ["Feeding", "Scatter Feed"])
    	container = Hash.new
    	records.each do |record|
    		if container.key?(record[id]) == false
    			container[record[id]] = [record[:total]]
  			else
  				container[record[id]].append(record[:total])
				end
  		end
  		container.each do |k,v|
  			v.reject! { |x| x < v.max }
			end
			return thirty_records(container)
  	end

  	def shortest_feeding_chart(pod_database, id)
  		records = pod_database.where(activity: ["Feeding", "Scatter Feed"])
    	container = Hash.new
    	records.each do |record|
    		if container.key?(record[id]) == false
    			container[record[id]] = [record[:total]]
  			else
  				container[record[id]].append(record[:total])
				end
  		end
  		container.each do |k,v|
  			v.reject! { |x| x > v.min }
			end
			return thirty_records(container)
		end

		def non_feeding_count(database, id)
			records = database.where(activity: "Other")
			container = Hash.new
			records.each do |record|
				if container.key?(record[id]) == false
					container[record[id]] = [record[:activity]]
				else
					container[record[id]].append(record[:activity])
				end
			end
			container.each do |k,v|
				container[k] = v.count
			end
			return thirty_records(container)
		end

		def record_count_per_night(database, id)
			records = database.all
			container = Hash.new
			records.each do |record|
				if container.key?(record[id]) == false
					container[record[id]] = 1
				else
					container[record[id]] += 1
				end
			end
			return thirty_records(container)
		end

		def count_location_records(database)
			records = database.all
			container = Hash.new
			records.each do |record|
				if container.key?(record[:zone]) == false
					container[(record[:zone])] = 1
				else
					container[(record[:zone])] += 1
				end
			end
			return container
		end

		def pie_comparison(container)
			total = container.values.sum
			return container.transform_values { |v| (v * 100.0 / total).round(2) }
		end

		@longest_feeding_chart = longest_feeding_chart(Record, :day_id)
		@longest_feeding_chart_pod = longest_feeding_chart(Feedpodrecord, :feedpod_date_id)
		@shortest_feeding_chart = shortest_feeding_chart(Record, :day_id)
		@shortest_feeding_chart_pod = shortest_feeding_chart(Feedpodrecord, :feedpod_date_id)
		@other_count = non_feeding_count(Record, :day_id)
		@other_count_pod = non_feeding_count(Feedpodrecord, :feedpod_date_id)
		@record_count = record_count_per_night(Record, :day_id)
		@record_count_pod = record_count_per_night(Feedpodrecord, :feedpod_date_id)
		@location_records_count = count_location_records(Record)
		@location_records_count_pod = count_location_records(Feedpodrecord)
		@pie_chart = pie_comparison(count_location_records(Record))
		@pie_chart_pod = pie_comparison(count_location_records(Feedpodrecord))

	end
   

end


