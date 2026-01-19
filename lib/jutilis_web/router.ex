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

  # Browser pipeline with portfolio resolution for public portfolio pages
  pipeline :portfolio do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JutilisWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
    plug JutilisWeb.Plugs.PortfolioResolver
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Portfolio home page - resolved by custom domain or flagship
  scope "/", JutilisWeb do
    pipe_through :portfolio

    get "/", PortfolioController, :home
  end

  # Path-based portfolio access: /p/:slug
  scope "/p", JutilisWeb do
    pipe_through :portfolio

    get "/:portfolio_slug", PortfolioController, :home
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

  scope "/", JutilisWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
  end

  scope "/", JutilisWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm-email/:token", UserSettingsController, :confirm_email
  end

  ## User portfolio management routes (for regular users to manage their own portfolio)
  scope "/portfolio", JutilisWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :portfolio_owner,
      on_mount: [{JutilisWeb.UserAuth, :ensure_authenticated}] do
      live "/", PortfolioLive.Dashboard, :index
      live "/settings", PortfolioLive.Settings, :edit
      live "/ventures", PortfolioLive.VentureIndex, :index
      live "/ventures/new", PortfolioLive.VentureForm, :new
      live "/ventures/:id/edit", PortfolioLive.VentureForm, :edit
      live "/pitch-decks", PortfolioLive.PitchDeckIndex, :index
      live "/pitch-decks/new", PortfolioLive.PitchDeckForm, :new
      live "/pitch-decks/:id/edit", PortfolioLive.PitchDeckForm, :edit
    end
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
