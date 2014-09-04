defmodule ParsEx.Response do
  defstruct status_code: nil, body: nil, headers: %{}
  @type t :: %ParsEx.Response{status_code: integer, body: binary, headers: map}
end
