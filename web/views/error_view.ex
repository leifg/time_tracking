defmodule TimeTracking.ErrorView do
  use TimeTracking.Web, :view

  def render("error.json", %{error: error}) do
    %{message: error.message}
  end
end
