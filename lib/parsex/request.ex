defmodule ParsEx.Request do
  use HTTPoison.Base
  alias ParsEx.Config

  defmodule UnprocessableResponse do
    defexception [:message]
    def exception(msg), do: %UnprocessableResponse{message: inspect(msg)}
  end

  def parse_url(endpoint) do
    Config.get([:parse_base, :parse_url]) <> endpoint
  end

  def encode_request_body(body) do
    Poison.encode!(body) |> IO.iodata_to_binary
  end

  def decode_response_body(body) do
    case Poison.decode(body) do
      {:ok, text} -> text
      {:error, _} -> raise UnprocessableResponse, message: """
      The response body json could not be processed.
      """
    end
  end

  def parse_filters(filters, options) when is_map(filters) and map_size(filters) > 0 do
    %{where: Poison.encode!(filters) |> IO.iodata_to_binary}
    |> Dict.merge(options)
    |> URI.encode_query
  end

  def parse_filters(_, options) when is_map(options) do
    options |> URI.encode_query
  end

  def parse_filters(_, _) do
    raise ArgumentError, message: "filters and options arguments should be maps"
  end

  def get(path, filters, options, headers) do
    filter_string = parse_filters(filters, options)
    request(:get, parse_url(path) <> "?" <> filter_string, "", headers)
  end

  def get(path, headers) do
    request(:get, parse_url(path), "", headers)
  end

  def post(path, body, headers) do
    request(:post, parse_url(path), encode_request_body(body), headers)
  end

  def put(path, body, headers) do
    request(:put, parse_url(path), encode_request_body(body), headers)
  end

  def patch(path, body, headers) do
    request(:patch, parse_url(path), encode_request_body(body), headers)
  end

  def delete(path, headers) do
    request(:delete, parse_url(path), "", headers)
  end
end
