require 'faraday'

module Hive
  module Response
    class RaiseError < Faraday::Response::Middleware
      def on_complete(response)
        status_code = response.status.to_i
        klass = Hive::Response::Error.errors[status_code]
        return unless klass
        error = klass.from_response(response)
        fail(error)
      end
    end
  end
end
