module MypageTools
	class ScheduleScraper
		include CapybaraWithPhantomJs

		def initialize username, password
			@username = username
			@password = password
		end

		def schedule_page
			unless @schedule_page
				new_session
				visit "/"
				wait_for(:wait_message => "Loading Login Page") { page.has_content? "Account Name" }
				login
				click_link "myTime"
				wait_for(:wait_message => "Loading Timecard") { page.has_content? "Current Timecard" }
				click_link "Schedule"
				wait_for(:wait_message => "Checking for available schedule") { schedule_available? }
				@schedule_page = SchedulePage.new(Nokogiri::HTML.parse(page.html))
			end
			@schedule_page
		end

		def schedule_available?
			page.has_text? /Schedule\sbegins\s\w+\s\d{1,2},\s\d{4}/
		end

		def no_schedule_available?
			page.has_text? "Schedule is not available for the selected week"
		end

		def generate_schedule
			schedule = WeeklySchedule.new @schedule_page.week_begins, @schedule_page.shift_array
			schedule.to_ics
		end

		def next_week
			next_week_begins_date = Date.parse(@schedule_page.week_begins) + 7
			if date_in_current_month? next_week_begins_date
				click_calendar_day(next_week_begins_date)
				@schedule_page = SchedulePage.new(Nokogiri::HTML.parse(page.html))
			else
				click_next_month next_week_begins_date
				click_calendar_day(next_week_begins_date)
				@schedule_page = SchedulePage.new(Nokogiri::HTML.parse(page.html))
			end
		end

		private
			def login
				fill_in "appleId", with: @username
				fill_in "accountPassword", with: @password
				click_on "submitButton2"
				wait_for(:wait_message => "Logging in") { page.has_button? "Sign Out" }
			end

			def date_in_current_month? date
				Date.parse(@schedule_page.week_begins).month == date.month
			end

			def click_calendar_day date
				day_number = date.day.to_s
				within("//div[@id = 'calendar-#{date.year}-#{date.month - 1}']") do
	        # BUG FIX -> capybara finding multiple elements, use regex to exact match date
					find("//td[@class = 'weekend']", text: /\A#{day_number}\z/).click
				end
				wait_for(:wait_message => "Loading next week") do
					page.has_content?("Schedule begins #{date.strftime("%b %d, %Y")}") || no_schedule_available?
				end
			end

			# Clicks on the little arrow on the calendar to load the next month
			def click_next_month date
				find("//img[@id = 'right' and @class = 'arrow']").click
				wait_for { page.has_content? "#{date.strftime("%B %Y")}" }
			end

			# Helper method to allow waiting for a specific thing on the page to load
			# Times out after 10 seconds (1+2+3+4)
			# Expects a block that returns a boolean value
			def wait_for options={}
				options.reverse_merge!({fail_message: "Request Timed Out"})
				wait_message = options[:wait_message]
				latency = 0
				print "\n" << wait_message << "..." if wait_message
				while latency < 6
					latency.times { print "." } if wait_message
					sleep latency
					if yield
						print "\n" if wait_message
						return true
					end
					latency += 1
				end
				abort format_failure(options[:fail_message])
			end

			def format_failure message
				"\n" + ("#" * message.length) + "\n\n#{message}\n\n" + ("#" * message.length) + "\n\n"
			end
	end
end