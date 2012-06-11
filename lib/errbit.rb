Dir[File.join('config', 'initialisers', '*.rb')].each { |f| require "./#{f}" }

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
          require 'toadhopper'
          Toadhopper.new(api_key, new_opts).post!(e, post_opts)
        else
          raise
        end
      end
    end
  end

  private

  def api_key
    $CONFIG.errbit.api_key
  end

  def enabled?
    (ENV['ERRBIT_ENABLE'] || ENV['ERRBIT_ENABLE'] == 'true') ? true : false
  end

  def environment
    ENV['APP_ENV'] ? ENV['APP_ENV'] : 'development'
  end

  def new_opts
    { :notify_host => $CONFIG.errbit.host }
  end

  def post_opts
    { :framework_env => environment }
  end
end