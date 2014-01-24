# coding: utf-8

require 'toadhopper'

module RedditEmailer
  class Errbit

    def self.endeavour exception, retries=3, delay=3
      raise 'Block must be given' unless block_given?
      return new.endeavour(exception, retries) { yield }
    end

    def endeavour exception, retries=3, delay=3
      raise 'Block must be given' unless block_given?

      max_retries = retries
      begin
        return yield
      rescue => e
        if e.class == exception && (retries -= 1) >= 0
          $logger.info "#{e.class}: retry #{(retries - max_retries).abs} (sleeping for #{delay} secs)"
          sleep delay
          retry
        else
          $logger.info "#{e.class}: Giving up"
          if enabled?
            Toadhopper.new(api_key, new_opts).post!(e, post_opts)
          else
            raise
          end
        end
      end
    end

    private

      def api_key
        RedditEmailer::Config.instance.errbit.api_key
      end

      def enabled?
        (ENV['ERRBIT_ENABLE'] || ENV['ERRBIT_ENABLE'] == 'true') ? true : false
      end

      def environment
        ENV['APP_ENV'] ? ENV['APP_ENV'] : 'development'
      end

      def new_opts
        { notify_host: RedditEmailer::Config.instance.errbit.host }
      end

      def post_opts
        { framework_env: environment }
      end
  end
end
