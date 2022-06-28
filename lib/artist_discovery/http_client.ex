defmodule ArtistDiscovery.HttpClient do
  use HTTPoison.Base

  @decoder &Jason.decode/1

  defguard ok?(status_code) when status_code in 200..204

  def post(url, body, headers \\ [], opts \\ []) do
    HTTPoison.post(
      url,
      body,
      headers,
      opts
    )
    |> handle_response()
  end

  def handle_response(resp, decoder \\ @decoder)

  def handle_response({:error, struct}, _decoder), do: {:error, struct}

  def handle_response(
    {:ok, %HTTPoison.Response{body: body, headers: headers, status_code: code}},
    decoder)
    when ok?(code) do
      case Enum.into(headers, %{})["content-type"] do
        "application/json" -> decoder.(body)
        _ -> {:ok, body}
      end
  end

  def handle_response({:ok, struct}, _decoder), do: {:error, struct}
end
