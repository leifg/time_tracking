defmodule TimeTracking.ClientController do
  use TimeTracking.Web, :controller
  @fastbill_api Application.get_env(:time_tracking, :fastbill_api)

  def create(conn, %{"id" => id, "name" => name, "at" => at}) do
    render conn, "show.json", %{client: @fastbill_api.create(%{id: id, name: name, at: at})}
  end
end
