storm_class = StormClass.new
storm_class.runtime_class = storm_class
object_class = StormClass.new
object_class.runtime_class = storm_class

Runtime = Context.new(object_class.new)

Runtime["Class"] = storm_class
Runtime["Object"] = object_class
Runtime["Number"] = StormClass.new
Runtime["String"] = StormClass.new

Runtime["TrueClass"] = StormClass.new
Runtime["FalseClass"] = StormClass.new
Runtime["NilClass"] = StormClass.new

Runtime["true"] = Runtime["TrueClass"].new_with_value(true)
Runtime["false"] = Runtime["FalseClass"].new_with_value(false)
Runtime["nil"] = Runtime["NilClass"].new_with_value(nil)

Runtime["Class"].runtime_methods["new"] = proc do |receiver, arguments|
  receiver.new
end
#Runtime["Class"].static_methods["new"] = proc do |receiver, arguments |
#  receiver.new
#end
Runtime["Class"].runtime_methods["inherits"] = proc do |receiver, arguments|
  receiver.inherits(arguments.first)
end
