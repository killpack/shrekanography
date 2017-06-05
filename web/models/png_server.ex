defmodule Shrekanography.PngServer do

  def start_link do
    shrek_paths = Path.wildcard("priv/shreks/*.png")

    pngs = for shrek_path <- shrek_paths do
      {:ok, png} = Imagineer.load(shrek_path)
      shrek_filename = Path.basename(shrek_path)

      {shrek_filename, png}
    end |> Map.new

    Agent.start_link(fn -> pngs end, name: __MODULE__)
  end

  def fetch_png(shrek_filename) do
    Agent.get(__MODULE__, fn pngs -> pngs[shrek_filename] end)
  end

  def list_pngs do
    Agent.get(__MODULE__, fn pngs -> Map.keys(pngs) end)
  end

  def fetch_random_png do
    Agent.get(__MODULE__, fn pngs ->
      random_key = Map.keys(pngs) |> Enum.random
      pngs[random_key]
    end)
  end
end
