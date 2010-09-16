# encoding: UTF-8

require File.expand_path("./helper", File.dirname(__FILE__))

class Post < Ohm::Model
  include Ohm::LunarMacros
end

test "fuzzy / text / number / sortable" do
  Post.fuzzy :name
  assert [:name] == Post.fuzzy

  Post.text :name
  assert [:name] == Post.text

  Post.number :name
  assert [:name] == Post.number

  Post.sortable :name
  assert [:name] == Post.sortable
end

test "fuzzy / text / number / sortable done twice" do
  Post.fuzzy :name
  Post.fuzzy :name
  assert [:name] == Post.fuzzy

  Post.text :name
  Post.text :name
  assert [:name] == Post.text

  Post.number :name
  Post.number :name
  assert [:name] == Post.number

  Post.sortable :name
  Post.sortable :name
  assert [:name] == Post.sortable
end

class Document < Ohm::Model
  include Ohm::LunarMacros

  fuzzy    :filename
  text     :content
  number   :author_id
  sortable :views

  attribute :filename
  attribute :content
  attribute :author_id
  attribute :views
end

test "fuzzy indexing" do
  doc = Document.create(:filename => "amazing.mp3")

  strs = %w{a am ama amaz amazi amazin amazing amazing. amazing.m
            amazing.mp amazing.mp3}

  strs.each do |str|
    r = Lunar.search(Document, :fuzzy => { :filename => str })
    assert r.include?(doc)
  end

  doc.update(:filename => "crazy.mp3")

  strs = %w{c cr cra craz crazy crazy. crazy.m crazy.mp crazy.mp3}

  strs.each do |str|
    r = Lunar.search(Document, :fuzzy => { :filename => str })
    assert r.include?(doc)
  end
end

test "text indexing" do
  doc = Document.create(:content => "The quick brown fox")

  queries = ['quick', 'brown', 'fox', 'quick brown' 'quick fox', 'fox brown',
             'the quick brown fox']

  queries.each do |q|
    r = Lunar.search(Document, :q => q)
    assert r.include?(doc)
  end

  doc.update(:content => "lazy dog jumps over")

  queries = ['lazy', 'dog', 'jumps', 'over', 'lazy dog', 'jumps over']

  queries.each do |q|
    r = Lunar.search(Document, :q => q)
    assert r.include?(doc)
  end
end

test "number indexing" do
  doc = Document.create(:author_id => 99)

  [99..100, 98..99, 98..100].each do |range|
    r = Lunar.search(Document, :author_id => range)
    assert r.include?(doc)
  end

  [97..98, 100..101].each do |range|
    r = Lunar.search(Document, :author_id => range)
    assert ! r.include?(doc)
  end

  doc.update(:author_id => 49)

  [49..50, 48..49, 48..50].each do |range|
    r = Lunar.search(Document, :author_id => range)
    assert r.include?(doc)
  end

  [47..48, 50..51].each do |range|
    r = Lunar.search(Document, :author_id => range)
    assert ! r.include?(doc)
  end
end

test "sortable indexing" do
  osx    = Document.create(:content => "apple mac osx", :views => 500)
  iphone = Document.create(:content => "apple iphone",  :views => 10_000)

  assert [iphone, osx] == Lunar.search(Document, :q => "apple").sort_by(:views, :order => "DESC")
  assert [osx, iphone] == Lunar.search(Document, :q => "apple").sort_by(:views, :order => "ASC")

  osx.update(:content => "ios mac osx", :views => 1000)
  iphone.update(:content => "ios iphone", :views => 500)

  assert [osx, iphone] == Lunar.search(Document, :q => "ios").sort_by(:views, :order => "DESC")
  assert [iphone, osx] == Lunar.search(Document, :q => "ios").sort_by(:views, :order => "ASC")
end

test "on delete" do
  doc = Document.create(:filename => "amazing.mp3", :content => "apple mac osx",
                        :author_id => 99, :views => 500)

  doc.delete

  assert Lunar.search(Document, :q => "apple").size.zero?
  assert Lunar.search(Document, :fuzzy => { :filename => "amazing" }).size.zero?
end

