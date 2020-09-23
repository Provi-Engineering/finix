require_relative 'hal_resource'
module Finix

  class Errors < ::StandardError
    include Finix::HalResource
    attr_reader :code
    attr_reader :total

    def initialize(response=nil)
      @code = response[:status].to_i
      @total = response[:body]['total'].to_i

      load_page_from_response! response
      @attributes['errors'] = @attributes.delete 'items'
      @attributes.delete 'page'
    end

    def to_s
      "#{@errors}"
    end

  end

  class BadRequest < Errors
  end

  class Unauthorized < Errors
  end

  class PaymentRequired < Errors
  end

  class Forbidden < Errors
  end

  class NotFound < Errors
  end

  class MethodNotAllowed < Errors
  end

  class UnprocessableEntity < Errors
  end

  class InternalServerError < Errors
  end
end
