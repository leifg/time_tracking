defmodule TimeTracking.FastbillHttpTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
  end

  test "create client" do
    use_cassette "create_client" do
      {:ok, client} = TimeTracking.Fastbill.Http.create_client(%{external_id: "toggl:18606629", name: "Shaidy & Co", at: "2016-04-27T22:17:01+00:00"})
      assert client.id == "2163649"
      assert client.name == "Shaidy & Co"
      assert client.external_id == "toggl:18606629"
    end
  end

  test "find existing client by external id" do
    use_cassette "find_existing_client" do
      {:ok, client} = TimeTracking.Fastbill.Http.find_client(%{external_id: "toggl:18606629"})
      assert client.id == "2163649"
      assert client.name == "Shaidy & Co"
      assert client.external_id == "toggl:18606629"
    end
  end

  test "don't find non-existing client by external id" do
    use_cassette "find_non_existing_client" do
      {:not_found, empty} = TimeTracking.Fastbill.Http.find_client(%{external_id: "toggl:18606630"})
      assert empty == %{}
    end
  end

  test "create project" do
    use_cassette "create_project" do
      {:ok, project} = TimeTracking.Fastbill.Http.create_project(%{client_id: "2185334", external_id: "toggl:18606629", name: "Hide the Money", at: "2016-04-27T22:17:01+00:00"})
      assert project.id == "104248"
      assert project.name == "Hide the Money"
      assert project.external_id == "toggl:18606629"
    end
  end

  test "find existing project by external id" do
    use_cassette "find_existing_project" do
      {:ok, project} = TimeTracking.Fastbill.Http.find_project(%{client_id: "2185334", external_id: "toggl:15935830"})
      assert project.id == "104236"
      assert project.name == "Hide the Money"
      assert project.external_id == "toggl:15935830"
    end
  end

  test "don't find non-existing project by id" do
    use_cassette "find_non_existing_project" do
      {:not_found, empty} = TimeTracking.Fastbill.Http.find_client(%{client_id: "2185334", external_id: "toggl:159358229"})
      assert empty == %{}
    end
  end

  test "create time slot" do
    use_cassette "create_time_slot" do
      {:ok, time_slot} = TimeTracking.Fastbill.Http.create_time_slot(%{client_id: "2185334", project_id: "104350", date: "2016-05-07T09:17:53+00:00", start_time: "2016-05-07T09:17:53+00:00", end_time: "2016-05-07T17:39:11+00:00", minutes: 501, billable_minutes: 501, comment: "client test"})
      assert time_slot.id == "415012"
      assert time_slot.start_time == "2016-05-07T09:17:53+00:00"
      assert time_slot.end_time == "2016-05-07T17:39:11+00:00"
    end
  end
end
