defmodule ShortlinkWeb.Router do
  use ShortlinkWeb, :router

  import ShortlinkWeb.UserAuth
  import ShortlinkWeb.CurrentPath

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ShortlinkWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug :put_current_path
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortlinkWeb do
    pipe_through :browser

    get "/:code", RedirectController, :redirect_url
  end

  ## Authentication routes

  scope "/", ShortlinkWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ShortlinkWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/_/signup", UserRegistrationLive, :new
      live "/_/login", UserLoginLive, :new
      live "/_/reset-password", UserForgotPasswordLive, :new
      live "/_/reset-password/:token", UserResetPasswordLive, :edit
    end

    post "/_/login", UserSessionController, :create
  end

  scope "/", ShortlinkWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{ShortlinkWeb.UserAuth, :ensure_authenticated}] do
      live "/_/settings", UserSettingsLive, :edit
      live "/_/settings/confirm-email/:token", UserSettingsLive, :confirm_email

      live "/", HomeLive, :home
    end
  end

  scope "/", ShortlinkWeb do
    pipe_through :browser

    delete "/_/logout", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{ShortlinkWeb.UserAuth, :mount_current_user}] do
      live "/_/confirm/:token", UserConfirmationLive, :edit
      live "/_/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ShortlinkWeb do
  #   pipe_through :api
  # end

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
