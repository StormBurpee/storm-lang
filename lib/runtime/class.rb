class StormClass < StormObject
  attr_reader :runtime_methods, :static_methods, :declared_variables

  def initialize(superclass=nil)
    @runtime_methods = {}
    @static_methods = {}
    @declared_variables = {}
    @runtime_superclass = superclass
    if defined?(Runtime)
      runtime_class = Runtime['Class']
    else
      runtime_class = nil
    end

    super(runtime_class)
  end

  def lookup(method_name)
    method = @runtime_methods[method_name]
    unless method
      if @runtime_superclass
        return @runtime_superclass.lookup(method_name)
      elsif @static_methods[method_name]
        return @static_methods[method_name]
      else
        raise "Method not found: #{method_name}"
      end
    end
    method
  end

  def inherits(superclass)
    @runtime_superclass = superclass
  end

  def new
    StormObject.new(self)
  end

  def new_with_value(value)
    StormObject.new(self, value)
  end
end
