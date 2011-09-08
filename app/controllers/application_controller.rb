class ApplicationController < ActionController::Base
  protect_from_forgery

  def couchbase_domain
    case Rails.env.to_s
      when "production"  then "http://localhost"
      when "test"        then "http://localhost"
      when "development" then "http://localhost"
    end
  end

  def couchbase
    @client ||= Couchbase.new "#{couchbase_domain}:8091/pools/default"
  end

end
