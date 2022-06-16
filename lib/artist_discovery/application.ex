defmodule ArtistDiscovery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ArtistDiscovery.Repo,
      # Start the Telemetry supervisor
      ArtistDiscoveryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ArtistDiscovery.PubSub},
      # Start the Endpoint (http/https)
      ArtistDiscoveryWeb.Endpoint
      # Start a worker by calling: ArtistDiscovery.Worker.start_link(arg)
      # {ArtistDiscovery.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ArtistDiscovery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArtistDiscoveryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
