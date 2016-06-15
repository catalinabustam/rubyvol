# config.ru
require './app.rb'

run Rack::URLMap.new('/' => HelloWorldApp, '/sidekiq' => Sidekiq::Web)

