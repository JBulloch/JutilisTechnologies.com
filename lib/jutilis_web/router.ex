defmodule JutilisWeb.Router do
  use JutilisWeb, :router

  import JutilisWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JutilisWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JutilisWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/investors", JutilisWeb do
    pipe_through :browser

    post "/subscribe", SubscriberController, :create
  end

  ## Public investor routes (no auth required)
  scope "/investors", JutilisWeb do
    pipe_through :browser

    live_session :public_investor,
      on_mount: [{JutilisWeb.UserAuth, :mount_current_scope}] do
      live "/pitch-decks", InvestorLive.PitchDeckIndex, :index
      live "/pitch-decks/:id", InvestorLive.PitchDeckShow, :show
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", JutilisWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jutilis, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JutilisWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  # Registration disabled - single admin user only

  scope "/", JutilisWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm-email/:token", UserSettingsController, :confirm_email
  end

  scope "/", JutilisWeb do
    pipe_through [:browser]

    get "/users/log-in", UserSessionController, :new
    get "/users/log-in/:token", UserSessionController, :confirm
    post "/users/log-in", UserSessionController, :create
    delete "/users/log-out", UserSessionController, :delete
  end

  ## Admin routes

  scope "/admin", JutilisWeb do
    pipe_through [:browser, :require_authenticated_user, :require_admin]

    live_session :admin,
      on_mount: [{JutilisWeb.UserAuth, :ensure_admin}] do
      live "/dashboard", AdminLive.Dashboard, :index
      live "/pitch-decks", PitchDeckLive.Index, :index
      live "/pitch-decks/new", PitchDeckLive.Form, :new
      live "/pitch-decks/:id", PitchDeckLive.Show, :show
      live "/pitch-decks/:id/edit", PitchDeckLive.Form, :edit
      live "/ventures", AdminLive.VentureIndex, :index
      live "/ventures/new", AdminLive.VentureForm, :new
      live "/ventures/:id", AdminLive.VentureShow, :show
      live "/ventures/:id/edit", AdminLive.VentureForm, :edit
    end
  end
end
