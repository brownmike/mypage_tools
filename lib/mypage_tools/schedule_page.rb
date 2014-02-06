module MypageTools
	class SchedulePage
		# Expects the myPage schedule page as a Nokogiri HTML object
		def initialize page
			@page = page
		end

		# Return string containing the date the week begins, i.e. "Sep 14, 2013"
		# Matches from the raw_schedule_text using a regex
		# http://rubular.com/r/OjRZ0q6cko
		def week_begins
			unless @week_begins
				@week_begins = raw_schedule_text.scan(/\w+\s\d{1,2},\s\d{4}/)[0]
			end
			@week_begins
		end

		# Gross & Ugly.
		# Returns an array where every item is a Shift object
		def shift_array
			unless @shift_array
				@shift_array = []
				days_of_week = %w[Saturday Sunday Monday Tuesday Wednesday Thursday Friday]

				# Establishing variable scope
				current_day = nil
				current_date = nil
				index_counter = 0
				shift = nil

				# Finds a day then creates shifts for that day from each following pair of times
				raw_schedule_array.each do |item|
					if days_of_week.member?(item)
						current_day = item
						# Figure out the date of the shift based on the day of the week & start date of the week
						current_date = Date.parse(week_begins) + days_of_week.index(item)
						index_counter = 0
					elsif index_counter == 0
						shift = Shift.new
						shift.day_of_week = current_day
						shift.date = current_date
						shift.start = item
						index_counter += 1
					elsif index_counter == 1
						shift.stop = item
						index_counter = 0
						@shift_array << shift
					end
				end
			end
			@shift_array
		end

		private
			# Returns a string with all the necessary information to extract that week's schedule
			def raw_schedule_text
				unless @raw_schedule_text
					xpath_to_schedule = "//div[@id = 'contentTimecard']/div/table/tbody/tr/td/table/tbody"
					@raw_schedule_text = @page.search(xpath_to_schedule).text
				end
				@raw_schedule_text
			end

			# Data structure for schedule: [Day, Start, End, Day, Start, End, (Start), (End), etc...]
			# Matched from the raw_schedule_text with a regex
			# http://rubular.com/r/xOOFBOKFMM
			def raw_schedule_array
				unless @raw_schedule_array
					@raw_schedule_array = raw_schedule_text.scan /[SMTWF]\w{2,5}day|\d{1,2}:\d{2}[A|P]M/
				end
				@raw_schedule_array
			end
	end
end