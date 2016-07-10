defmodule BillableCalculator do

  def calculate(time, true), do: time
  def calculate(time, false), do: 0
end
