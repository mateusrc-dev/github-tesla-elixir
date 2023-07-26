defmodule GithubapiWeb.UsersController do
  use GithubapiWeb, :controller
  alias Githubapi.User
  alias GithubapiWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Githubapi.create_user(params) do
      conn
      |> put_status(:created)
      |> render("create.json", user: user)
    end
  end
end
