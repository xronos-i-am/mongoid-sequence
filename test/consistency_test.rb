require "test_helper"

class SequenceTest < BaseTest
  def test_single_sequence_consistency
    n = 200

    n.times do
      FirstSequencedModel.create
    end

    assert_equal FirstSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end

  def test_existing_value_not_overidden
    model = FirstSequencedModel.new
    model.set_sequence
    value = model.auto_increment
    model.save
    assert_equal value, model.auto_increment
  end

  def test_dup_should_create_new_seuence_value
    model = FirstSequencedModel.create
    copy = model.dup
    copy.save
    assert_not_equal model.auto_increment, copy.auto_increment
  end

  def test_double_sequence_consistency
    n = 100

    n.times do
      FirstSequencedModel.create
      SecondSequencedModel.create
    end

    assert_equal FirstSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
    assert_equal SecondSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end

  def test_prefix_sequence_consistency
    n = 100
    n.times do
      PrefixSequencedModel.create(tenant_id: n)
    end

    assert_equal PrefixSequencedModel.only(:auto_increment).map(&:auto_increment).sort, (1..n).to_a
  end
end
