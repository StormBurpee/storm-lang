require_relative "./console"
require_relative "./error"
require "readline"

Runtime["Object"].runtime_methods["clear"] = proc do |receiver, arguments|
  system "clear" or system "cls"
  Runtime["nil"]
end

Runtime["Object"].runtime_methods["pwd"] = proc do |receiver, arguments|
  console = Console.new
  console.rawlog(Dir.pwd)
end

Runtime["Object"].runtime_methods["readfile"] = proc do |receiver, arguments|
  file = Readline::readline("Filepath: ")
  Readline::HISTORY.push(file)
  #interpreter = Interpreter.new
  #interpreter.eval(file)
end
