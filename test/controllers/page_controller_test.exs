defmodule TimeTracking.PageControllerTest do
  use TimeTracking.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert json_response(conn, 200) == %{"message" => "This is an API"}
  end
end
