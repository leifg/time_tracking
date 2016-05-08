use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :time_tracking, TimeTracking.Endpoint,
  http: [port: 4001],
  server: false

config :time_tracking, :fastbill_api, TimeTracking.Fastbill.InMemory

# Print only warnings and errors during test
config :logger, level: :warn

config :time_tracking,
  fastbill_email: "test@example.com",
  fastbill_token: "SECRET-TEST-TOKEN",
  fastbill_timezone: "Europe/Berlin"
