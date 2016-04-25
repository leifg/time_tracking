defmodule TimeTracking.Fastbill do
  @callback find_client(params :: %{}) :: %{}
  @callback create_client(params :: %{}) :: %{}
end
