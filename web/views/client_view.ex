defmodule TimeTracking.ClientView do
  use TimeTracking.Web, :view

  def render("show.json", %{client: client}) do
    %{message: "created", id: client.id}
  end
end
