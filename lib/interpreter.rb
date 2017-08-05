require_relative "parser"
require_relative "runtime"

class Interpreter
  def initialize
    @parser = Parser.new
  end

  def eval(code)
    @parser.parse(code).eval(Runtime)
  end
end

class Nodes
  # This method is the "interpreter" part of our language. All nodes know how to eval
  # itself and returns the result of its evaluation by implementing the "eval" method.
  # The "context" variable is the environment in which the node is evaluated (local
  # variables, current class, etc.).
  def eval(context)
    return_value = nil
    nodes.each do |node|
      return_value = node._eval(context)
    end
    # The last value _evaluated in a method is the return value. Or nil if none.
    return_value || Runtime["nil"]
  end
end

class NumberNode
  def _eval(context)
    # Here we access the Runtime, which we'll see in the next section, to create a new
    # instance of the Number class.
    Runtime["Number"].new_with_value(value)
  end
end

class StringNode
  def _eval(context)
    Runtime["String"].new_with_value(value)
  end
end

class TrueNode
  def _eval(context)
    Runtime["true"]
  end
end

class FalseNode
  def _eval(context)
    Runtime["false"]
  end
end

class NilNode
  def _eval(context)
    Runtime["nil"]
  end
end

class StaticNode
  def _eval(context)
    Runtime["static"]
  end
end

class CallNode
  def _eval(context)
    # If there's no receiver and the method name is the name of a local variable, then
    # it's a local variable access. This trick allows us to skip the () when calling a
    # method.
    if receiver.nil? && context.locals[method] && arguments.empty?
      context.locals[method]

    # Method call
    else
      if receiver
        value = receiver._eval(context)
      else
        # In case there's no receiver we default to self, calling "print" is like
        # "self.print".
        value = context.current_self
      end

      _eval_arguments = arguments.map { |arg| arg._eval(context) }
      value.call(method, _eval_arguments)
    end
  end
end

class OperatorNode
  def _eval(context)
    ca = a._eval(context).ruby_value
    cb = b._eval(context).ruby_value
    result = eval ca.to_s + comparison + cb.to_s
    @parser = Parser.new
    @parser.parse(result.to_s).eval(Runtime)
  end
end

class StringCmpNode
  def _eval(context)
    result = a.to_s + b.to_s
    result.to_s
  end
end

class GetConstantNode
  def _eval(context)
    context[name]
  end
end

class SetConstantNode
  def _eval(context)
    context[name] = value._eval(context)
  end
end

class SetLocalNode
  def _eval(context)
    context.locals[name] = value._eval(context)
    
  end
end

class DefNode
  def _eval(context)
    # Defining a method is adding a method to the current class.
    # TODO: Fix static Methods.
    if static
      method = StormMethod.new(params, body)
      # TODO:   make this a whole lot nicer. Right now, I'm pretty sure it's adding it to all classes...
      #         potentially, could change Runtime["Class"] to something like Runtime[context.current_class] but
      #         that might bring us back to the same issue.
      Runtime["Class"].runtime_methods[name] = method
      #context.current_class.static_methods[name] = method
    else
      method = StormMethod.new(params, body)
      context.current_class.runtime_methods[name] = method
    end
  end
end

class ClassNode
  def _eval(context)
    # Try to locate the class. Allows reopening classes to add methods.
    storm_class = context[name]

    unless storm_class # Class doesn't exist yet
      storm_class = StormClass.new
      # Register the class as a constant in the runtime.
      context[name] = storm_class
    end

    # _evaluate the body of the class in its context. Providing a custom context allows
    # to control where methods are added when defined with the def keyword. In this
    # case, we add them to the newly created class.
    class_context = Context.new(storm_class, storm_class)
    body.eval(class_context)

    storm_class
  end
end

class SuperClassNode
  def _eval(context)
    # Try to locate the class. Allows reopening classes to add methods.
    storm_class = context[name]

    if defined?(context[inheritence])
      if context[inheritence]
      else
        raise "Cannot find class with name '" + inheritence + "'"
      end
    end

    unless storm_class # Class doesn't exist yet
      storm_class = StormClass.new
      storm_class.inherits(context[inheritence])
      # Register the class as a constant in the runtime.
      context[name] = storm_class
    end

    # _evaluate the body of the class in its context. Providing a custom context allows
    # to control where methods are added when defined with the def keyword. In this
    # case, we add them to the newly created class.
    class_context = Context.new(storm_class, storm_class)

    body.eval(class_context)

    storm_class
  end
end

class IfNode
  def _eval(context)
    # We turn the condition node into a Ruby value to use Ruby's "if" control
    # structure.
    if condition._eval(context).ruby_value
      body.eval(context)
    end
  end
end
