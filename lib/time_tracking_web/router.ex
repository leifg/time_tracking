defmodule TimeTrackingWeb.Router do
  use TimeTracking.Web, :router

  pipeline :api do
    plug PlugBasicAuth, validation: &AuthHandler.is_authorized?/2
    plug :accepts, ["json"]
  end

  scope "/", TimeTrackingWeb do
    pipe_through :api

    get "/", PageController, :index
  end

  scope "/clients", TimeTracking do
    pipe_through :api

    post "/", FastbillController, :create_client
  end

  scope "/projects", TimeTracking do
    pipe_through :api

    post "/", FastbillController, :create_project
  end

  scope "/time_slots", TimeTracking do
    pipe_through :api

    post "/", FastbillController, :create_time_slot
  end
end
