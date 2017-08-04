use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :time_tracking, TimeTrackingWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :time_tracking,
  fastbill_email: System.get_env("FASTBILL_EMAIL"),
  fastbill_token: System.get_env("FASTBILL_TOKEN"),
  fastbill_timezone: System.get_env("FASTBILL_TIMEZONE")
