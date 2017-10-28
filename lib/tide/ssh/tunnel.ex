defmodule Tide.SSH.Tunnel do
  @moduledoc """
  """
  @default_options ~w(n N T)
  defstruct [
    id: nil,
    from: nil,
    to: nil,
    direction: :local,
    cmd: nil,
  ]

  @type t :: %__MODULE__{
    id: String.t(),
    from: String.t(),
    to: String.t(),
    direction: :local | :remote,
    cmd: String.t()
  }

  def new(opts) do
    from = Keyword.get(opts, :from)
    to = Keyword.get(opts, :to)
    direction = Keyword.get(opts, :direction, :local)

    %__MODULE__{
      from: from,
      to: to,
      direction: direction,
      cmd: "-#{Enum.join(@default_options, " ")} #{dir_opt(direction)}#{bind_opt(from, to)}"
    }
  end

  def uri(%__MODULE__{direction: :local, from: from}) do
    case Path.extname(from) do
      ".sock" -> "http+unix://#{URI.encode_www_form(from)}"
      _ -> "http://127.0.0.1:#{from}"
    end
  end

  defp bind_opt(from, to), do: "#{from}:#{to}"
  defp dir_opt(:local), do: "-L"
  defp dir_opt(:remote), do: "-R"
end
