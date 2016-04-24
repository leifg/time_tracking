defmodule TimeTracking.Fastbill.Http do
  use HTTPoison.Base

  @endpoint "https://my.fastbill.com/api/1.0/api.php"
  @customer_type "business"
  @headers %{"Accept" => "application/json"}
  @auth [basic_auth: {System.get_env("FASTBILL_EMAIL"), System.get_env("FASTBILL_TOKEN")}]

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
        %{id: Poison.decode!(body)["RESPONSE"]["CUSTOMER_ID"] }
      {:error, %HTTPoison.Error{reason: reason}} ->
        %{status: "error", message: reason}
    end
  end
end
