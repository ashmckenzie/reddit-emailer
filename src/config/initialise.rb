require 'bundler/setup'

BASE_DIR = File.expand_path(File.join('..', '..'), __FILE__)
LIB_DIR = File.expand_path(File.join(BASE_DIR, 'lib'), __FILE__)
$LOAD_PATH.unshift(LIB_DIR) unless $LOAD_PATH.include?(LIB_DIR)

require 'reddit_emailer'
