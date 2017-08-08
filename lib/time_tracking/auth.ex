defmodule AuthHandler do
  def is_authorized?(user, password) do
    if user == configured_user() && password == configured_password() do
      :authorized
    else
      :unauthorized
    end
  end

  defp configured_user, do: Application.get_env(:time_tracking, :fastbill_email)
  defp configured_password, do: Application.get_env(:time_tracking, :fastbill_token)
end
