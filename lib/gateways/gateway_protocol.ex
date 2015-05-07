# TODO: Add complete set of functions
defprotocol Gateway do
  def to_list gw_impl
  def put     gw_impl, entry
  def filter  gw_impl, f
end


