require 'test_helper'

describe UrlSanitizer do
  let(:valid_example_url) { 'http://example.com' }

  it "must respond_to ::url" do
    UrlSanitizer.new(valid_example_url).must_respond_to(:url)
  end

  it "must return url string" do
    UrlSanitizer.new(valid_example_url).url.must_be_kind_of(String)
  end

  it "must respond_to ::valid?" do
    UrlSanitizer.new(valid_example_url).must_respond_to(:valid?)
  end

  it "must respond_to ::fix_url" do
    UrlSanitizer.new(valid_example_url).must_respond_to(:fix_url)
  end

  it "must raise Argument error on nil" do
    proc{UrlSanitizer.new(nil)}.must_raise(ArgumentError)
  end

  it "must raise Argument error on blank" do
    proc{UrlSanitizer.new("")}.must_raise(ArgumentError)
    proc{UrlSanitizer.new(" ")}.must_raise(ArgumentError)
  end

  it "must remove leading whitespaces" do
    UrlSanitizer.new(' example.com').url.must_equal(valid_example_url)
    UrlSanitizer.new(' http://example.com').url.must_equal(valid_example_url)
  end

  it "must remove trailing whitespaces" do
    UrlSanitizer.new('example.com ').url.must_equal(valid_example_url)
    UrlSanitizer.new('http://example.com ').url.must_equal(valid_example_url)
  end

  it "must remove trailing slashes" do
    UrlSanitizer.new('http://example.com/').url.must_equal(valid_example_url)
    UrlSanitizer.new('http://example.com////').url.must_equal(valid_example_url)
  end

  it "must remove trailing backslashes" do
    UrlSanitizer.new('http://example.com\\\\').url.must_equal(valid_example_url)
  end

  it "must add protocol/scheme" do
    UrlSanitizer.new('example.com/').url.must_equal(valid_example_url)
  end

end