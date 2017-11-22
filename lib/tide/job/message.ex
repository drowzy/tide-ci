defmodule Tide.Job.Message do
  def stringify(message) when is_list(message) do
    message
    |> Enum.map(&stringify/1)
    |> Enum.reverse
    |> Enum.join("")
  end

  def stringify(%{"aux" => message}) do
    message
    |> Map.keys
    |> Enum.zip(Map.values(message))
    |> Enum.map(fn {k, v} -> "#{k} : #{v}" end)
    |> Enum.join("")
  end

  def stringify(message) do
    message
    |> Map.values
    |> Enum.join("")
  end

end
