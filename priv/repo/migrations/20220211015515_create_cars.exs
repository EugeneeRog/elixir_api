defmodule Cars.Repo.Migrations.CreateCars do
  use Ecto.Migration

  def change do
    create table(:cars, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :brand_id, references(:brands, type: :uuid)
      add :model, :varchar
      add :year, :bigint
      add :body_type, :varchar
      add :is_electric, :bool


      timestamps()
    end
  end
end
