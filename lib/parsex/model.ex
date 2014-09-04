defmodule ParsEx.Model do
  @moduledoc """
  Models are Elixir modules with ParsEx-specific behaviour.

  """
  
  @doc false
  defmacro __using__(_) do
    quote do
      use ParsEx.Model.Schema
    end
  end

  @type t :: map

  def to_json do
    # Convert to JSON
  end

  def from_json(json) do
    {:ok, decoded} = Poison.decode(json)
    __MODULE__.create(ParsEx.Model.list_to_args(HashDict.to_list(decoded), []))
  end

  def create do
    __MODULE__.new()
  end

  def create(args) do
    __MODULE__.new(args).bucket(bucket)
  end

  def bucket() do
    __MODULE__.__model__(:name)
  end

  defmodule UnknownResponseError do
    defexception [:message]
    def exception(msg), do: %UnknownResponseError{message: inspect(msg)}
  end

  defp list_to_args([], accum) do
    accum
  end

  defp list_to_args([{key, val}|rest], accum) do
    list_to_args(rest, [{binary_to_atom(key), val}|accum])
  end
end
