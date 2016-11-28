require 'test_helper'

class MyModel
  include Bigqueryid::Base

  field :integer, type: Integer
  field :time,    type: Time
  field :hash,    type: Hash
  field :chash,   type: Hash[String => Integer]
  field :array,   type: Array
  field :carray,  type: Array[Hash[String => String]]
  field :string,  type: String
  field :without
end

describe 'Bigqueryid::Attributes' do
  before do
    @subject = MyModel.new(
      integer: '1234',
      time: '2016-01-01',
      hash: { 'key' => '1' },
      chash: { 'key' => '1' },
      array: %w(a b c),
      carray: [{ a: :b}, { c: :d }],
      string: 1234,
      without: 1
    )
  end

  describe 'coercions' do
    it 'type as integer' do
      @subject.integer.must_equal 1234
    end

    it 'type as time' do
      @subject.time.must_equal Time.parse('2016-01-01')
    end

    it 'type as hash' do
      @subject.hash.must_equal 'key' => '1'
    end

    it 'type as composite hash' do
      @subject.chash.must_equal 'key' => 1
    end

    it 'type as array' do
      @subject.array.must_equal %w(a b c)
    end

    it 'type as composite array' do
      @subject.carray.must_equal [{ 'a' => 'b' }, { 'c' => 'd' }]
    end

    it 'type as string' do
      @subject.string.must_equal '1234'
    end

    it 'without type' do
      @subject.without.must_equal 1
    end
  end
end
