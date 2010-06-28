require "helper"

class LunarMacrosTest < Test::Unit::TestCase
  setup do
    Ohm.flush
  end

  class Post < Ohm::Model
    include Ohm::LunarMacros
  end

  test "fuzzy / text / number / sortable" do
    Post.fuzzy :name
    assert_equal [:name], Post.fuzzy

    Post.text :name
    assert_equal [:name], Post.text

    Post.number :name
    assert_equal [:name], Post.number

    Post.sortable :name
    assert_equal [:name], Post.sortable
  end

  test "fuzzy / text / number / sortable done twice" do
    Post.fuzzy :name
    Post.fuzzy :name
    assert_equal [:name], Post.fuzzy

    Post.text :name
    Post.text :name
    assert_equal [:name], Post.text

    Post.number :name
    Post.number :name
    assert_equal [:name], Post.number

    Post.sortable :name
    Post.sortable :name
    assert_equal [:name], Post.sortable
  end
  
  context "on create" do
    class Document < Ohm::Model
      include Ohm::LunarMacros
      
      fuzzy    :filename
      text     :content
      number   :author_id
      sortable :views

      def filename()  "Filename" end
      def content()   "Content"  end
      def author_id() 100        end
      def views()     15         end
    end
  
    test "indexes filename" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).with(Document).yields(doc)

      doc.expects(:id).with('1')
      doc.expects(:fuzzy).with(:filename, 'Filename')
      doc = Document.create
    end

    test "indexes content" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).with(Document).yields(doc)

      doc.expects(:id).with('1')
      doc.expects(:text).with(:content, 'Content')
      doc = Document.create
    end

    test "indexes number" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).with(Document).yields(doc)

      doc.expects(:id).with('1')
      doc.expects(:number).with(:author_id, 100)
      doc = Document.create
    end

    test "indexes sortable" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).with(Document).yields(doc)

      doc.expects(:id).with('1')
      doc.expects(:sortable).with(:views, 15)
      doc = Document.create
    end
  end

  context "on update" do
    class Document < Ohm::Model
      include Ohm::LunarMacros
      
      fuzzy    :filename
      text     :content
      number   :author_id
      sortable :views

      def filename()  "Filename" end
      def content()   "Content"  end
      def author_id() 100        end
      def views()     15         end
    end
  
    test "indexes filename" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).times(2).with(Document).yields(doc)

      doc.expects(:id).times(2).with('1')
      doc.expects(:fuzzy).times(2).with(:filename, 'Filename')
      doc = Document.create
      doc.save
    end

    test "indexes content" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).times(2).with(Document).yields(doc)

      doc.expects(:id).times(2).with('1')
      doc.expects(:text).times(2).with(:content, 'Content')
      doc = Document.create
      doc.save
    end

    test "indexes number" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).times(2).with(Document).yields(doc)

      doc.expects(:id).times(2).with('1')
      doc.expects(:number).times(2).with(:author_id, 100)
      doc = Document.create
      doc.save
    end

    test "indexes sortable" do
      doc = stub("Doc", fuzzy: nil, text: nil, number: nil, sortable: nil)
      Lunar.expects(:index).times(2).with(Document).yields(doc)

      doc.expects(:id).times(2).with('1')
      doc.expects(:sortable).times(2).with(:views, 15)
      doc = Document.create
      doc.save
    end
  end

  context "on delete" do
    test "executes Lunar.delete" do
      doc = stub("Doc", id: nil, fuzzy: nil, text: nil, number: nil, 
                        sortable: nil)

      Lunar.expects(:index).with(Document).yields(doc)

      doc = Document.create

      Lunar.expects(:delete).with(Document, '1')
      doc.delete
    end
  end
end
