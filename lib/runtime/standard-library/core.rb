require_relative "./console"

Runtime["Object"].runtime_methods["clear"] = proc do |receiver, arguments|
  system "clear" or system "cls"
  Runtime["nil"]
end
