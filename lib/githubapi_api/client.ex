defmodule Githubapi.GithubapiApi.Client do
  use Tesla

  alias Tesla.Env

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/users/"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Headers, [{"user-agent", "Tesla"}]

  def get_user_repos(user) do
    "#{user}/repos"
    |> get()
    |> handle_get()
  end

  defp handle_get({:ok, %Env{body: %{"message" => message}, status: 404}}) do
    {:error, %{status: :bad_request, result: message}}
  end

  defp handle_get({:ok, %Env{body: body, status: 200}}) do
    {:ok, body}
  end
end
