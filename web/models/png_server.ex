defmodule Shrekanography.PngServer do
  @shrek_paths Path.wildcard("priv/shreks/*.png")
  @pngs (for shrek_path <- @shrek_paths do
    {:ok, png} = Imagineer.load(shrek_path)
    shrek_filename = Path.basename(shrek_path)

    {shrek_filename, png}
  end |> Map.new)


  def fetch_png(""), do: fetch_random_png()
  def fetch_png(nil), do: fetch_random_png()

  def fetch_png(shrek_filename) do
    {shrek_filename, @pngs[shrek_filename]}
  end

  def fetch_random_png do
    random_key = Map.keys(@pngs) |> Enum.random
    {random_key, @pngs[random_key]}
  end
end
