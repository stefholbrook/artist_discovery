defmodule ArtistDiscovery.Spotify.Cacher do
    @doc "The [`Agent`](https://hexdocs.pm/elixir/Agent.html) is started with an empty `Credentials` struct"
  def start_link do
    Agent.start_link(fn -> %Spotify.Credentials{} end, name: CredStore)
  end

  def get_creds, do: Agent.get(CredStore, &(&1))

  def put_creds(creds), do: Agent.update(CredStore, fn(_) -> creds end)

  # @doc "Used to link the user to Spotify to kick off the auth process"
  # def auth_url, do: Spotify.Authorization.url

  # @doc "`params` are passed to your callback endpoint from Spotify"
  # def authenticate(params) do
  #   creds = get_creds()
  #   {:ok, new_creds} = Spotify.Authentication.authenticate(creds, params)
  #   put_creds(new_creds) # make sure to persist the credentials for later!
  # end
end
