defmodule BibleParser.Parser do
  require Record
  require Logger

  Record.defrecord :xmlAttribute, Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")

  @data Keyword.new

  def parse(xml) do
    {doc, _} = xml |> :binary.bin_to_list |> :xmerl_scan.string
    elements = :xmerl_xpath.string('//chapter', doc)

    nodes = Enum.map(elements, fn(elem) ->
      represent(xmlElement(elem, :content))
    end)

    nodes
  end

  def represent(node) when Record.is_record(node, :xmlElement) do
    name = xmlElement(node, :name)
    attribute = xmlElement(node, :attributes)
    content = xmlElement(node, :content)
    parents = xmlElement(node, :parents)

    # Keyword.merge(@data, Keyword.put(Keyword.new, name, [content: represent(content)]))

    @data ++ [name: name, text: represent(content)]
  end

  def represent(node) when Record.is_record(node, :xmlText) do
    string_content = xmlText(node, :value) |> to_string
  end

  def represent(node) when is_list(node) do
    case Enum.map(node, &(represent(&1))) do
      [text_content] when is_binary(text_content) ->
        text_content

      elements ->
        Enum.reduce(elements, [], fn(x, acc) ->
          if is_list(x) do
            Keyword.merge(acc, x)
          else
            acc
          end
        end)
    end
  end
end
