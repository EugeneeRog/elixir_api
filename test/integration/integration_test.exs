defmodule IntegrationTest do
  use ExUnit.Case
  alias Cars.Test.ApiCall

  setup_all do
    Cars.Support.Test_helper.launch_api
  end

  test "POST /add_brand" do
    response = ApiCall.post!("add_brand", %{"brand" => "test_tesla"})
    assert response.status_code == 200
  end

  test "POST /add_car false" do
    request = %{"brand1" => "test_tesla"}
    response = ApiCall.post!("add_brand", request)
    assert response.status_code == 422
  end
end

defmodule Cars.Test.ApiCall do
  use HTTPoison.Base

  def process_url(url) do
    endpoint_config = Application.get_env(:cars, CarsWeb.Endpoint)
    host = Keyword.get(endpoint_config, :url) |> Keyword.get(:host)
    port = Keyword.get(endpoint_config, :http) |> Keyword.get(:port)

    "http://#{host}:#{port}/" <> url
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
end