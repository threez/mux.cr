require "http/request"

class HTTP::Request
  # The path params that where captured using the colon placeholders.
  # For example given the path `/users/:user` the path parameter `:user`
  # will be captured as `user`.
  property path_params : Hash(String, String)?

  # access the path parameter by its name or raises `KeyError`
  def path_param(key) : String
    @path_params.not_nil![key.to_s]
  end

  # access the path parameter by its name, or returns `nil`
  def path_param?(key) : String?
    @path_params.not_nil!.fetch(key.to_s) { nil }
  end
end
