# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :time_tracking, TimeTracking.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "EEWzzLxm6nHH+2S23bWXBwVWMnOO2jPpqeSD8iyTLWL82BVpF5w2pXOoPG6+inlX",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: TimeTracking.PubSub,
           adapter: Phoenix.PubSub.PG2],
  fastbill_email: System.get_env("FASTBILL_EMAIL"),
  fastbill_token: System.get_env("FASTBILL_TOKEN")

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
