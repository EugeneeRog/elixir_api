defmodule WhsAppWeb.ApiStorageView do
  use WhsAppWeb, :view
  def render("add_cars.json", %{res: :ok}) do
    %{
      res: ok
    }
  end
end