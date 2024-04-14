defmodule Shortlink.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ShortlinkWeb.Telemetry,
      Shortlink.Repo,
      {DNSCluster, query: Application.get_env(:shortlink, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Shortlink.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Shortlink.Finch},
      # Start a worker by calling: Shortlink.Worker.start_link(arg)
      # {Shortlink.Worker, arg},
      Shortlink.Scheduler,
      # Start to serve requests, typically the last entry
      ShortlinkWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Shortlink.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ShortlinkWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
