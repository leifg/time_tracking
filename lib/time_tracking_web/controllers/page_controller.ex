defmodule TimeTrackingWeb.PageController do
  use TimeTracking.Web, :controller

  def index(conn, _params) do
    render(conn, "show.json", %{message: "This is an API"})
  end
end
