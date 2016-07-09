defmodule TimeTracking.TimezoneConverterTest do
  use ExUnit.Case, async: false

  describe "#convert" do
    test "correctly converts timezone in DST" do
      assert TimezoneConverter.convert("2016-05-08T20:00:56.506+00:00", "Europe/Berlin") == "2016-05-08T22:00:56.506+02:00"
    end

    test "correctly converts timezone outside of DST" do
      assert TimezoneConverter.convert("2016-01-08T20:00:56.506+00:00", "Europe/Berlin") == "2016-01-08T21:00:56.506+01:00"
    end
  end
end
