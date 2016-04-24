defmodule TimeTracking.FastbillController do
  use TimeTracking.Web, :controller
  @fastbill_api Application.get_env(:time_tracking, :fastbill_api)

  def create_client(conn, %{"id" => id, "name" => name, "at" => at}) do
    render conn, "client.json", %{client: @fastbill_api.create(%{id: id, name: name, at: at})}
  end
end
