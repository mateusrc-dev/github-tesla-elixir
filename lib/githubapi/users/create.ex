defmodule Githubapi.Users.Create do
  alias Githubapi.{User, Repo}

  def call(params) do
    params
    |> User.changeset()
    |> Repo.insert()
    |> handle_insert()
  end

  defp handle_insert({:ok, %User{} = result}) do
    {:ok, result}
  end

  defp handle_insert({:error, result}) do
    {:error, %{status: :bad_request, result: result}}
  end
end
