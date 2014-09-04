defmodule ParsEx do
  alias ParsEx.Request
  alias ParsEx.Config

  @doc """
  Objects
  """

  @doc """
  GET
  """
  def get(path), do: response Request.get(path, get_headers) 

  @doc """
  GET with filters
  """
  def get(path, filters, options \\%{}), do: response Request.get(path, filters, options, get_headers)

  @doc """
  POST
  """
  def post(path, body), do: response Request.post(path, body, post_headers)

  @doc """
  PUT
  """
  def put(path, body), do: response Request.put(path, body, post_headers)

  @doc """
  PATCH
  """
  def patch(path, body), do: response Request.patch(path, body, post_headers)

  @doc """
  DELETE
  """
  def delete(path), do: response Request.request(:delete, path, "", get_headers)

  @doc """
  Queries

  Basic Queries
  """

  @doc """
  Query
  """
  def query(path), do: response get(path)

  @doc """
  Query with filters
  """
  def query(path, filters, options \\ %{}), do: response Request.get(path, filters, options, get_headers)

  @doc """
  Users

  """
  
  @doc """
  Signing Up
  """
  def signup(username, password, email, options \\ %{}) when username != nil and password != nil and email != nil do
    response Request.post("users", Map.merge(%{"username" => username, "password" => password, "email" => email}, options), post_headers)
  end

  @doc """
  Logging In
  """
  def login(username, password) do
    response Request.get("login", nil, %{"username" => username, "password" => password}, get_headers)
  end

  @doc """
  Request Password Reset
  """
  def requestPasswordReset(email) when email != nil do
    response Request.post("requestPasswordReset", %{"email" => email}, post_headers)
  end

  @doc """
  Validate User
  """
  def validateUser(sessionToken) when sessionToken != nil do
    response Request.get("users/me", Map.merge(get_headers, %{"X-Parse-Session-Token" => sessionToken}))
  end

  @doc """
  GET request headers
  """
  def get_headers do
    %{"X-Parse-Application-Id" => Config.get([:parse_auth, :parse_app_id]),
      "X-Parse-REST-API-Key"   => Config.get([:parse_auth, :parse_api_key])} 
  end

  @doc """
  POST request headers
  """
  def post_headers do
    Dict.put(get_headers, "Content-Type", "application/json")
  end


  defp response(status_code, body, headers) do
    %ParsEx.Response {
      status_code: status_code,
      body: body,
      headers: Enum.into(headers, %{})
    }
  end

  defp response(response) do
    %ParsEx.Response {
      status_code: response.status_code,
      body: response.body,
      headers: response.headers
    }
  end

end
