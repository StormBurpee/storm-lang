require_relative "./test_helper"
require_relative "../lib/runtime"

class RuntimeTest < Test::Unit::TestCase
  def test_object
    object = Runtime["Object"].call("new")
    assert_equal Runtime["Object"], object.runtime_class
  end
end
