defmodule TimezoneConverter do
  def convert(datetime_string) do
    {:ok, datetime} = Timex.parse(datetime_string, "{ISO:Extended}")
    {:ok, converted_string} = Timex.Timezone.convert(datetime, timezone()) |> Timex.format("{ISO:Extended}")
    converted_string
  end

  defp timezone do
    Application.get_env(:time_tracking, :fastbill_timezone)
  end
end
