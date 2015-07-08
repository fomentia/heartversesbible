defmodule BibleParserTest do
  use ExUnit.Case

  def example_xml do
    """
    <bible>
      <book name="Gen">
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
      [ book: "Genesis", chapter: 1, verse: 1, text: "In the beginning God created the heaven and the earth." ],
      [ book: "Genesis", chapter: 1, verse: 2, text: "And the earth was without form, and void; and darkness was upon the face of the deep. And the Spirit of God moved upon the face of the waters." ],
      [ book: "Genesis", chapter: 2, verse: 1, text: "In the beginning God created the heaven and the earth." ],
      [ book: "Genesis", chapter: 2, verse: 2, text: "In the beginning God created the heaven and the earth." ],
    ]
  end

  test "BibleParser.Parser.parse/1 idealizes XML" do
    xtracted_data = BibleParser.Parser.parse(example_xml)
    assert xtracted_data == verses_table()
  end
end
