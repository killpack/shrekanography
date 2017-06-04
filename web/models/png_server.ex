defmodule Shrekanography.PngServer do
  def start_link(file_path) do
    {:ok, png} = Imagineer.load(file_path)
    Agent.start_link(fn -> png end, name: __MODULE__)
  end

  def fetch_png do
    Agent.get(__MODULE__, fn png -> png end)
  end
end
