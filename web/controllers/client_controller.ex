defmodule TimeTracking.ClientController do
  use TimeTracking.Web, :controller

  def create(conn, %{}) do
    render conn, "show.json", %{client: %{id: "1"}}
  end
end
