defmodule Cars.Repo do
  use Ecto.Repo,
    otp_app: :cars,
    adapter: Ecto.Adapters.Postgres
end
