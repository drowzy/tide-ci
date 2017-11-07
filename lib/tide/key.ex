defmodule Tide.Key do
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, opts)
  end

  def init(opts) do
    dir = Keyword.get(opts, :dir, "/tmp/tide/keys")
    :ok = File.mkdir_p!(dir)

    {:ok, %{
        dir: dir
     }}
  end

  @doc """
  """
  def add(pid, name, key), do: GenServer.call(pid, {:add_key, name, key})

  @doc """
  """
  def retrieve(pid, name), do: GenServer.call(pid, {:retrieve_key, name})

  @doc """
  """
  def remove(pid, name), do: GenServer.call(pid, {:remove_key, name})

  @doc """
  """
  def key_dir(pid), do: GenServer.call(pid, :get_key_dir)

  def handle_call({:add_key, name, key}, _from, %{dir: dir} = state) do
    path = Path.join(dir, name)

    res = if File.exists?(path) do
      {:error, :key_exists}
    else
      res = case File.write(path, key) do
        :ok -> :ok
        reason -> {:error, reason}
      end
    end

    {:reply, res, state}
  end

  def handle_call({:retrieve_key, name}, _from, %{dir: dir} = state) do
    {:reply, File.read(Path.join(dir, name)), state}
  end

  def handle_call({:remove_key, name}, _from, %{dir: dir} = state) do
    {:reply, File.rm(Path.join(dir, name)), state}
  end

  def handle_call(:get_key_dir, _from, %{dir: dir} = state) do
    {:reply, dir, state}
  end

end
