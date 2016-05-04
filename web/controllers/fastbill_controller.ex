defmodule TimeTracking.FastbillController do
  use TimeTracking.Web, :controller
  @fastbill_api Application.get_env(:time_tracking, :fastbill_api)

  def create_client(conn, %{"id" => id, "name" => name, "at" => at}) do
    api_return = case @fastbill_api.find_client(%{id: id}) do
      {:not_found, _} ->
        @fastbill_api.create_client(%{id: id, name: name, at: at})
      res ->
        res
    end
    render_client(conn, api_return)
  end

  def create_project(conn, %{"id" => id, "name" => name, "cid" => client_id, "at" => at}) do
    api_return = case @fastbill_api.find_project(%{id: id, client_id: client_id}) do
      {:not_found, _} ->
        @fastbill_api.create_project(%{client_id: client_id, name: name, at: at})
      res ->
        res
    end
    render_project(conn, api_return)
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
end
