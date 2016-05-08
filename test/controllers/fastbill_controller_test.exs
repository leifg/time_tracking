defmodule TimeTracking.FastbillControllerTest do
  use TimeTracking.ConnCase

  @existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_found", "at" => "2016-04-20T10:23:33+00:00"}
  @non_existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_not_found", "at" => "2016-04-20T10:23:33+00:00"}

  @existing_project %{"id" => "toggl_id_found", "cid" => "toggl_id_found", "name" => "Already Existing", "at" => "2016-04-24T17:04:23+00:00"}
  @non_existing_project %{"id" => "toggl_id_not_found", "cid" => "toggl_id_found", "name" => "New Project", "at" => "2016-04-24T17:04:23+00:00"}

  @time_slot %{"description" => "controller test", "start" => "2016-05-08T09:17:53+00:00", "stop" => "2016-05-08T17:39:11+00:00", "duration" => "30078", "project" => @existing_project}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates new client when it doesn't exist", %{conn: conn} do
    conn = post conn, "/clients", @non_existing_client
    response = json_response(conn, 200)
    assert response["name"] == "Shaidy & Co"
    assert response["id"] == "2"
    assert response["external_id"] == "toggl:toggl_id_not_found"
  end

  test "returns existing client when it does exist", %{conn: conn} do
    conn = post conn, "/clients", @existing_client
    response = json_response(conn, 200)
    assert response["name"] == "found before"
    assert response["id"] == "1"
    assert response["external_id"] == "toggl:toggl_id_found"
  end

  test "creates new project when it doesn't exist", %{conn: conn} do
    conn = post conn, "/projects", @non_existing_project
    response = json_response(conn, 200)
    assert response["name"] == "New Project"
    assert response["id"] == "project_2"
    assert response["external_id"] == "toggl:toggl_id_not_found"
  end

  test "returns existing project when it does exist", %{conn: conn} do
    conn = post conn, "/projects", @existing_project
    response = json_response(conn, 200)
    assert response["name"] == "Already Existing"
    assert response["id"] == "project_1"
    assert response["external_id"] == "toggl:toggl_id_found"
  end

  test "creates time slot" do
    conn = post conn, "/time_slots", @time_slot
    response = json_response(conn, 200)
    assert response["id"] == "time_slot_1"
    assert response["comment"] == "controller test"
  end
end
