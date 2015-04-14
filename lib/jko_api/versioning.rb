module JkoApi
  class Versioning
    def initialize(context, &block)
      @context, @definitions = context, {}
      instance_eval &block
    end

    def version(number, &block)
      @definitions[number] = block || Proc.new {}
      @context.scope module: "v#{number}", constraints: ->(*) {
        JkoApi.current_version_number == number
      } do
        number.downto(min_version_number) do |i|
          @context.instance_eval &@definitions[i]
        end
      end
    end

    def min_version_number
      @definitions.keys.min
    end

    def max_version_number
      @definitions.keys.max
    end
  end
end
