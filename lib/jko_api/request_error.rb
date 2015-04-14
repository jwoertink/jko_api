module JkoApi
  class RequestError
    def self.[](status, message = status)
      new(status, message).representer
    end

    attr_reader :status, :message

    def initialize(status, message)
      @status, @message = status, message
    end

    def representer
      # TODO: integrate this somehow
    end

    private

    def errors
      Errors.new(MockRequest.new).tap do |errors|
        errors.add :base, message
      end
    end

    class MockRequest
      include ::ActiveModel::Model

      def representable_type
        :requests
      end
    end
  end
end
