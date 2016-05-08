defmodule TimeTracking.PageControllerTest do
  use TimeTracking.ConnCase

  @correct_user Application.get_env(:time_tracking, :fastbill_email)
  @correct_password Application.get_env(:time_tracking, :fastbill_token)

  @wrong_user "mallory"
  @wrong_password "standard-pass"

  setup %{conn: conn} do
    {
      :ok,
      conn: put_req_header(conn, "accept", "application/json")
      }
  end

  test "GET / (no authorization)", %{conn: conn} do
    conn = get conn, "/"
    assert conn.state == :sent
    assert conn.status == 401
  end

  test "GET / (wrong authorization)", %{conn: conn} do
    conn = put_req_header(conn, "authorization", "Basic " <> Base.encode64("#{@wrong_user}:#{@wrong_password}")) |> get("/")
    assert conn.state == :sent
    assert conn.status == 401
  end

  test "GET / (authorized)", %{conn: conn} do
        conn = put_req_header(conn, "authorization", "Basic " <> Base.encode64("#{@correct_user}:#{@correct_password}")) |> get("/")
    assert conn.state == :sent
    assert conn.status == 200
  end
end
