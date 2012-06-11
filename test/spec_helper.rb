Dir[File.join('config', 'initialisers', '*.rb')].each { |f| require "./#{f}" }# require 'minitest/spec'

require 'minitest/autorun'