defmodule Repox.Entity.Macros do
  @moduledoc """
  Some useful macros to support Entities.
  """

  @doc """
  Define functions to convert between %NamedStructures{} and %{} 
  """
  defmacro define_entity_functions do
    quote do
      def as_struct entity do
        Map.from_struct(entity)
      end

      def from_struct target, struct do
        Map.merge(target, struct)
      end
    end
  end
end


