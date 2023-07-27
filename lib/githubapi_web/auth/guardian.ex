defmodule GithubapiWeb.Auth.Guardian do
  use Guardian, otp_app: :githubapi
  alias Githubapi.User
  alias Githubapi.Users.Get, as: UserGet

  def subject_for_token(%User{id: id}, _claims) do
    {:ok, id}
  end

  def resource_from_claims(%{"sub" => id}) do
    UserGet.by_id(id)
  end
end
