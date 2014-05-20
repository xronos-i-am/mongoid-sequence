require "test_helper"

class SubclassTest < BaseTest
  def test_subclass_sequence
    n = 200

    n.times do
      SubclassSequenceModel.create
    end

    assert_equal SubclassSequenceModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end

  def test_subclass_sequence_increment_when_base_does
    n = 200

    n.times do |i|
      FirstSequencedModel.create
      m1 = SubclassSequenceModel.create

      assert_equal i*2 + 2, m1.auto_increment
    end
  end

  def test_mixed_sequence_uniqueness
    n = 100
    n.times do
      FirstSequencedModel.create
      SubclassSequenceModel.create
    end

    assert_equal FirstSequencedModel.only(:auto_increment).uniq.size, n * 2
  end

  def test_mixed_sequence_consistency
    n = 100

    n.times do
      FirstSequencedModel.create
      SubclassSequenceModel.create
    end

    assert_equal FirstSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n*2).to_a
  end
end

