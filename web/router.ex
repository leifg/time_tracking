defmodule TimeTracking.Router do
  use TimeTracking.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeTracking do
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
end
