defmodule ParsEx.Util do
  @moduledoc """
  This module provides utility functions for ParsEx
  """

  defmacro types do
    ~w(string number boolean array object date bytes file null)a
  end

  defmacro poly_types do
    ~w(array)a
  end
end
