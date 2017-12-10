defmodule Tide.Boot do
  use Task

  def start_link(opts \\ []) do
    Task.start_link(__MODULE__, :run, [opts])
  end

  def run(folders) do
    ensure_folders_exist(folders)
    clean(folders)

    :ok
  end

  defp clean(folders) do
    folders
    |> Enum.flat_map(fn folder ->
        folder
        |> File.ls!()
        |> Enum.map(&(Path.join(folder, &1)))
        |> Enum.reject(&File.dir?/1)
      end)
    |> Enum.map(&File.rm!/1)
  end

  defp ensure_folders_exist(folders) do
    Enum.map(folders, &File.mkdir_p!/1)
  end
end
