defmodule GithubapiWeb.Router do
  use GithubapiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GithubapiWeb do
    pipe_through :api

    get "/", WelcomeController, :index

    resources "/users/", UsersController, except: [:new, :edit]

    get "/github/:user", GithubController, :show
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: GithubapiWeb.Telemetry
    end
  end
end
