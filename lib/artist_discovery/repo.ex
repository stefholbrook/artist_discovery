defmodule ArtistDiscovery.Repo do
  use Ecto.Repo,
    otp_app: :artist_discovery,
    adapter: Ecto.Adapters.Postgres
end
