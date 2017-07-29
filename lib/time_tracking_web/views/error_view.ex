defmodule TimeTrackingWeb.ErrorView do
  use TimeTracking.Web, :view

  def render("error.json", %{error: error}) do
    %{message: error.message}
  end

  def render("400.json", _assigns) do
    %{message: "Bad Request"}
  end

  def render("500.json", _assigns) do
    %{message: "Server Internal Error"}
  end
end
