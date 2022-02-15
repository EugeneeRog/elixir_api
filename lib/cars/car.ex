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
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:brand_id, :model, :year, :body_type, :is_electric])
    |> validate_required([:brand_id, :model, :year, :body_type, :is_electric])
    |> validate_car_year()
    |> validate_car_brand_id()
    |> validate_car_body_type()
  end

  def validate_car_year(changeset) do
    year = get_field(changeset, :year)
    if year > 1886 and year <= DateTime.utc_now |> Map.fetch!(:year) do
      changeset
    else
      error = "year should be from 1886 to current year"
      add_error(changeset, :year, generate_error("$.year", {[], error}))
    end
  end

  def validate_car_brand_id(changeset) do
    brand_id = get_field(changeset, :brand_id)
    [{"brand_ids", all_brand_ids}] = :ets.lookup(:brands, "brand_ids")
    case Enum.member?(all_brand_ids, brand_id) do
      true -> changeset
      _ ->
        error = "brand_id not exist"
        add_error(changeset, :brand_id, generate_error("$.brand_id", {[], error}))
    end
  end

  def validate_car_body_type(changeset) do
    body_type = get_field(changeset, :body_type)
    enum_list = ["coupe", "sedan", "pickup"]
    case Enum.any?(enum_list, fn(el) -> el === body_type end) do
      true -> changeset
      _ ->
        error = "value is not allowed in enum"
        add_error(changeset, :body_type, generate_error("$.body_type", {enum_list, error}))
    end
  end

  def add_cars(params) when is_map(params)do
    validate_add_car_params(params)
  end
  def add_cars(params) do
  {:error, params, :map_reqaired}
  end

  def validate_add_car_params(params) when is_map(params)do
    validation = changeset(%Cars.Car{}, params)
    case validation do
      %Ecto.Changeset{valid?: true, errors: []} ->
        insert_car_to_db(params)
        %{ok: :added}
      %Ecto.Changeset{valid?: false, errors: list_of_errors} ->
        {:request_error, create_request_error(list_of_errors)}
    end
  end

  def insert_car_to_db(
        %{
          "brand_id" => brand,
          "model" => model,
          "year" => year,
          "body_type" => body,
          "is_electric" => is_electric}
      ) do
    Cars.Repo.insert!(%Cars.Car{
      brand_id: UUID.string_to_binary!(brand),
      model: model,
      year: year,
      body_type: body,
      is_electric: is_electric
    })
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
    %{"data" => Cars.Repo.all(query)}
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
    %{"data" => Cars.Repo.all(query)}
    end
  def get_cars(params) do
    {:error, params, :map_reqaired}
  end

  def convert!("true"), do: true
  def convert!("false"), do: false
  def convert!(_), do: {:error, :not_boolean}

  def create_request_error(errors) do
    fun = fn
      ({name, {"can't be blank", _}}, acc) ->
        [generate_error(name, {[], Atom.to_string(name) <> "can't be blank"}) | acc]
      ({_, {err, _}}, acc) -> [err | acc]
      ([], acc) -> acc
      end
    %{
      "error" => %{
        "invalid" => List.foldl(errors, [], fun)
      }
    }
  end

  def generate_error(name, {values, error}) do
    Poison.encode!(%{
          "entry" => name,
          "entry_type" => "json_data_proprty",
          "rules" => %{
            "description" => error,
            "params" => %{"values" => values},
            "rule" => "inclusion"
          }
        })
  end
end