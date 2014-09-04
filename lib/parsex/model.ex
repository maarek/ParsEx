defmodule ParsEx.Model do
  @moduledoc """
  Models are Elixir modules with ParsEx-specific behaviour.

  """

  defmacro __using__(options) do
    quote do

    end
  end

  defmodule UnknownResponseError do
    defexception [:message]
    def exception(msg), do: %UnknownResponseError{message: inspect(msg)}
  end
end
