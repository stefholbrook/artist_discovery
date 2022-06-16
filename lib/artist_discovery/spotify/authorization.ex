defmodule ArtistDiscovery.Authorization.Implementation do
  @moduledoc "This example uses an [`Agent`](https://hexdocs.pm/elixir/Agent.html) to persist the tokens"
  use HTTPoison.Base

  defp client_id, do: Application.get_env(:spotify_ex, :client_id)
  defp client_secret, do: Application.get_env(:spotify_ex, :secret_key)
  defp auth_token, do: Base.encode64("#{client_id()}:#{client_secret()}")


  @doc "The [`Agent`](https://hexdocs.pm/elixir/Agent.html) is started with an empty `Credentials` struct"
  def start_link do
    Agent.start_link(fn -> %Spotify.Credentials{} end, name: CredStore)
  end

  defp get_creds, do: Agent.get(CredStore, &(&1))

  defp put_creds(creds), do: Agent.update(CredStore, fn(_) -> creds end)

  @doc "Used to link the user to Spotify to kick off the auth process"
  def auth_url, do: Spotify.Authorization.url

  @doc "`params` are passed to your callback endpoint from Spotify"
  def authenticate(params) do
    creds = get_creds()
    {:ok, new_creds} = Spotify.Authentication.authenticate(creds, params)
    put_creds(new_creds) # make sure to persist the credentials for later!
  end

  # def post(url, body, headers \\ [], opts \\ []) do
  def post do
    HTTPoison.post!(
      "https://accounts.spotify.com/api/token",
      {:form, [
        {"grant_type", "client_credentials"},
        {"scope", "user-read-private user-read-email playlist-read-collaborative"}
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
