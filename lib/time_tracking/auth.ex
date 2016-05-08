defmodule AuthHandler do
  @user Application.get_env(:time_tracking, :fastbill_email)
  @password Application.get_env(:time_tracking, :fastbill_token)

  def is_authorized(@user, @password), do: :authorized
  def is_authorized(_user, _password), do: :unauthorized
end
