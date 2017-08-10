use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :time_tracking, TimeTrackingWeb.Endpoint,
  secret_key_base: "${SECRET_KEY_BASE}"

config :time_tracking,
  fastbill_email: "${FASTBILL_EMAIL}",
  fastbill_token: "${FASTBILL_TOKEN}",
  fastbill_timezone: "${FASTBILL_TIMEZONE}"
