defmodule TimeTracking.FastbillView do
  use TimeTracking.Web, :view

  def render("client.json", %{client: client}) do
    %{id: client.id, name: client.name}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id, name: project.name}
  end
end
