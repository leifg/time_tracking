defmodule TimeTracking.FastbillControllerTest do
  use TimeTrackingWeb.ConnCase

  @existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_found"}
  @non_existing_client %{"name" => "Shaidy & Co", "id" => "toggl_id_not_found"}

  @existing_project %{
    "id" => "toggl_id_found",
    "client" => @existing_client,
    "name" => "Already Existing"
  }
  @non_existing_project %{
    "id" => "toggl_id_not_found",
    "client" => @existing_client,
    "name" => "New Project"
  }

  @billable_time_slot %{
    "description" => "controller test",
    "start" => "2016-05-08T09:17:53+00:00",
    "stop" => "2016-05-08T17:39:11+00:00",
    "duration_minutes" => "501",
    "billable" => "True",
    "project" => @existing_project
  }
  @non_billable_time_slot %{
    "description" => "controller test",
    "start" => "2016-05-08T09:17:53+00:00",
    "stop" => "2016-05-08T17:39:11+00:00",
    "duration_minutes" => "501",
    "billable" => "False",
    "project" => @existing_project
  }

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

  describe "POST /clients" do
    # skip setup by leaving out the options
    test "does not lett unauthoized users pass for creation of client" do
      conn = post(build_conn(), "/clients", @non_existing_client)
      assert conn.state == :sent
      assert conn.status == 401
    end

    test "creates new client when it doesn't exist", %{conn: conn} do
      response = post(conn, "/clients", @non_existing_client) |> json_response(200)
      assert response["name"] == "Shaidy & Co"
      assert response["id"] == "client_2"
      assert response["external_id"] == "toggl:toggl_id_not_found"
    end

    test "returns existing client when it does exist", %{conn: conn} do
      response = post(conn, "/clients", @existing_client) |> json_response(200)
      assert response["name"] == "found before"
      assert response["id"] == "client_1"
      assert response["external_id"] == "toggl:toggl_id_found"
    end
  end

  describe "POST /projects" do
    # skip setup by leaving out the options
    test "does not lett unauthoized users pass for creation of project" do
      conn = post(build_conn(), "/projects", @non_existing_project)
      assert conn.state == :sent
      assert conn.status == 401
    end

    test "creates new project when it doesn't exist", %{conn: conn} do
      response = post(conn, "/projects", @non_existing_project) |> json_response(200)
      assert response["name"] == "New Project"
      assert response["id"] == "project_2"
      assert response["external_id"] == "toggl:toggl_id_not_found"
      assert response["client_id"] == "client_2"
    end

    test "returns existing project when it does exist", %{conn: conn} do
      response = post(conn, "/projects", @existing_project) |> json_response(200)
      assert response["name"] == "Already Existing"
      assert response["id"] == "project_1"
      assert response["external_id"] == "toggl:toggl_id_found"
    end
  end

  describe "POST /time_slots" do
    # skip setup by leaving out the options
    test "does not lett unauthoized users pass for creation of time slot" do
      conn = post(build_conn(), "/time_slots", @billable_time_slot)
      assert conn.state == :sent
      assert conn.status == 401
    end

    test "creates billable time slot", %{conn: conn} do
      response = post(conn, "/time_slots", @billable_time_slot) |> json_response(200)
      assert response["id"] == "time_slot_1"
      assert response["comment"] == "controller test"
      assert response["start_time"] == "2016-05-08T11:17:53+02:00"
      assert response["end_time"] == "2016-05-08T19:39:11+02:00"
      assert response["minutes"] == 501
      assert response["billable_minutes"] == 501
    end

    test "creates non-billable time slot", %{conn: conn} do
      response = post(conn, "/time_slots", @non_billable_time_slot) |> json_response(200)
      assert response["id"] == "time_slot_1"
      assert response["comment"] == "controller test"
      assert response["start_time"] == "2016-05-08T11:17:53+02:00"
      assert response["end_time"] == "2016-05-08T19:39:11+02:00"
      assert response["minutes"] == 501
      assert response["billable_minutes"] == 0
    end
  end
end
