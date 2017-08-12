defmodule TimeTrackingWeb.ErrorView do
  use TimeTracking.Web, :view

  def render("error.json", %{error: error}) do
    %{message: error.message}
  end

  def render("400.json", _assigns) do
    %{message: "Bad Request"}
  end

  def render("404.json", _assigns) do
    %{message: "Not Found"}
  end

  def render("500.json", _assigns) do
    %{message: "Server Internal Error"}
  end

  def render("500.html", _assigns) do
    "<html><body>error</body></html>"
  end

  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
