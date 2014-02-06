# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# 																												#
# USELESS COMMENT BOX BY: 																#
# 																												#
#	 ___    ___     _   _ 																	#
#	|   \  /   | o | | / /____ 															#
#	| |\ \/ /| | _ | |/ // __ \ 														#
#	| | \__/ | || ||   (/  ____\ 														#
#	| |      | || || |\ \  \___ 														#
#	|_|      |_||_||_| \_\_____\ 														#
#	           ____ 																				#
#	          |    \ 																				#
#	          |  -  ) _____    ___  __            __  __ 		#
#	          |  __/ |  ___\ /  _  \\ \    __    / //    \	#
#	          |    \ | |    |  | |  |\ \  /  \  / /|  /\  |	#
#	          |  -  )| |    |  |_|  | \ \/ /\ \/ / | |  | |	#
#	          |____/ |_|     \ ___ /   \__/  \__/  |_|  |_| #
# 																												#
# 																												#
#	TODO: Compare gathered data to existing .ics files			#
# 			and inform of any changes to schedule	 						#
#  																												#
# TODO: Add ability to automagically import to  					#
# 			Calendar application 															#
# 																												#
# TODO: GUI? Bah. Probably not.														#
# 																												#
# TODO: Check timecard against schedule for possible			#
# 			missing punches?																	#
# 																												#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

require "capybara/dsl"
require "capybara/poltergeist"
require "icalendar"
require "io/console"
require "active_support/core_ext"
require "mypage_tools/version"
require "capybara_with_phantom_js"
require "mypage_tools/shift"
require "mypage_tools/weekly_schedule"
require "mypage_tools/schedule_scraper"
require "mypage_tools/schedule_page"
require "mypage_tools/cli"

module MypageTools
	SCHEDULE_DIR = File.join(Dir.home, "myPage Schedule")
end