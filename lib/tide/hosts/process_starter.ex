defmodule Tide.Hosts.ProcessStarter do
  use Task
  alias Tide.Schemas.Host
  @user "ubuntu"

  def start_link() do
    Task.start_link(__MODULE__, :run, [])
  end

  def run do
    hosts = Tide.Schemas.Host.list_active()

    Enum.map(hosts, &connect/1)
  end

  defp connect(%Host{hostname: hostname}) do
    Tide.Hosts.connect(hostname, @user)
  end
end
