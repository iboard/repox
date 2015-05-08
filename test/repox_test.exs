defmodule RepoxTest do
  use ExUnit.Case, async: true

  # THIS IS A DRAFT ONLY

  setup do
    {:ok, in_memory: :in_memory_gw, in_file: :in_file_gw }
  end

  test "run with InMemory Gateway", %{in_memory: gw} do
    assert :in_memory_gw == gw
  end

  test "run with File Gateway", %{in_file: gw} do
    assert :in_file_gw == gw
  end

end
