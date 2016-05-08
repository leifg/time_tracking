defmodule TimeTracking.FastbillView do
  use TimeTracking.Web, :view

  def render("client.json", %{client: client}) do
    %{id: client.id, external_id: client.external_id, name: client.name}
  end

  def render("project.json", %{project: project}) do
    %{id: project.id, external_id: project.external_id, name: project.name}
  end

  def render("time_slot.json", %{time_slot: time_slot}) do
    %{id: time_slot.id, comment: time_slot[:comment], start_time: time_slot.start_time, end_time: time_slot.end_time}
  end
end
