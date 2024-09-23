defmodule ShortlinkWeb.Router do
  use ShortlinkWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ShortlinkWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug ShortlinkWeb.AuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortlinkWeb do
    get "/:code", RedirectController, :redirect_url
  end

  scope "/", ShortlinkWeb do
    pipe_through :browser

    delete "/_/logout", LogoutController, :logout

    live_session :not_authenticated,
      layout: {ShortlinkWeb.Layouts, :app} do
      live "/_/login", LoginLive.Index
    end

    live_session :authenticated,
      on_mount: [ShortlinkWeb.AuthHook],
      layout: {ShortlinkWeb.Layouts, :live} do
      live "/", HomeLive.Index, :new
      live "/_/links", LinksLive.Index, :new
    end
  end

  scope "/_/oauth", ShortlinkWeb do
    pipe_through :browser

    get "/request/:provider", OAuthController, :request
    get "/callback/:provider", OAuthController, :callback
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:shortlink, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ShortlinkWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
