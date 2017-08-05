console_class = StormClass.new
console_class.runtime_class = console_class
Runtime['Console'] = console_class

# -- METHODS
Runtime['Console'].runtime_methods['log'] = proc do |receiver, arguments|
  if defined?(arguments.first.ruby_value).nil?
    puts arguments.first
  else
    la = []
    arguments.each { |x| la.push(x.ruby_value) }
    puts la.join(" ")
  end
  Runtime["nil"]
end
Runtime['Console'].runtime_methods['clear'] = proc do |receiver, arguments|
  system "clear" or system "cls"
  Runtime["nil"]
end
Runtime["Console"].runtime_methods["count"] = proc do |receiver, arguments|
  if not receiver.declared_variables["count"]
    receiver.declared_variables["count"] = 0
  end
  if arguments.first
    v = arguments.first.ruby_value
    if not receiver.declared_variables[v]
      receiver.declared_variables[v] = 0
    end
    receiver.declared_variables[v] += 1
    puts "["+v+": "+ receiver.declared_variables[v].to_s+"]"
  else
    receiver.declared_variables["count"] += 1
    puts receiver.declared_variables["count"]
  end
end
Runtime["Console"].runtime_methods["error"] = proc do |receiver, arguments|
  if defined?(arguments.first.ruby_value).nil?
    puts "\e[31mError: "+arguments.first+"\e[0m"
  else
    la = ["\e[31mError:"]
    arguments.each { |x| la.push(x.ruby_value) }
    la.push("\e[0m")
    puts la.join(" ")
  end
end
Runtime["Console"].runtime_methods["trace"] = proc do |receiver, arguments|
  puts (Thread.current.backtrace.join("\n"))
end
