defmodule ParsEx.Model.Schema do
  @moduledoc """
  """

  require ParsEx.Util, as: Util
  
  @doc false
  defmacro __using__(_) do
    quote do
      import ParsEx.Model, only: [to_json: 0, from_json: 1, create: 0, create: 1, bucket: 0]
      import ParsEx.Model.Schema, only: [schema: 2, schema: 3]
    end
  end

  defmacro schema(source, opts \\ [], block)

  defmacro schema(source, opts, [do: block]) do
    quote do
      opts = (Module.get_attribute(__MODULE__, :schema_defaults) || [])
             |> Keyword.merge(unquote(opts))

      @parsex_fields []
      @struct_fields []
      @parsex_source unquote(source)
      
      import ParsEx.Model.Schema, only: [field: 1, field: 2, field: 3]
      unquote(block)
      import ParsEx.Model.Schema, only: []

      all_fields = @parsex_fields |> Enum.reverse

      def __schema__(:source), do: @parsex_source

      Module.eval_quoted __MODULE__, [
        ParsEx.Model.Schema.parsex_struct(@struct_fields),
        ParsEx.Model.Schema.parsex_fields(all_fields)]
    end
  end

  @doc """
  Defines a field on the model schema with given name and type, will also create a struct field.
  """
  defmacro field(name, type \\ :string, opts \\ []) do
    quote do
      ParsEx.Model.Schema.__field__(__MODULE__, unquote(name), unquote(type), unquote(opts))
    end
  end

  @doc false
  def __field__(mod, name, type, opts) do
    check_type!(type)
    fields = Module.get_attribute(mod, :parsex_fields)

    clash = Enum.any?(fields, fn {prev, _} -> name == prev end)
    if clash do
      raise ArgumentError, message: "field `#{name}` was already set on schema"
    end

    struct_fields = Module.get_attribute(mod, :struct_fields)
    Module.put_attribute(mod, :parsex_fields, [{name, [type: type] ++ opts}|fields])
  end

  @doc false
  def parsex_struct(struct_fields) do
    quote do
      defstruct unquote(Macro.escape(struct_fields))
    end
  end

  @doc false
  def parsex_fields(fields) do
    quoted = Enum.map(fields, fn {name, opts} ->
      quote do
        def __schema__(:field, unquote(name)), do: unquote(opts)
        def __schema__(:field_type, unquote(name)), do: unquote(opts[:type])
      end
    end)

    field_names = Enum.map(fields, &elem(&1, 0))
    quoted ++ [ quote do
      def __schema__(:field, _), do: nil
      def __schema__(:field_type, _), do: nil
      def __schema__(:field_names), do: unquote(field_names)
    end ]
  end

  defp check_type!({outer, inner}) when outer in Util.poly_types and inner in Util.types, do: :ok

  defp check_type!(type) when type in Util.types, do: :ok

  defp check_type!(type) do
    raise ArgumentError, message: "`#{Macro.to_string(type)}` is not a valid field type"
  end

end
