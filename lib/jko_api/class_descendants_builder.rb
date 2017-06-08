module JkoApi
  class ClassDescendantsBuilder
    LEVEL_REGEX = /\d+/

    def self.build(base_class, upto:)
      base_class.descendants.each do |descendant|
        new(descendant, upto).build
      end
    end

    attr_reader :descendant, :upto

    def initialize(descendant, upto)
      @descendant, @upto = descendant, upto
    end

    def build
      initial_level.upto(upto) do |level|
        unless Module.const_defined?(swap_level(level.next))
          build_descendant level
        end
      end
    end

    private

    def build_descendant(level)
      namespace(level.next).const_set(
        swap_level(level.next).demodulize,
        Class.new(swap_level(level).constantize)
      )
    end

    def namespace(level)
      deconstantized = swap_level(level).deconstantize
      unless Module.const_defined?(deconstantized)
        Module.const_set deconstantized, Module.new
      end
      deconstantized.constantize
    end

    def swap_level(level)
      descendant.name.sub LEVEL_REGEX, level.to_s
    end

    def initial_level
      descendant.name[LEVEL_REGEX].to_i
    end
  end
end
