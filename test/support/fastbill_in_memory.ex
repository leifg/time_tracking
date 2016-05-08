defmodule TimeTracking.Fastbill.InMemory do
  @behaviour TimeTracking.Fastbill

  def find_client(%{external_id: "toggl:toggl_id_found"}) do
    {:ok, %{id: "1", external_id: "toggl:toggl_id_found", name: "found before"}}
  end

  def find_client(%{external_id: external_id}) do
    {:not_found, %{message: "client with ID '#{external_id}' not found"}}
  end

  def create_client(%{external_id: "toggl:toggl_id_not_found", name: "Shaidy & Co"}) do
    {:ok, %{id: "2", external_id: "toggl:toggl_id_not_found", name: "Shaidy & Co"}}
  end

  def find_project(%{external_id: "toggl:toggl_id_found", client_id: "1"}) do
    {:ok, %{id: "project_1", external_id: "toggl:toggl_id_found", client_id: "1", name: "Already Existing"}}
  end

  def find_project(%{external_id: id, client_id: client_id}) do
    {:not_found, %{message: "project of client '#{client_id}' with ID '#{id}' not found"}}
  end

  def create_project(%{client_id: "1", external_id: "toggl:toggl_id_not_found", name: "New Project"}) do
    {:ok, %{id: "project_2", external_id: "toggl:toggl_id_not_found", name: "New Project"}}
  end

  def create_time_slot(%{client_id: "1", minutes: 501, billable_minutes: 501, project_id: "project_1", date: "2016-05-08T09:17:53+00:00", start_time: "2016-05-08T09:17:53+00:00", end_time: "2016-05-08T17:39:11+00:00", comment: "controller test"}) do
    {:ok, %{id: "time_slot_1", comment: "controller test", start_time: "2016-05-08T09:17:53+00:00", end_time: "2016-05-08T17:39:11+00:00"}}
  end
end
