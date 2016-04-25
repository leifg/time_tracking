defmodule TimeTracking.FastbillControllerTest do
  use TimeTracking.ConnCase

  @existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_found", "at" => "2016-04-20T10:23:33+00:00"}
  @non_existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_not_found", "at" => "2016-04-20T10:23:33+00:00"}
  @non_error_client %{"name" => "Shaidy & Co", "id" => "error_id", "at" => "2016-04-20T10:23:33+00:00"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates a new client when it doesn't exist", %{conn: conn} do
    conn = post conn, "/clients", @non_existing_client
    response = json_response(conn, 200)
    assert response["name"] == "Shaidy & Co"
    assert response["id"] == "2"
  end

  test "returns existing client when it does exist", %{conn: conn} do
    conn = post conn, "/clients", @existing_client
    response = json_response(conn, 200)
    assert response["name"] == "found before"
    assert response["id"] == "1"
  end
end
