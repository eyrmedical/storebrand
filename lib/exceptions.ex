defmodule Storebrand.ConfigError do
  @moduledoc """
  Raised in case there is issues with the config.
  """
  defexception [:message]
end

defmodule Storebrand.ApiError do
  @moduledoc """
  Raised in case invalid response is returned from Storebrand API.
  """
  defexception [:message]
end

defmodule Storebrand.InvalidRequestData do
  @moduledoc """
  Raised in case request data is invalid.
  """
  defexception [:message]
end

defmodule Storebrand.PolicyNotFound do
  @moduledoc """
  Raised in case no valid policy is found by the supplied criteria.
  """
  defexception [:message]
end

defmodule Storebrand.UnsupportedAcceptType do
  @moduledoc """
  Raised in case request media type specified in Accept
  header is not application/json.
  """
  defexception [:message]
end

defmodule Storebrand.UnsupportedMediaType do
  @moduledoc """
  Raised in case request content type specified in Content-Type
  header is not application/json.
  """
  defexception [:message]
end

defmodule Storebrand.NoApplication do
  @moduledoc """
  Raised in case application doesn't exist.
  """
  defexception [:message]
end

defmodule Storebrand.MethodNotAllowed do
  @moduledoc """
  Raised in case request method is not allowed.
  """
  defexception [:message]
end

defmodule Storebrand.NoSecurityHeader do
  @moduledoc """
  Raised in case the clientSecret header value did not match.
  """
  defexception [:message]
end

defmodule Storebrand.GenericError do
  @moduledoc """
  Raised for non-specific backend errors related to this library.
  """
  defexception [:message]
end
