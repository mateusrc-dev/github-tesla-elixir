defmodule GithubapiWeb.UsersController do
  use GithubapiWeb, :controller
  alias Githubapi.User
  alias GithubapiWeb.Auth.Guardian
  alias GithubapiWeb.FallbackController
  alias Plug.Conn

  action_fallback FallbackController

  def create(conn, params) do
    with {:ok, %User{} = user} <- Githubapi.create_user(params),
         {:ok, token, _claims} <-
           Guardian.encode_and_sign(user, %{some: "claim"},
             token_type: "refresh",
             ttl: {1, :minutes}
           ) do
      conn
      |> put_status(:created)
      |> render("create.json", token: token, user: user)
    else
      error -> error
    end
  end

  def show(conn, %{"id" => id}) do
    token = Conn.get_req_header(conn, "authorization")
    token_without_list = List.to_string(token)
    token_with_replace = String.replace_leading(token_without_list, "Bearer ", "")

    {:ok, {old_token, _old_claims}, {new_token, _new_claims}} =
      Guardian.refresh(token_with_replace)

    IO.inspect(old_token)
    IO.inspect(new_token)

    with {:ok, %User{} = user} <- Githubapi.get_user_by_id(id) do
      conn
      |> put_status(:ok)
      |> put_resp_header("authorization", "Bearer #{new_token}")
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
