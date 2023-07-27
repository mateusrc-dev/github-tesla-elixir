defmodule GithubapiWeb.UsersController do
  use GithubapiWeb, :controller
  alias Githubapi.User
  alias GithubapiWeb.Auth.Guardian
  alias GithubapiWeb.FallbackController

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Githubapi.create_user(params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    else
      error -> error
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, %User{} = user} <- Githubapi.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("user.json", user: user)
    end
  end

  def sign_in(conn, params) do
    with {:ok, token} <- Guardian.authenticate(params) do
      conn
      |> put_status(:ok)
      |> render("sign_in.json", token: token)
    end
  end
end
