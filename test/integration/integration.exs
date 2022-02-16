defmodule IntegrationTest do
  use ExUnit.Case
  alias Cars.Test.Utils

  setup_all do
    Cars.Support.Helpersq.launch_api
  end

  test "POST /add_brand" do
    response = APICall.post!("/add_brand", %{"brand": "test_tesla"})
    assert response.status_code == 200
  end

  test "add_car" do
    request = %{"brand1": "test_tesla"}
    response = APICall.post!("/add_brand", request)
    assert response.status_code == 422
#    assert response.body == expected_response
  end
end

defmodule Cars.Test.Utils do
  use Poison

  def process_url(url) do
    api_url <> url
  end

  def process_response_body(body) do
    try do
      Poison.decode!(body, keys: :atoms!)
    rescue
      _ -> body
    end
  end

  def process_request_body(body) do
    Poison.encode!(body)
  end

  def process_request_headers(headers) do
    [{'content-type', 'application/json'} | headers]
  end


  defp api_url do
    endpoint_config = Application.get_env(:calculon, Cars.Endpoint)
    host = Keyword.get(endpoint_config, :url) |> Keyword.get(:host)
    port = Keyword.get(endpoint_config, :http) |> Keyword.get(:port)

    "http://#{host}:#{port}/api/v1"
  end
end