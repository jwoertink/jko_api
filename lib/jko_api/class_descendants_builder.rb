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
        unless Module.const_defined?(swap_level(level))
          build_descendant level.pred
        end
      end
    end

    private

    def build_descendant(level)
      namespace(level).const_set(
        swap_level(level).demodulize,
        Class.new(swap_level(level.next).constantize)
      )
    end

    def namespace(level)
      deconstantized = swap_level(level).deconstantize
      unless qualified_const_defined?(deconstantized)
        qualified_const_set(deconstantized, Module.new)
      end
      deconstantized.constantize
    end

    def swap_level(level)
      descendant.name.sub LEVEL_REGEX, level.to_s
    end

    def initial_level
      descendant.name[LEVEL_REGEX].to_i
    end

    # Pulled from Rails 4.2 source
    def qualified_const_defined?(path)
      raise NameError, "#{path.inspect} is not a valid constant name!" unless /^(::)?([A-Z]\w*)(::[A-Z]\w*)*$/ =~ path

      names = path.to_s.split('::')
      names.shift if names.first.empty?

      # We can't use defined? because it will invoke const_missing for the parent
      # of the name we are checking.
      names.inject(Module) do |mod, name|
        return false unless mod.const_defined?(name, false)
        mod.const_get name
      end
      return true
    end

    def qualified_const_set(path, value)
      raise NameError.new("wrong constant name #$&") if path =~ /\A::[^:]+/
      const_name = path.demodulize
      mod_name = path.deconstantize
      mod = mod_name.empty? ? self : qualified_const_get(mod_name)
      mod.const_set(const_name, value) unless mod.const_defined?(const_name)
    end

    def qualified_const_get(path)
      path.split('::').inject(Module) do |mod, name|
        mod.const_get(name)
      end
    end
  end
end
