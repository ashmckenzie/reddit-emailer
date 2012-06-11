Dir[File.join('config', 'initialisers', '*.rb')].sort.each { |f| require "./#{f}" }

require 'minitest/autorun'
require 'minitest/spec'
require 'mocha'