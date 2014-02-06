module MypageTools
	# Data structure to represent 1 week's Shifts
	class WeeklySchedule
		include Icalendar
		attr_reader :week_begins

		def initialize week_begins, shift_array
			@week_begins = week_begins
			@shift_array = shift_array
		end

		def to_ics
			cal = Calendar.new
			@shift_array.each do |shift|
				cal.add_event shift.to_ical_event unless shift.not_scheduled?
			end
			cal.publish
			cal_string = cal.to_ical

			# TODO: Extract this elsewhere
			FileUtils.mkdir(SCHEDULE_DIR) unless File.directory?(SCHEDULE_DIR)
			file_name = File.join(SCHEDULE_DIR, "Schedule from #{@week_begins}.ics")
			File.open(file_name, "w") { |io| io.write cal_string }
			print "\nSaving schedule to:\n#{file_name}\n"
		end
	end
end