defmodule CarsWeb.CarsController do
  use CarsWeb, :controller

  def get_cars(conn, params) do
    res = Cars.Car.get_cars(params)
    case res do
      :ok = car -> render(conn, "get_cars.json", car: car)

      msg -> render(conn, "error.json", msg: msg)
    end
  end
  def add_cars(conn, params) do
    res = Cars.Car.add_cars(params)
    case res do
      :ok = car -> render(conn, "add_cars.json", car: car);

      msg -> render(conn, "error.json", msg: msg)
    end
  end
end
