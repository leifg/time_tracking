defmodule TimeTracking.BillableCalculatorTest do
  use ExUnit.Case, async: false

  describe "#calculate" do
    test "correctly calculates billable time" do
      assert BillableCalculator.calculate(501, true) == 501
    end

    test "correctly calculates non-billable time" do
      assert BillableCalculator.calculate(501, false) == 0
    end
  end
end
