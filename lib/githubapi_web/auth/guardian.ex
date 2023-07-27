defmodule GithubapiWeb.Auth.Guardian do
  use Guardian, otp_app: :githubapi
  alias Githubapi.User
  alias Githubapi.Users.Get, as: UserGet

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def authenticate(%{"id" => user_id, "password" => password}) do
    with {:ok, %User{password_hash: hash} = user} <- UserGet.by_id(user_id),
         true <- Pbkdf2.verify_pass(password, hash),
         {:ok, token, _claims} <-
           encode_and_sign(user, %{some: "claim"},
             token_type: "refresh",
             ttl: {1, :minutes}
           ) do
      {:ok, token}
    else
      false -> {:error, status: :unauthorized, result: "Please, verify your credentials"}
      error -> error
    end
  end

  def resource_from_claims(%{"sub" => id}) do
    UserGet.by_id(id)
  end
end
