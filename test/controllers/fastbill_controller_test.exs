defmodule TimeTracking.FastbillControllerTest do
  use TimeTracking.ConnCase

  @valid_attrs %{"name": "Shaidy & Co", "id": "1426720", "at": "2016-04-20T10:23:33+00:00"}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, "/clients", @valid_attrs
    response = json_response(conn, 200)
    assert response["status"] == "created"
    assert response["id"] == "1"
  end
end
