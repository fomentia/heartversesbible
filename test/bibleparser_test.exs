defmodule BibleParserTest do
  use ExUnit.Case

  def example_xml_string do
    """
    <bible>
      <book num="Gen">
        <chapter num="1">
          <verse num="1">In the beginning God created the heaven and the earth.</verse>
          <verse num="2">And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters.</verse>
        </chapter>
        <chapter num="2">
          <verse num="1">Thus the heavens and the earth were finished, and all the host of them.</verse>
          <verse num="2">And on the seventh day God ended his work which he had made; and he rested on the seventh day from all his work which he had made.</verse>
        </chapter>
      </book>
    </bible>
    """
  end

  def verses_table do
    [
      %{ :book => "Gen", :chapter => 1, :verse => 1, :text => "In the beginning God created the heaven and the earth." },
      %{ :book => "Gen", :chapter => 1, :verse => 2, :text => "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters." },
      %{ :book => "Gen", :chapter => 2, :verse => 1, :text => "Thus the heavens and the earth were finished, and all the host of them." },
      %{ :book => "Gen", :chapter => 2, :verse => 2, :text => "And on the seventh day God ended his work which he had made; and he rested on the seventh day from all his work which he had made." },
    ]
  end

  test "BibleParser.KJVParser.parse/1 can parse strings" do
    xtracted_data = BibleParser.KJVParser.parse(example_xml_string)
    assert xtracted_data == verses_table()
  end

  test "BibleParser.KJVParser.parse/1 can parse files" do
    xtracted_data = BibleParser.KJVParser.parse("example_kjv_file.xml", is_file: true)
    assert xtracted_data == verses_table()
  end
end
