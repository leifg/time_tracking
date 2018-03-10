defmodule BillableCalculator do
  def calculate(time, true), do: time
  def calculate(_time, false), do: 0
end
