ExUnit.start()

Application.ensure_all_started(:bypass)
Ecto.Adapters.SQL.Sandbox.mode(Tide.Repo, :manual)
