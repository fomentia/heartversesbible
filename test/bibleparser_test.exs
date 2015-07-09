defmodule BibleParserTest do
  use Amrita.Sweet

  @example_xml  """
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
      <book name="Exo">
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

  def verses_table do
    %Bible{
      version: "kjv",
      books: [
        %Book{name: "Genesis", chapters: [
            %Chapter{number: 1, verses: [
                %Verse{number: 1, text: "In the beginning God created the heavens and the earth."} #...
            ]} # ...add remaining nodes
        ]}
      ]
    }
  end

  test "should parse the bible" do
    Bible.parse("kjv", @example_xml)
      |> matches %Bible{version: "kjv"}
  end

  @tag timeout: 10000000
  test "should parse books" do
    [ genesis | _ ] = Bible.parse(nil, @example_xml).books
    genesis |> equals %Book{name: "Gen"}
  end

end
