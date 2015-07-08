defmodule BibleParser.Parser do
  require Record
  require Logger

  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @data Keyword.new

  def parse(xml) do
    {doc, _} = xml |> :binary.bin_to_list |> :xmerl_scan.string

    :xmerl_xpath.string('//book', doc) |> Enum.reduce([], fn(book_node, acc) ->
      book_attributes = get_attributes_for(book_node)
      :xmerl_xpath.string('//chapter', book_node) |> Enum.reduce(acc, fn(chapter_node, acc) ->
        chapter_attributes = get_attributes_for(chapter_node)
        :xmerl_xpath.string('//verse', chapter_node) |> Enum.reduce(acc, fn(verse_node, acc) ->
          verse_attributes = get_attributes_for(verse_node)
          raw_verse_text = xmlElement(verse_node, :content)
          verse_text = represent_text(List.first(raw_verse_text)) |> List.to_string

          acc ++ [[book: List.to_string(book_attributes[:name]),
                   chapter: List.to_integer(chapter_attributes[:num]),
                   verse: List.to_integer(verse_attributes[:num]),
                   text: verse_text]]
        end)
      end)
    end)
  end

  def get_attributes_for(node) do
    raw_attributes = xmlElement(node, :attributes)
    attributes = Enum.reduce(raw_attributes, %{}, fn(attr, acc) ->
      represent_attr(attr, acc)
    end)
  end

  def represent_attr({:xmlAttribute, key, _, _, _, _, _, _, value, _}, map) do
    Map.put(map, key, value)
  end

  def represent_text({:xmlText, _, _, _, text, _}) do
    text
  end
end
