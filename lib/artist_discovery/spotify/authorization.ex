defmodule ArtistDiscovery.Spotify.Authorization.Implementation do
  @moduledoc "This example uses an [`Agent`](https://hexdocs.pm/elixir/Agent.html) to persist the tokens"
  use HTTPoison.Base

  @http_client Application.get_env(:artist_discovery, :http_client)
  @scopes Application.get_env(:spotify_ex, :scopes)

  defp client_id, do: Application.get_env(:spotify_ex, :client_id)
  defp client_secret, do: Application.get_env(:spotify_ex, :secret_key)

  defp auth_token, do: Base.encode64("#{client_id()}:#{client_secret()}")

  def fetch_access_token do
    @http_client.post(
      "https://accounts.spotify.com/api/token",
      {:form, [
        {"grant_type", "client_credentials"},
        {"scope", @scopes}
      ]},
      [
        {"Authorization", "Basic #{auth_token()}"},
        {"Content-Type", "application/x-www-form-urlencoded"},
        {"Accept", "application/json"}
      ]
    )
  end
  # @doc "Use the credentials to access the Spotify API through the library"
  # def track(id) do
  #   credentials = get_creds()
  #   {:ok, track} = Track.get_track(credentials, id)
  #   track
  # end
end
