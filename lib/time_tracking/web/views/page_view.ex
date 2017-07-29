defmodule TimeTracking.PageView do
  use TimeTracking.Web, :view

  def render("show.json", %{message: message}) do
    %{message: message}
  end
end
