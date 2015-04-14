module JkoApi
  class ClassDescendantsBuilder
    LEVEL_REGEX = /\d+/

    def self.build(base_class, level:)
      base_class.descendants.each do |descendant|
        new(descendant, level).build
      end
    end

    def initialize(descendant, level)
      @descendant, @level = descendant, level
    end

    def build
      initial_level.upto(@level - 1) do |level|
        build_descendant(level) unless descendant_defined?(level)
      end
    end

    private

    def descendant_defined?(level)
      !!swap_level(level.next).safe_constantize
    end

    def build_descendant(level)
      namespace(level.next).constantize.const_set(
        swap_level(level.next).demodulize,
        Class.new(swap_level(level).constantize)
      )
    end

    def namespace(level)
      swap_level(level).deconstantize.presence || 'Object'
    end

    def swap_level(level)
      @descendant.name.sub LEVEL_REGEX, level.to_s
    end

    def initial_level
      @descendant.name[LEVEL_REGEX].to_i
    end
  end
end
