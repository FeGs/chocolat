module Services
  class Base
    class Error < RuntimeError
      attr_accessor :original_error
      def initialize(message, original_error = nil)
        @original_error = original_error
        super(message)
      end
    end

    class Result
      def success?
        false
      end

      def message
        ""
      end

      def value
        nil
      end
    end

    class ResultSuccess < Result
      def initialize(value)
        @value = value
      end

      def success?
        true
      end

      def value
        @value
      end
    end

    class ResultError < Result
      attr_accessor :error

      def initialize(error)
        @error = error
      end

      def message
        @error.message
      end
    end

    def success!(value = nil)
      ResultSuccess.new(value)
    end

    def error!(message, error = nil)
      error = Error.new(message, error)
      ResultError.new(error)
    end
  end
end