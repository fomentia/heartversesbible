defmodule Bible do
  require BibleParser

  defstruct version: nil, books: []

  def parse(version, xml) when is_binary(xml) do
    {xml, []} = String.to_char_list(xml) |> :xmerl_scan.string
    nodes = BibleParser.xmlElement(xml, :content) |> parse_content
    %Bible{version: version, books: Book.parse_all nodes}
  end

  defp parse_content([{:xmlText, _, _, _, _, _} | rest]), do: parse_content(rest)
  defp parse_content(nodes), do: nodes
end
