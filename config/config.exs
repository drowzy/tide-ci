# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :tide_ci, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:tide_ci, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :tide_ci,
  socket_dir: "/tmp/tide/sockets",
  repo_dir: "/tmp/tide/repositories"

config :tide_ci, TideWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TlroZNtpLsEV0IVdcc4CA043zbsuvMOeFMLhnDVCUGIMUfSxpdMu9cYtbV5mDF3c",
  render_errors: [view: TideWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Tide.PubSub, adapter: Phoenix.PubSub.PG2]

config :tide_ci, ecto_repos: [Tide.Repo]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).

import_config "#{Mix.env()}.exs"
