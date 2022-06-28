defmodule ArtistDiscovery.Spotify.Implementation do
  alias ArtistDiscovery.Spotify.Cacher

  @spotify_authorization Application.get_env(:artist_discovery, :spotify_authorization)

  def authorize do
    with {:ok, _pid} <- Cacher.start_link do
      case Cacher.get_creds() do
        {:ok, creds} -> creds
        _cache_miss -> fetch_and_cache_creds()
      end
    else {:error, error} -> {:error, error}
    end
  end

  defp fetch_and_cache_creds do
    with {:ok, creds} <- @spotify_authorization.fetch_access_token(),
         :ok <- Cacher.put_creds(creds) do
      {:ok, creds}
    else {:error, error} ->
      {:error, error}
    end
  end
end
