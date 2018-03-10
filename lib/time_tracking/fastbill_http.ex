defmodule TimeTracking.Fastbill.Http do
  use HTTPoison.Base
  @behaviour TimeTracking.Fastbill

  @endpoint "https://my.fastbill.com/api/1.0/api.php"
  @customer_type "business"
  @headers %{"Accept" => "application/json"}

  def create_client(%{name: name, external_id: external_id}) do
    HTTPoison.start()

    body = %{
      SERVICE: "customer.create",
      DATA: %{
        CUSTOMER_NUMBER: external_id,
        CUSTOMER_TYPE: @customer_type,
        ORGANIZATION: name
      }
    }

    process_res = fn res ->
      {:ok,
       %{id: to_string(res["RESPONSE"]["CUSTOMER_ID"]), external_id: external_id, name: name}}
    end

    http_call(@endpoint, body, @headers, auth(), process_res)
  end

  def find_client(%{external_id: external_id}) do
    HTTPoison.start()

    body = %{
      SERVICE: "customer.get",
      FILTER: %{
        CUSTOMER_NUMBER: external_id
      }
    }

    process_res = fn res ->
      case res["RESPONSE"]["CUSTOMERS"] do
        [] ->
          {:not_found, %{}}

        clients ->
          first_client = List.first(clients)

          {:ok,
           %{
             id: first_client["CUSTOMER_ID"],
             external_id: first_client["CUSTOMER_NUMBER"],
             name: first_client["ORGANIZATION"]
           }}
      end
    end

    http_call(@endpoint, body, @headers, auth(), process_res)
  end

  def create_project(%{client_id: client_id, external_id: external_id, name: name}) do
    HTTPoison.start()

    body = %{
      SERVICE: "project.create",
      DATA: %{
        PROJECT_NAME: name,
        PROJECT_NUMBER: external_id,
        CUSTOMER_ID: client_id
      }
    }

    process_res = fn res ->
      {:ok,
       %{
         id: to_string(res["RESPONSE"]["PROJECT_ID"]),
         external_id: external_id,
         name: name,
         client_id: client_id
       }}
    end

    http_call(@endpoint, body, @headers, auth(), process_res)
  end

  def find_project(%{client_id: client_id, external_id: external_id}) do
    HTTPoison.start()

    body = %{
      SERVICE: "project.get",
      FILTER: %{
        CUSTOMER_ID: client_id
      }
    }

    process_res = fn res ->
      case Enum.find(res["RESPONSE"]["PROJECTS"], fn elem ->
             elem["PROJECT_NUMBER"] == external_id
           end) do
        nil ->
          {:not_found, %{}}

        project ->
          {:ok,
           %{
             id: project["PROJECT_ID"],
             external_id: external_id,
             name: project["PROJECT_NAME"],
             client_id: client_id
           }}
      end
    end

    http_call(@endpoint, body, @headers, auth(), process_res)
  end

  def create_time_slot(%{
        client_id: client_id,
        project_id: project_id,
        date: date,
        start_time: start_time,
        end_time: end_time,
        minutes: minutes,
        billable_minutes: billable_minutes,
        comment: comment
      }) do
    HTTPoison.start()

    body = %{
      SERVICE: "time.create",
      DATA: %{
        CUSTOMER_ID: client_id,
        PROJECT_ID: project_id,
        DATE: date,
        START_TIME: start_time,
        END_TIME: end_time,
        MINUTES: minutes,
        BILLABLE_MINUTES: billable_minutes,
        COMMENT: comment
      }
    }

    process_res = fn res ->
      {:ok,
       %{
         id: to_string(res["RESPONSE"]["TIME_ID"]),
         start_time: start_time,
         end_time: end_time,
         minutes: minutes,
         billable_minutes: billable_minutes
       }}
    end

    http_call(@endpoint, body, @headers, auth(), process_res)
  end

  defp http_call(endpoint, request_body, headers, auth, process_fun) do
    case HTTPoison.post(endpoint, Poison.encode!(request_body), headers, hackney: auth) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_fun.(Poison.decode!(body))

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, %{message: "unauthorized"}}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{message: reason}}
    end
  end

  defp auth do
    [basic_auth: {fastbill_email(), fastbill_token()}]
  end

  defp fastbill_email do
    Application.get_env(:time_tracking, :fastbill_email)
  end

  defp fastbill_token do
    Application.get_env(:time_tracking, :fastbill_token)
  end
end
