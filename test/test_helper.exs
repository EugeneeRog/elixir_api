ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cars.Repo, :manual)

defmodule Cars.Support.Test_helper do
  def launch_api do
    # set up config for serving
    endpoint_config =
      Application.get_env(:cars, CarsWeb.Endpoint)
      |> Keyword.put(:cars, true)
    :ok = Application.put_env(:cars, CarsWeb.Endpoint, endpoint_config)

    # restart our application with serving enabled
    :ok = Application.stop(:cars)
    :ok = Application.start(:cars)
  end
end

#TODO need to resolve error for tests
#test POST /add_car false (IntegrationTest)
#test/integration/integration_test.exs:14
#** (HTTPoison.Error) :econnrefused
#code: response = ApiCall.post!("add_brand", request)
# stacktrace:
#  test/integration/integration_test.exs:22: Cars.Test.ApiCall.request!/5
# test/integration/integration_test.exs:16: (test)