defmodule ParsEx.Config do
  @moduledoc """
  Handles Mix Config lookup and default values from Application env

  Uses Mix.Config `:parsex` settings as configuration with `@defaults` fallback

  From github: phoenixframework\phoenix
  """
  
  defmodule UndefinedConfigError do
    defexception [:message]
    def exception(msg), do: %UndefinedConfigError{message: inspect(msg)}
  end

  @doc """
  Returns the Keyword List of configurations given the path for get_in lookup
  of `:parsex` application configuration.

  ## Examples

    iex> Config.get([:parse_base, :parse_url])

  """

  def get(path) do
    case get_in(Application.get_all_env(:parsex), path) do
      nil -> raise UndefinedConfigError, message: """
      No default configuration found for #{inspect path}
      """
      value -> value
    end
  end

end
