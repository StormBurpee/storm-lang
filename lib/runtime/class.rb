class StormClass < StormObject
  attr_reader :runtime_methods

  def initialize
    @runtime_methods = {}
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
      raise "Method not found: #{method_name}"
    end
    method
  end

  def new
    StormObject.new(self)
  end

  def new_with_value(value)
    StormObject.new(self, value)
  end
end