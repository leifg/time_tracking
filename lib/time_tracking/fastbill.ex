defmodule TimeTracking.Fastbill do
  @callback find_client(params :: %{}) :: %{}
  @callback create_client(params :: %{}) :: %{}
  @callback find_project(params :: %{}) :: %{}
  @callback create_project(params :: %{}) :: %{}
  @callback create_time_slot(params :: %{}) :: %{}
end
