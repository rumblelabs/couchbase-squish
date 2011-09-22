module Couch

  class << self

    def domain
      return "http://#{ENV['COUCHBASE_DOMAIN']}" if ENV['COUCHBASE_DOMAIN']
      case Rails.env.to_s
        when "production"  then "http://localhost"
        when "test"        then "http://localhost"
        when "development" then "http://localhost"
      end
    end

    def client
      @client ||= Couchbase.new "#{domain}:8091/pools/default"
    end

  end

end