defmodule Githubapi.Repo do
  use Ecto.Repo,
    otp_app: :githubapi,
    adapter: Ecto.Adapters.Postgres
end
