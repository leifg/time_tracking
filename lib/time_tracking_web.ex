defmodule TimeTracking.Web do
  def controller do
    quote do
      use Phoenix.Controller, namespace: TimeTracking
      import TimeTrackingWeb.Router.Helpers
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/time_tracking_web/template", namespace: TimeTracking

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      import TimeTrackingWeb.Router.Helpers
    end
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
