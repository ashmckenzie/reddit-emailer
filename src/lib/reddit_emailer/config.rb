require 'delegate'
require 'hashie'
require 'yaml'
require 'singleton'

module RedditEmailer
  class Config < SimpleDelegator

    include Singleton

    def initialize
      config_file = File.expand_path(File.join(BASE_DIR, 'config', 'config.yml'), __FILE__)

      if File.exist?(config_file)
        config = YAML.load_file(config_file)
      else
        config = {}
      end

      super(Hashie::Mash.new(config))
    end
  end
end
