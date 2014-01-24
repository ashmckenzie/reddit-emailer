require 'bundler/setup'

BASE_DIR = File.expand_path(File.join('..', '..'), __FILE__)
LIB_DIR = File.expand_path(File.join(BASE_DIR, 'lib', 'reddit_emailer'), __FILE__)

$LOAD_PATH.unshift(LIB_DIR) unless $LOAD_PATH.include?(LIB_DIR)

initialisers_path = File.expand_path(File.join(BASE_DIR, 'config', 'initialisers', '**', '*.rb'), __FILE__)
Dir[initialisers_path].each { |file| require file }

lib_path = File.expand_path(File.join(LIB_DIR, '**', '*.rb'), __FILE__)
Dir[lib_path].each { |file| require file }
