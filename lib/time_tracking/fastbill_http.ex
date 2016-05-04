defmodule TimeTracking.Fastbill.Http do
  use HTTPoison.Base
  @behaviour TimeTracking.Fastbill

  @endpoint "https://my.fastbill.com/api/1.0/api.php"
  @customer_type "business"
  @headers %{"Accept" => "application/json"}
  @fastbill_email Application.get_env(:time_tracking, :fastbill_email)
  @fastbill_token Application.get_env(:time_tracking, :fastbill_token)
  @auth [basic_auth: {@fastbill_email, @fastbill_token}]

  def create_client(%{name: name, id:  id, at: _at}) do
    HTTPoison.start
    body = %{
      SERVICE: "customer.create",
      DATA: %{
        CUSTOMER_NUMBER: "toggl:#{id}",
        CUSTOMER_TYPE: @customer_type,
        ORGANIZATION: name
      }
    }
    process_res = fn(res) -> {:ok, %{id: to_string(res["RESPONSE"]["CUSTOMER_ID"]), name: name }} end
    http_call(@endpoint, body, @headers, @auth, process_res)
  end

  def find_client(%{id: id}) do
    HTTPoison.start
    body = %{
      SERVICE: "customer.get",
      FILTER: %{
        CUSTOMER_NUMBER: "toggl:#{id}",
      }
    }
    process_res = fn(res) ->
      case res["RESPONSE"]["CUSTOMERS"] do
        [] ->
          {:not_found, %{}}
        clients ->
          first_client = List.first(clients)
          {:ok, %{id: first_client["CUSTOMER_ID"], name: first_client["ORGANIZATION"]}}
      end
    end
    http_call(@endpoint, body, @headers, @auth, process_res)
  end

  def create_project(%{client_id: client_id, name: name, at: _at}) do
    HTTPoison.start
    body = %{
      SERVICE: "project.create",
      DATA: %{
        PROJECT_NAME: name,
        CUSTOMER_ID: client_id
      }
    }
    process_res = fn(res) -> {:ok, %{id: to_string(res["RESPONSE"]["PROJECT_ID"]), name: name }} end
    http_call(@endpoint, body, @headers, @auth, process_res)
  end

  def find_project(%{client_id: client_id, id: id}) do
    HTTPoison.start
    body = %{
      SERVICE: "project.get",
      FILTER: %{
        CUSTOMER_ID: client_id,
      }
    }
    process_res = fn(res) ->
      case Enum.find(res["RESPONSE"]["PROJECTS"], fn(elem) -> elem["PROJECT_NUMBER"] == "toggl:#{id}"; end) do
        nil ->
          {:not_found, %{}}
        project ->
          {:ok, %{id: project["PROJECT_ID"], name: project["PROJECT_NAME"]}}
      end
    end
    http_call(@endpoint, body, @headers, @auth, process_res)
  end

  defp http_call(endpoint, request_body, headers, auth, process_fun) do
    case HTTPoison.post(endpoint, Poison.encode!(request_body), headers, [hackney: auth]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_fun.(Poison.decode!(body))
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, %{message: "unauthorized"}}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{message: reason}}
    end
  end
end
