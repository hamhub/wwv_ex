# WwvEx

Provides a simple way to fetch the `wwv.txt` solar report from the NOAA.

This library performs the fetching of the solar report from the NOAA and
parses it into a map for use in your application. The raw report is also
maintained if you want to see the human readable version.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wwv_ex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wwv_ex, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
wwv_data = WwvEx.fetch()
```

The `wwv_data` result should look similar to this:

```elixir
{:ok,
 %{
   ai: "8",
   index_dt: "11 July",
   issued_dt: "2019 Jul 12 1210 UTC",
   ki: "2",
   ki_dt: "1200 UTC on 12 July",
   raw_report: "...",
   sfi: "67"
 }}
 ```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/wwv_ex](https://hexdocs.pm/wwv_ex).

