defmodule FileGateway do
  @moduledoc """
  In memory implementation of the [Gateway](Gateway.html)-protocol.

  FileGateway uses 'Poison' to en/decode data to/from JSON and stores
  JSON-strings in :path

  #### Usage:

      gw = %FileGateway{path: "/to/your/file"}
  """
  defstruct path: Application.get_env(:repox, :file_gw_path)
end

defimpl Gateway, for: FileGateway do

  @default_content "[]"

  def to_list gw_impl do
    read(gw_impl.path, @default_content)
  end

  def put gw_impl, entry do
    list = read(gw_impl.path, @default_content)
    write(gw_impl.path, [entry|list])
    %FileGateway{ path: gw_impl.path }
  end

  def filter gw_impl, f do
    read(gw_impl.path, "[]")
      |> Enum.filter f
  end


  def count gw_impl do
    to_list(gw_impl) |> Enum.count
  end

  def drop gw_impl do
    write gw_impl.path, []
    self
  end

  # FILE & JSON Handling
  defp write path, entries do
    Poison.Encoder.encode(entries, [])
      |> write_file(path)
  end

  defp write_file data, path do
    File.write!(path, data, [])
  end

  defp read path, default do
    case File.read(path) do
      {:ok, body} -> body
      {:error, _error} -> default
    end |> Poison.Parser.parse!(keys: :atoms!)
  end

end



