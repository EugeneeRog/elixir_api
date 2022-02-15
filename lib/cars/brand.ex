defmodule Cars.Brand do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @moduledoc false

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "brands" do
    field :name, :string
    timestamps()
  end

  @doc false
  def changeset(brand, attrs) do
    brand
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(
         :name,
         name: :index_for_brands_name
       )
  end

  def add_brand(%{
    "name" => name})
    do
    res = Cars.Repo.insert!(%Cars.Brand{
      name: name
    })
    refill_brand_ets()
    Map.delete(Map.delete(res, :__struct__), :__meta__)
  end

  def get_all_brand_ids() do
    query =
      Ecto.Query.from brands in "brands", select: brands.id
    Enum.map(Cars.Repo.all(query), fn(element) -> UUID.binary_to_string!(element) end)
  end

  def refill_brand_ets() do
    :ets.delete(:brands, "brand_ids")
    fill_brand_ets()
  end

  def fill_brand_ets() do
    :ets.insert(:brands, [{"brand_ids", get_all_brand_ids()}])
  end

end
