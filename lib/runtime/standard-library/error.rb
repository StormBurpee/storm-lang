class Error < StormClass
  attr_reader :error_message

  def initialize(error_message = "")
    @error_message = error_message

    super()
  end

  def printerror(console, arguments)
    console.error(arguments)
  end

  def print(message)
    puts "\e[31mError: "+message+"\e[0m"
  end

  def throw
    if defined?@error_message.ruby_value
      puts "\e[31mError: "+@error_message.ruby_value+"\e[0m"
    else
      puts "\e[31mError: "+@error_message+"\e[0m"
    end
  end

  def seterror(error_message)
    @error_message = error_message
  end

  def new(error_message = "")
    @error_message = error_message
  end
end

error_class = Error.new
error_class.runtime_class = error_class
Runtime['Error'] = error_class

# -- METHODS
Runtime['Error'].runtime_methods['printerror'] = proc do |receiver, arguments|
  receiver.printerror(Runtime['Console'], arguments)
  Runtime["nil"]
end

Runtime['Error'].runtime_methods['seterror'] = proc do |receiver, arguments|
  receiver.seterror(arguments.first)
end
Runtime['Error'].runtime_methods['throw'] = proc do |receiver, arguments|
  receiver.throw()
end
Runtime['Error'].runtime_methods['new'] = proc do |receiver, arguments|
  receiver.seterror(arguments.first)
end
