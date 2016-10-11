# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :app_search,
  ecto_repos: [AppSearch.Repo]

# Configures the endpoint
config :app_search, AppSearch.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R1yyWt9JOe5ieDfK2hkkp3hve4iCQBNyiRDIC1EOZ+FW7efm9oXPKQ72wVwsDDMU",
  render_errors: [view: AppSearch.ErrorView, accepts: ~w(html json)],
  pubsub: [name: AppSearch.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# This line was automatically added by ansible-elixir-stack setup script
if System.get_env("SERVER") do
  config :phoenix, :serve_endpoints, true
end
