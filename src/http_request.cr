require "http/request"

class HTTP::Request
  # The path params that where captured using the colon placeholders.
  # For example given the path `/users/:user` the path parameter `:user`
  # will be captured as `user`.
  property path_params : Hash(String, String)?

  # access the path parameter by its name or raises `KeyError`
  def path_param(key) : String
    params = @path_params
    raise KeyError.new("no path params set") if params.nil?
    params[key.to_s]
  end

  # access the path parameter by its name, or returns `nil`
  def path_param?(key) : String?
    @path_params.try &.fetch(key.to_s) { nil }
  end
end
