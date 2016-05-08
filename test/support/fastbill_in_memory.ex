defmodule TimeTracking.Fastbill.InMemory do
  @behaviour TimeTracking.Fastbill

  def find_client(%{external_id: "toggl:toggl_id_found"}) do
    {:ok, %{id: "client_1", external_id: "toggl:toggl_id_found", name: "found before"}}
  end

  def find_client(%{external_id: external_id}) do
    {:not_found, %{message: "client with ID '#{external_id}' not found"}}
  end

  def create_client(%{external_id: "toggl:toggl_id_not_found", name: "Shaidy & Co"}) do
    {:ok, %{id: "client_2", external_id: "toggl:toggl_id_not_found", name: "Shaidy & Co"}}
  end

  def find_project(%{external_id: "toggl:toggl_id_found", client_id: "client_1"}) do
    {:ok, %{id: "project_1", external_id: "toggl:toggl_id_found", client_id: "client_1", name: "Already Existing"}}
  end

  def find_project(%{external_id: id, client_id: client_id}) do
    {:not_found, %{message: "project of client '#{client_id}' with ID '#{id}' not found"}}
  end

  def create_project(%{client_id: "client_1", external_id: "toggl:toggl_id_not_found", name: "New Project"}) do
    {:ok, %{id: "project_2", external_id: "toggl:toggl_id_not_found", client_id: "client_2", name: "New Project"}}
  end

  def create_time_slot(%{client_id: "client_1", minutes: 501, billable_minutes: 501, project_id: "project_1", date: "2016-05-08T11:17:53+02:00", start_time: "2016-05-08T11:17:53+02:00", end_time: "2016-05-08T19:39:11+02:00", comment: "controller test"}) do
    {:ok, %{id: "time_slot_1", comment: "controller test", start_time: "2016-05-08T11:17:53+02:00", end_time: "2016-05-08T19:39:11+02:00"}}
  end
end
