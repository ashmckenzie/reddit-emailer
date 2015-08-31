Rollbar.configure do |config|
  config.environment = ENV.fetch('APP_ENV', 'development')
  config.access_token = ENV['ROLLBAR_API_KEY']
end
