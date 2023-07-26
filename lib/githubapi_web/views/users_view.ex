defmodule GithubapiWeb.UsersView do
  use GithubapiWeb, :view
  alias Githubapi.User

  def render("create.json", %{user: %User{} = user}) do
    %{
      message: "User created!",
      user: user
    }
  end
end
