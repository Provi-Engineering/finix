require 'faraday'
require_relative '../errors'

module Faraday

  class Response::RaiseApiError < Response::Middleware
    def on_complete(response)
      status_code = response[:status].to_i
      error_class = Finix.errors_registry[status_code]
      raise Finix.errors_registry[:unknown].new response if error_class.nil? and status_code >= 400
      raise error_class.new response if error_class
    end
  end

end
