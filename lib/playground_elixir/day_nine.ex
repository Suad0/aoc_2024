defmodule PlaygroundElixir.DayNine do
  def read_input(file) do
    file
    |> File.read!()
    |> String.trim()
  end

  def solve(input, part2 \\ false) do
    {files, spaces, final_placement, _, _} =
      String.graphemes(input)
      |> Enum.chunk_every(2, 2, :discard)
      |> Enum.reduce({[], [], [], 0, 0}, fn [file_size, space_size],
                                            {files, spaces, final, file_id, pos} ->
        file_size = String.to_integer(file_size)
        space_size = String.to_integer(space_size)

        files =
          if part2 do
            files ++ [{pos, file_size, file_id}]
          else
            files ++ Enum.map(1..file_size, fn _ -> {pos, 1, file_id} end)
          end

        final =
          final ++ Enum.map(1..file_size, fn _ -> file_id end)

        spaces = spaces ++ [{pos + file_size, space_size}]

        final =
          final ++ Enum.map(1..space_size, fn _ -> nil end)

        {files, spaces, final, file_id + 1, pos + file_size + space_size}
      end)

    files =
      Enum.reverse(files)

    final_placement =
      Enum.reduce(files, final_placement, fn {pos, sz, file_id}, final ->
        Enum.find_index(spaces, fn {space_pos, space_sz} ->
          space_pos >= pos and sz <= space_sz
        end)
        |> case do
          nil ->
            final

          space_index ->
            {space_pos, space_sz} = Enum.at(spaces, space_index)

            if Enum.slice(final, pos, sz) |> Enum.all?(&is_nil/1) do
              final =
                final
                |> replace_slice(pos, sz, List.duplicate(nil, sz))
                |> replace_slice(space_pos, sz, List.duplicate(file_id, sz))

              spaces = List.replace_at(spaces, space_index, {space_pos + sz, space_sz - sz})
              final
            else
              final
            end
        end
      end)

    Enum.reduce(final_placement, {0, 0}, fn
      nil, {sum, index} -> {sum, index + 1}
      file, {sum, index} -> {sum + index * file, index + 1}
    end)
    |> elem(0)
  end

  defp replace_slice(list, start, len, replacement) do
    list
    |> Enum.with_index()
    |> Enum.map(fn
      {_, idx} when idx >= start and idx < start + len -> Enum.at(replacement, idx - start)
      {el, _} -> el
    end)
  end
end
