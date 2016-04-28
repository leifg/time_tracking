defmodule TimeTracking.Fastbill.InMemory do
  @behaviour TimeTracking.Fastbill

  def find_client(%{id: "toggl_id_found"}) do
    {:ok, %{id: "1", name: "found before"}}
  end

  def find_client(%{id: id}) do
    {:not_found, %{message: "client with ID #{id} not found"}}
  end

  def create_client(%{name: "Shaidy & Co"}) do
    {:ok, %{id: "2", name: "Shaidy & Co"}}
  end
end
