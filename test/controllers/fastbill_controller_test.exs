defmodule TimeTracking.FastbillControllerTest do
  use TimeTracking.ConnCase

  @existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_found", "at" => "2016-04-20T10:23:33+00:00"}
  @non_existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_not_found", "at" => "2016-04-20T10:23:33+00:00"}

  @existing_project %{"id" => "toggl_id_found", "cid" => "toggl_id_found", "name" => "Already Existing", "at" => "2016-04-24T17:04:23+00:00"}
  @non_existing_project %{"id" => "toggl_id_not_found", "cid" => "toggl_id_found", "name" => "New Project", "at" => "2016-04-24T17:04:23+00:00"}

  @time_slot %{"description" => "controller test", "start" => "2016-05-08T09:17:53+00:00", "stop" => "2016-05-08T17:39:11+00:00", "duration" => "30078", "project" => @existing_project}

  @user Application.get_env(:time_tracking, :fastbill_email)
  @password Application.get_env(:time_tracking, :fastbill_token)

  setup %{conn: conn} do
    {
      :ok,
      conn:
        put_req_header(conn, "authorization", "Basic " <> Base.encode64("#{@user}:#{@password}"))
        |> put_req_header("accept", "application/json")
      }
  end

  # skip setup by leaving out the options
  test "does not lett unauthoized users pass for creation of client" do
    conn = post(conn, "/clients", @non_existing_client)
    assert conn.state == :sent
    assert conn.status == 401
  end

  test "creates new client when it doesn't exist", %{conn: conn} do
    response = post(conn, "/clients", @non_existing_client) |> json_response(200)
    assert response["name"] == "Shaidy & Co"
    assert response["id"] == "2"
    assert response["external_id"] == "toggl:toggl_id_not_found"
  end

  test "returns existing client when it does exist", %{conn: conn} do
    response = post(conn, "/clients", @existing_client) |> json_response(200)
    assert response["name"] == "found before"
    assert response["id"] == "1"
    assert response["external_id"] == "toggl:toggl_id_found"
  end

  # skip setup by leaving out the options
  test "does not lett unauthoized users pass for creation of project" do
    conn = post(conn, "/projects", @non_existing_project)
    assert conn.state == :sent
    assert conn.status == 401
  end

  test "creates new project when it doesn't exist", %{conn: conn} do
    response = post(conn, "/projects", @non_existing_project) |> json_response(200)
    assert response["name"] == "New Project"
    assert response["id"] == "project_2"
    assert response["external_id"] == "toggl:toggl_id_not_found"
  end

  test "returns existing project when it does exist", %{conn: conn} do
    response = post(conn, "/projects", @existing_project) |> json_response(200)
    assert response["name"] == "Already Existing"
    assert response["id"] == "project_1"
    assert response["external_id"] == "toggl:toggl_id_found"
  end

  # skip setup by leaving out the options
  test "does not lett unauthoized users pass for creation of time slot" do
    conn = post(conn, "/time_slots", @time_slot)
    assert conn.state == :sent
    assert conn.status == 401
  end

  test "creates time slot", %{conn: conn} do
    response = post(conn, "/time_slots", @time_slot) |> json_response(200)
    assert response["id"] == "time_slot_1"
    assert response["comment"] == "controller test"
  end
end
