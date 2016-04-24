defmodule TimeTracking.Fastbill.Http do
  use HTTPoison.Base

  @endpoint "https://my.fastbill.com/api/1.0/api.php"
  @customer_type "business"
  @headers %{"Accept" => "application/json"}
  @fastbill_email Application.get_env(:time_tracking, :fastbill_email)
  @fastbill_token Application.get_env(:time_tracking, :fastbill_token)
  @auth [basic_auth: {@fastbill_email, @fastbill_token}]

  def create(%{name: name, id:  id, at: _at}) do
    HTTPoison.start
    body = %{
      SERVICE: "customer.create",
      DATA: %{
        CUSTOMER_NUMBER: id,
        CUSTOMER_TYPE: @customer_type,
        ORGANIZATION: name
      }
    }
    case HTTPoison.post(@endpoint, Poison.encode!(body), @headers, [hackney: @auth]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{status: "created", id: Poison.decode!(body)["RESPONSE"]["CUSTOMER_ID"] }
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        %{id: -1, status: "unauthorized"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{id: -1, status: "error", message: reason}
    end
  end
end
