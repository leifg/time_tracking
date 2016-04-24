defmodule TimeTracking.FastbillView do
  use TimeTracking.Web, :view

  def render("client.json", %{client: client}) do
    %{status: client.status, id: client.id}
  end
end
