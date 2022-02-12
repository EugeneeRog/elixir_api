defmodule Cars.Car do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "cars" do
    field :brand_id, :string
    field :brand, :string
    field :model, :string
    field :year, :integer
    field :body_type, :string
    field :is_electric, :boolean

    timestamps()
  end

  @doc false
  def changeset(car, attrs) do
    car
    |> cast(attrs, [:model])
    |> validate_required([:model])
  end

  def add_cars(%{
    "brand_id" => brand,
    "model" => model,
    "year" => year,
    "body_type" => body,
    "is_electric" => is_electric})
    do
    res = Cars.Repo.insert!(%Cars.Car{
      brand_id: UUID.string_to_binary!(brand),
      model: model,
      year: year,
      body_type: body,
      is_electric: is_electric
    })
      Map.delete(Map.delete(res, :__struct__), :__meta__)
  end
  def add_cars(params) when is_map(params)do
    validate_add_car_params(params)
  end
  def add_cars(params) do
  {:error, params, :map_reqaired}
  end

  def validate_add_car_params(params) when is_map(params)do
    {:error, params }
  end

  def get_cars(%{
    "brand" => brand,
    "body_type" => body_type,
    "is_electric" => is_electric
  }) do
    is_electric_val = convert!(is_electric)
    query =
      Ecto.Query.from cars in "cars",
                      join: brands in "brands",
                      on: brands.id == cars.brand_id,
                      where:
                        brands.name == ^brand and
                        cars.body_type == ^body_type and
                        cars.is_electric == ^is_electric_val,
                      select: %{brand: brands.name, model: cars.model,
                        year: cars.year, body_type: cars.body_type,
                        is_electric: cars.is_electric}
    Cars.Repo.all(query)
#    Cars.Repo.get(Cars, %Cars.Car{
#      brand_id: brand_id,
#      body_type: body,
#      is_electric: is_electric
#    })
    end
  def get_cars(%{
    "brand" => brand,
    "body_type" => body_type
  }) do
    query =
      Ecto.Query.from cars in "cars",
                      join: brands in "brands",
                      on: brands.id == cars.brand_id,
                      where:
                        brands.name == ^brand and
                        cars.body_type == ^body_type,
                      select: %{brand: brands.name, model: cars.model,
                        year: cars.year, body_type: cars.body_type,
                        is_electric: cars.is_electric}
    Cars.Repo.all(query)
    end
  def get_cars(params) when is_map(params) do
    validate_get_car_params(params)
  end
  def get_cars(params) do
    {:error, params, :map_reqaired}
  end

  def validate_get_car_params(params) when is_map(params)do
    {:error, params }
  end

  def convert!("true"), do: true
  def convert!("false"), do: false
  def convert!(_), do: {:error, :not_boolean}

end