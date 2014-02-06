module MypageTools
	# Data structure to represent a single shift on a single day
	class Shift
		include Icalendar
		attr_accessor :day_of_week, :date, :start, :stop

		def initialize day_of_week=nil, date=nil, start=nil, stop=nil
			@day_of_week = day_of_week
			@date = date
			@start = start
			@stop = stop
		end

		def date
			@date.strftime("%b %d, %Y")
		end

		def start
			Time.parse(@start).strftime("%H:%M")
		end

		def stop
			Time.parse(@stop).strftime("%H:%M")
		end

		def not_scheduled?
			@start == "00:00AM" && @stop == "00:00AM"
		end

		def to_ical_event
			event = Event.new
			event.start = DateTime.parse(self.date + " " + self.start + " PST")
			event.end = DateTime.parse(self.date + " " + self.stop + " PST")
			event.description = "Work at Apple"
			event.summary = "Work (Apple)"
			event.location = "Apple Store University Village, 2656 Northeast University Village Street, Seattle, WA, US"
			event
		end
	end
end