require 'delegate'
require 'hashie'
require 'yaml'
require 'singleton'

module RedditEmailer
  class Config < SimpleDelegator
    include Singleton

    def initialize
      config_file = File.expand_path(File.join(BASE_DIR, 'config', 'config-new.yml'), __FILE__)
      config = File.exist?(config_file) ? YAML.load_file(config_file) : {}
      super(Hashie::Mash.new(config))
    end
  end
end
