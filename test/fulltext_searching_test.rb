# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Video < Ohm::Model
  include Ohm::FulltextSearching

  attribute :title
  attribute :description
   
  fulltext :title
  fulltext :description
end

test "finding basic words using metaphones" do
  v = Video.create(:title => "The quick brown fox jumps over the lazy dog")

  assert Video.find(:fulltext_title => "KK").include?(v)
  assert Video.find(:fulltext_title => "PRN").include?(v)
  assert Video.find(:fulltext_title => "FKS").include?(v)
  assert Video.find(:fulltext_title => "JMPS").include?(v)
  assert Video.find(:fulltext_title => "AMPS").include?(v)
  assert Video.find(:fulltext_title => ["JMPS", "AMPS"]).include?(v)
  assert Video.find(:fulltext_title => "LS").include?(v)
  assert Video.find(:fulltext_title => "TK").include?(v)
end

test "finding using the actual words" do
  v = Video.create(:title => "The quick brown fox jumps over the lazy dog")
  
  assert Video.search(:title => "quick").include?(v)
  assert Video.search(:title => "brown").include?(v)
  assert Video.search(:title => "fox").include?(v)
  assert Video.search(:title => "jumps").include?(v)
  assert Video.search(:title => "lazy").include?(v)
  assert Video.search(:title => "dog").include?(v)
end

test "finding using slightly mispelled words" do
  v = Video.create(:title => "The quick brown fox jumps over the lazy dog")

  assert Video.search(:title => "quik").include?(v)
  assert Video.search(:title => "brwn").include?(v)
  assert Video.search(:title => "fx").include?(v)
  assert Video.search(:title => "fax").include?(v)
  assert Video.search(:title => "jumps").include?(v)
  assert Video.search(:title => "lazi").include?(v)
  assert Video.search(:title => "dag").include?(v)
end

test "stopword stripping" do
  # This is the actual code that strips out stopwords.

  assert_equal [], Video.double_metaphone("about")
  
  # Here we just verify that actually on a long string level,
  # stop words are in fact stripped.
  assert Video.metaphones(Video::STOPWORDS.join(" ")).empty?

  # Finally we need to make sure that finding stop words
  # should not even proceed.
  assert Video.hash_to_metaphones(:title => "about").empty?
end
