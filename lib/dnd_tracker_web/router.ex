defmodule DndTrackerWeb.Router do
  use DndTrackerWeb, :router

  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard"
    end
  end

  scope "/", DndTrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/campaigns", CampaignController
    resources "/players", PlayerController, except: [:create, :index, :new]
    resources "/enemies", EnemyController, except: [:create, :index, :new]

    get "/campaigns/:campaign_id/players/new", PlayerController, :new
    get "/campaigns/:campaign_id/players", PlayerController, :index
    post "/campaigns/:campaign_id/players", PlayerController, :create

    get "/campaigns/:campaign_id/enemies/new", EnemyController, :new
    get "/campaigns/:campaign_id/enemies", EnemyController, :index
    post "/campaigns/:campaign_id/enemies", EnemyController, :create
  end
end
