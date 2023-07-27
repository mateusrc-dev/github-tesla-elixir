defmodule Githubapi.Users.Get do
  alias Githubapi.{User, Repo}

  def by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, %{status: :bad_request, result: "User not found!"}}
      user -> {:ok, user}
    end
  end
end
