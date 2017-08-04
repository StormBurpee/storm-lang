require_relative "./test_helper"
require_relative "../lib/interpreter"

class InterpreterTest < Test::Unit::TestCase
  def test_interpret
    code = <<-CODE
class Storm:
  def does_it_work:
    "yeah!"

storm_object = Storm.new
if storm_object:
  print(storm_object.does_it_work)
CODE
    assert_prints("Yeah!\n") { Interpreter.new.eval(code) }
  end
end
