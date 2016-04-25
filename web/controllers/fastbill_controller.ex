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

  defp render_client(conn, {:ok, client}) do
    render conn, "client.json", %{client: client}
  end

  defp render_client(conn, {:error, error}) do
    render conn, "error.json", %{error: error}
  end
end
