require 'test_helper'

class Elasticsearch::Persistence::RepositoryNamingTest < Test::Unit::TestCase
  context "The repository naming" do
    # Fake class for the naming tests
    class ::Foobar; end
    class ::FooBar; end
    module ::Foo; class Bar; end; end

    setup do
      @shoulda_subject = Class.new() { include Elasticsearch::Persistence::Repository::Naming }.new
    end

    context "get Ruby class from the Elasticsearch type" do
      should "get a simple class" do
        assert_equal Foobar, subject.__get_klass_from_type('foobar')
      end
      should "get a camelcased class" do
        assert_equal FooBar, subject.__get_klass_from_type('foo_bar')
      end
      should "get a namespaced class" do
        assert_equal Foo::Bar, subject.__get_klass_from_type('foo/bar')
      end
      should "re-raise a NameError exception" do
        assert_raise NameError do
          subject.__get_klass_from_type('foobarbazbam')
        end
      end
    end

    context "get Elasticsearch type from the Ruby class" do
      should "encode a simple class" do
        assert_equal 'foobar', subject.__get_type_from_class(Foobar)
      end
      should "encode a camelcased class" do
        assert_equal 'foo_bar', subject.__get_type_from_class(FooBar)
      end
      should "encode a namespaced class" do
        assert_equal 'foo/bar', subject.__get_type_from_class(Foo::Bar)
      end
    end

    context "get an ID from the document" do
      should "get an ID from Hash" do
        assert_equal 1, subject.__get_id_from_document(id: 1)
        assert_equal 1, subject.__get_id_from_document(_id: 1)
        assert_equal 1, subject.__get_id_from_document('id'  => 1)
        assert_equal 1, subject.__get_id_from_document('_id' => 1)
      end
    end

    context "document class name" do
      should "be nil by default" do
        assert_nil subject.klass
      end

      should "be settable" do
        subject.klass = Foobar
        assert_equal Foobar, subject.klass
      end

      should "be settable by DSL" do
        subject.klass Foobar
        assert_equal Foobar, subject.klass
      end
    end

  end
end