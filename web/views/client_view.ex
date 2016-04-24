defmodule TimeTracking.ClientView do
  use TimeTracking.Web, :view

  def render("show.json", %{client: client}) do
    %{status: client.status, id: client.id}
  end
end
