require "test_helper"

class SubclassTest < BaseTest
  def test_subclass_sequence
    n = 20

    n.times do
      SubclassSequenceModel.create
    end

    assert_equal SubclassSequenceModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end

  def test_subclass_sequence_increment_when_base_does
    FirstSequencedModel.create
    m1 = SubclassSequenceModel.create

    assert_equal m1.auto_increment, 2
  end
end

