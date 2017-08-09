defmodule TimeTrackingWeb.FastbillController do
  use TimeTracking.Web, :controller
  @fastbill_api Application.get_env(:time_tracking, :fastbill_api)

  def create_client(conn, params) do
    render_client(conn, find_or_create_client(params))
  end

  def create_project(conn, params) do
    render_project(conn, find_or_create_project(params))
  end

  def create_time_slot(conn, params) do
    {:ok, fb_project} = find_or_create_project(params["project"])

    billable_flag = params["billable"] |> String.downcase |> to_boolean
    start_time = params["start"] |> TimezoneConverter.convert(timezone())
    end_time = params["stop"] |> TimezoneConverter.convert(timezone())
    minutes = params["duration_minutes"] |> String.to_integer
    billable_minutes = params["duration_minutes"] |> String.to_integer |> BillableCalculator.calculate(billable_flag)
    api_return = @fastbill_api.create_time_slot(%{client_id: fb_project.client_id, project_id: fb_project.id, date: start_time, start_time: start_time, minutes: minutes, billable_minutes: billable_minutes, end_time: end_time, comment: params["description"]})
    render_time_slot(conn, api_return)
  end

  defp find_or_create_client(%{"id" => external_id, "name" => name}) do
    case @fastbill_api.find_client(%{external_id: "toggl:#{external_id}"}) do
      {:not_found, _} ->
        @fastbill_api.create_client(%{external_id: "toggl:#{external_id}", name: name})
      res ->
        res
    end
  end

  defp find_or_create_project(%{"id" => external_id, "name" => name, "client" => client}) do
    {:ok, fb_client} = find_or_create_client(client)
    case @fastbill_api.find_project(%{external_id: "toggl:#{external_id}", client_id: fb_client.id}) do
      {:not_found, _} ->
        @fastbill_api.create_project(%{client_id: fb_client.id, external_id: "toggl:#{external_id}", name: name})
      res ->
        res
    end
  end

  defp timezone do
    Application.get_env(:time_tracking, :fastbill_timezone)
  end

  defp to_boolean("true"), do: true
  defp to_boolean(_), do: false

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
