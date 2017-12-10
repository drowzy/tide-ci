defmodule Tide.Hosts.ProcessStarter do
  use Task
  alias Tide.Schemas.Host
  @user "ubuntu"

  def start_link() do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
    hosts = Host.list_active()

    Enum.map(hosts, &connect/1)
    :ok
  end

  defp connect(%Host{hostname: hostname}) do
    {:ok, pid} = Tide.Hosts.connect(hostname, @user)
  end
end
