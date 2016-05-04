defmodule TimeTracking.Fastbill.InMemory do
  @behaviour TimeTracking.Fastbill

  def find_client(%{id: "toggl_id_found"}) do
    {:ok, %{id: "1", name: "found before"}}
  end

  def find_client(%{id: id}) do
    {:not_found, %{message: "client with ID '#{id}' not found"}}
  end

  def create_client(%{name: "Shaidy & Co"}) do
    {:ok, %{id: "2", name: "Shaidy & Co"}}
  end

  def find_project(%{id: "toggl_id_found", client_id: "client_id"}) do
    {:ok, %{id: "project_1", client_id: "client_id", name: "Already Existing"}}
  end

  def find_project(%{id: id, client_id: client_id}) do
    {:not_found, %{message: "project of client '#{client_id}' with ID '#{id}' not found"}}
  end

  def create_project(%{client_id: "client_id", name: "New Project"}) do
    {:ok, %{id: "project_2", name: "New Project"}}
  end
end
