defmodule TimeTracking.FastbillHttpTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
  end

  test "create client" do
    use_cassette "create_client" do
      {:ok, client} = TimeTracking.Fastbill.Http.create_client(%{id: "18606629", name: "Shaidy & Co", at: "2016-04-27T22:17:01+00:00"})
      assert client.id == "2163649"
      assert client.name == "Shaidy & Co"
    end
  end

  test "find existing client by id" do
    use_cassette "find_existing_client" do
      {:ok, client} = TimeTracking.Fastbill.Http.find_client(%{id: "18606629"})
      assert client.id == "2163649"
      assert client.name == "Shaidy & Co"
    end
  end

  test "don't find non-existing client by id" do
    use_cassette "find_non_existing_client" do
      {:not_found, empty} = TimeTracking.Fastbill.Http.find_client(%{id: "18606630"})
      assert empty == %{}
    end
  end
end
