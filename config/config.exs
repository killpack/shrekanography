# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :shrekanography,
  ecto_repos: [Shrekanography.Repo]

# Configures the endpoint
config :shrekanography, Shrekanography.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0SO6vMdUFSF6o0Zvcb70SXYyrjt/yKIS55NMeT981czi3NE2KAnp/VMnvxf52OFT",
  render_errors: [view: Shrekanography.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Shrekanography.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
