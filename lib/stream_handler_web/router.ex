defmodule StreamHandlerWeb.Router do
  use StreamHandlerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {StreamHandlerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StreamHandlerWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/stream", StreamLive.Index, :index
    live "/stream/new", StreamLive.Index, :new
    live "/stream/:id/edit", StreamLive.Index, :edit

    live "/stream/:id", StreamLive.Show, :show
    live "/stream/:id/show/edit", StreamLive.Show, :edit

    live "/mail", MailLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamHandlerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:stream_handler, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: StreamHandlerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
