 module EventStore
  module Client
    module HTTP
      class EventWriter
        module Defaults
          def self.retry_limit
            retry_limit = ENV['EVENT_STORE_CLIENT_HTTP_WRITE_RETRY_LIMIT']

            return retry_limit.to_i if retry_limit

            3
          end

          def self.retry_delay
            Rational(retry_delay_milliseconds, 1_000)
          end

          def self.retry_delay_milliseconds
            delay_milliseconds = ENV['EVENT_STORE_CLIENT_HTTP_WRITE_RETRY_DELAY']

            return delay_milliseconds.to_i if delay_milliseconds

            100
          end
        end
      end
    end
  end
 end
