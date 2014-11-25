require "test_helper"

class UniquenessTest < BaseTest
  def test_single_sequence_uniqueness
    n = 200

    n.times do
      FirstSequencedModel.create
    end

    assert_equal FirstSequencedModel.all.uniq.size, n
  end

  def test_double_sequence_uniqueness
    n = 100

    n.times do
      FirstSequencedModel.create
      SecondSequencedModel.create
    end

    assert_equal FirstSequencedModel.all.uniq.size, n
    assert_equal SecondSequencedModel.all.uniq.size, n
  end
end
