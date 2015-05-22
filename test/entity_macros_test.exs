defmodule Repox.Entity.MacroTest do
  use ExUnit.Case, async: true

  defmodule MyStruct do
    import Repox.Entity.Macros
    defstruct key: nil, value: ""
    define_entity_functions
  end

  test "%MyStruct{} to %{}" do
    my_struct = %MyStruct{}
    assert MyStruct.as_struct(my_struct) == %{key: nil, value: ""}
  end

  test "%{} to %MyStruct{}" do
    my_struct = MyStruct.from_struct(%MyStruct{}, %{key: 1, value: "a"})
    assert my_struct == %MyStruct{key: 1, value: "a"}
  end 

end
