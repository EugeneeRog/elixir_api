defmodule CarsWeb.CarsController do
  use CarsWeb, :controller

  @moduledoc false

  def get_cars(conn, params) do
    res = Cars.Car.get_cars(params)
    case res do
      {:error, msg} -> json(put_status(conn, 422), msg)
      car -> json(put_status(conn, 200), car)
    end
  end
  def add_cars(conn, params) do
    res = Cars.Car.add_cars(params)
    case res do
      {:request_error, msg} -> json(put_status(conn, 422), msg)
      {:error, msg} -> json(put_status(conn, 422), msg)
      car -> json(put_status(conn, 200), car)
    end
  end
  def add_brand(conn, params) do
    res = Cars.Brand.add_brand(params)
    case res do
      {:error, msg} -> json(put_status(conn, 422), msg)
      brand -> json(put_status(conn, 200), brand)
    end
  end
end
