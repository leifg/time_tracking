defmodule TimeTracking.FastbillView do
  use TimeTracking.Web, :view

  def render("client.json", %{client: client}) do
    %{id: client.id, name: client.name}
  end
end
