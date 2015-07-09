defmodule Book do
  require BibleParser
  import BibleParser

  defstruct name: nil, chapters: []

  def parse_all([], books), do: books
  def parse_all([{:xmlText, _, _, _, _, _} | nodes], books), do: parse_all(nodes, books)
  def parse_all([node | nodes], books \\ []) when elem(node, 0) == :xmlElement and elem(node, 1) == :book do
    parse_all(nodes, books ++ [parse(node)])
  end

  defp parse(book_node) do
    [{:xmlAttribute, :name, _, _, _, _, _, _, name, _}] = xmlElement(book_node, :attributes)
    %Book{name: List.to_string(name)}
  end


end
