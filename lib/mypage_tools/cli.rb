module MypageTools
	class CLI
		def self.parse_options args=ARGV
			case args[0]
			when "schedule"
				schedule
			when "help"
				self.help
			else
				puts "\nUnkown Argument\n"
				self.help
			end
		end

		def self.schedule
			print `clear`
			puts "In order to get your work schedule you need to provide your login and password for myPage."
			print "Login: "
			ARGV.clear
			login = gets.chomp
			password = get_password
			puts "\n"
			scrape_session = ScheduleScraper.new login, password
			scrape_session.schedule_page
			while scrape_session.schedule_available?
				scrape_session.generate_schedule
				scrape_session.next_week
				break if scrape_session.no_schedule_available? # Loop not breaking w/out this line. Need to investigate.
			end
			puts "\nNo further schedules available."
			print `open #{Dir.home}/myPage\\ Schedule`
		end

		def self.help # hahaha
			puts ""
			puts "The only implemented feature currently is getting your schedule"
			puts ""
			puts "USAGE:"
			puts "\tmypage schedule"
			puts ""
		end

		private
			if STDIN.respond_to?(:noecho)
				def self.get_password
					print "Password: "
					STDIN.noecho(&:gets).chomp
				end
			else
				# Legacy support for Ruby < 1.9
				def self.get_password
					`read -s -p "Password: " password; echo $password`.chomp
				end
			end
	end
end