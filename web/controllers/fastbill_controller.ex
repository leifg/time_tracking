defmodule TimeTracking.FastbillController do
  use TimeTracking.Web, :controller
  @fastbill_api Application.get_env(:time_tracking, :fastbill_api)

  def create_client(conn, %{"id" => external_id, "name" => name, "at" => at}) do
    api_return = case @fastbill_api.find_client(%{external_id: "toggl:#{external_id}"}) do
      {:not_found, _} ->
        @fastbill_api.create_client(%{external_id: "toggl:#{external_id}", name: name, at: at})
      res ->
        res
    end
    render_client(conn, api_return)
  end

  def create_project(conn, %{"id" => external_id, "name" => name, "cid" => external_client_id, "at" => at}) do
    {:ok, client} = @fastbill_api.find_client(%{external_id: "toggl:#{external_client_id}"})
    client_id = client.id
    api_return = case @fastbill_api.find_project(%{external_id: "toggl:#{external_id}", client_id: client_id}) do
      {:not_found, _} ->
        @fastbill_api.create_project(%{client_id: client_id, external_id: "toggl:#{external_id}", name: name, at: at})
      res ->
        res
    end
    render_project(conn, api_return)
  end

  def create_time_slot(conn, params) do
    project = params["project"]

    {:ok, fb_client} = @fastbill_api.find_client(%{external_id: "toggl:#{project["cid"]}"})
    {:ok, fb_project} = @fastbill_api.find_project(%{external_id: "toggl:#{project["id"]}", client_id: fb_client.id})

    minutes = params["duration_minutes"] |> String.to_integer
    api_return = @fastbill_api.create_time_slot(%{client_id: fb_client.id, project_id: fb_project.id, date: params["start"], start_time: params["start"], minutes: minutes, billable_minutes: minutes, end_time: params["stop"], comment: params["description"]})
    render_time_slot(conn, api_return)
  end

  defp render_project(conn, {:ok, project}) do
    render conn, "project.json", %{project: project}
  end

  defp render_project(conn, {:error, error}) do
    render conn, "error.json", %{error: error}
  end

  defp render_client(conn, {:ok, client}) do
    render conn, "client.json", %{client: client}
  end

  defp render_client(conn, {:error, error}) do
    render conn, "error.json", %{error: error}
  end

  defp render_time_slot(conn, {:ok, time_slot}) do
    render conn, "time_slot.json", %{time_slot: time_slot}
  end

  defp render_time_slot(conn, {:error, error}) do
    render conn, "error.json", %{error: error}
  end
end
