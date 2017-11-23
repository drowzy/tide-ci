defmodule Tide.Job.Supervisor do
  @moduledoc """
  Supervises the individual jobs aswell as starting them dyncamically
  """
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [worker(Tide.Job.Worker, [], restart: :transient)]

    supervise(children, strategy: :simple_one_for_one)
  end

  def start_job(id, name, opts) do
    Supervisor.start_child(__MODULE__, [id, Keyword.merge(opts, name: name)])
  end

  def get_children, do: Supervisor.which_children(__MODULE__)

  def find_child(name) do
    get_children()
    |> Enum.find(fn {%{name: process_name}, _, _, _} ->
         name == process_name
       end)
  end
end
