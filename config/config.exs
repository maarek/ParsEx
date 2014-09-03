# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :parsex, :parse_base,
  parse_url: "https://api.parse.com/1/"

import_config "#{Mix.env}.exs"
