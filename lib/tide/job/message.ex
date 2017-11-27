defmodule Tide.Job.Message do
  @moduledoc """
  """

  @success_pattern ~w(successfull, success)
  @doc """
  """
  def stringify(message) when is_list(message) do
    message
    |> Enum.map(&stringify/1)
    |> Enum.reverse()
  end

  def stringify(%{"aux" => message}) do
    message
    |> Map.keys()
    |> Enum.zip(Map.values(message))
    |> Enum.map(fn {k, v} -> "#{k} : #{v}" end)
    |> Enum.join("")
  end

  def stringify(message) do
    message
    |> Map.values()
    |> Enum.join("")
  end

  @doc """
  """
  def success?(messages) when is_list(messages) do
    Enum.any?(
      messages,
      &(&1
        |> stringify()
        |> String.downcase()
        |> String.contains?(@success_pattern))
    )
  end
end
