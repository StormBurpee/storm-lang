Runtime["Object"].runtime_methods["print"] = proc do |receiver, arguments|
  if defined?(arguments.first.ruby_value).nil?
    puts arguments.first
  else
    la = []
    arguments.each { |x| la.push(x.ruby_value) }
    puts la.join(" ")
  end
  Runtime["nil"]
end

Runtime["Object"].runtime_methods["clear"] = proc do |receiver, arguments|
  system "clear" or system "cls"
  Runtime["nil"]
end
