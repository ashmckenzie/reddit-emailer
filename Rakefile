# encoding: UTF-8

require File.expand_path(File.join('..', 'config', 'initialise'), __FILE__)

desc 'Console'
task :console do
  require 'pry'
  require 'pry-debugger'
  require 'awesome_print'

  include RedditEmailer

  pry
end
