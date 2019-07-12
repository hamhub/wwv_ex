defmodule WwvEx do
  @moduledoc """
  Provides a simple way to fetch the `wwv.txt` solar report from the NOAA.

  This library performs the fetching of the solar report from the NOAA and
  parses it into a map for use in your application. The raw report is also
  maintained if you want to see the human readable version.
  """
  @issued_match ~r/:Issued: (.+)/
  @index_match ~r/Solar-terrestrial indices for (.+) follow./
  @sf_match ~r/Solar flux (\d+) and estimated planetary A-index (\d+)./
  @ki_match ~r/The estimated planetary K-index at (.+) was (\d+)./

  @typedoc "WWV Solar Report data structure"
  @type wwv_data() :: %{
          sfi: String.t(),
          ai: String.t(),
          ki: String.t(),
          ki_dt: String.t(),
          issued_dt: String.t(),
          index_dt: String.t(),
          raw_report: String.t()
        }

  @doc """
  Fetches the WWV solar report from the NOAA and parses it.
  """
  @spec fetch() :: {:ok, wwv_data()} | {:error, :server_error}
  def fetch() do
    case Tesla.get(client(), "/wwv.txt") do
      {:ok, %{body: body}} ->
        wwv_data =
          body
          |> String.split("\n")
          |> Enum.reduce(%{}, &parse_wwv_line/2)
          |> Map.put(:raw_report, body)

        {:ok, wwv_data}

      _ ->
        {:error, :server_error}
    end
  end

  defp parse_wwv_line(line, data) do
    cond do
      String.match?(line, @issued_match) ->
        [_, issued_dt] = Regex.run(@issued_match, line)
        Map.put(data, :issued_dt, issued_dt)

      String.match?(line, @index_match) ->
        [_, index_dt] = Regex.run(@index_match, line)
        Map.put(data, :index_dt, index_dt)

      String.match?(line, @sf_match) ->
        [_, sfi, ai] = Regex.run(@sf_match, line)

        data
        |> Map.put(:sfi, sfi)
        |> Map.put(:ai, ai)

      String.match?(line, @ki_match) ->
        [_, ki_dt, ki] = Regex.run(@ki_match, line)

        data
        |> Map.put(:ki, ki)
        |> Map.put(:ki_dt, ki_dt)

      true ->
        data
    end
  end

  defp client(),
    do: Tesla.client([{Tesla.Middleware.BaseUrl, "https://services.swpc.noaa.gov/text"}])
end
