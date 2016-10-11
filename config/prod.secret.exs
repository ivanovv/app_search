use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :app_search, AppSearch.Endpoint,
  secret_key_base: "CmfokQ+3u/GJkHGV+NTnIEgd8WkSJiDBvbmcYULCg7mXo642nYw1S/EtlfT3x79w"

# Configure your database
config :app_search, AppSearch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "app_search_prod",
  pool_size: 20
