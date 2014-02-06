# Voodoo to make Capybara do what I want.
# Ripped off nearly wholesale from a random blog after hours of Googling.
module CapybaraWithPhantomJs
	include Capybara::DSL

	def new_session
		Capybara.register_driver :poltergeist do |app|
			Capybara::Poltergeist::Driver.new(app)
		end

		Capybara.configure do |config|
			config.run_server = false # Aparrently I have to do this if I'm not locally testing
			config.default_driver = :poltergeist
			config.default_selector = :xpath
			config.ignore_hidden_elements = true
			config.app_host = "https://mypage.apple.com"
		end

		@session = Capybara::Session.new(:poltergeist)

		@session.driver.headers = { "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X" }

		@session
	end
end