defmodule TimezoneConverter do
  @default_timezone Application.get_env(:time_tracking, :fastbill_timezone)

  def convert(datetime_string, timezone \\ @default_timezone) do
    {:ok, datetime} = Timex.parse(datetime_string, "{ISO:Extended}")
    {:ok, converted_string} = Timex.Timezone.convert(datetime, timezone) |> Timex.format("{ISO:Extended}")
    converted_string
  end
end
