require 'minitest/spec'
require 'minitest/autorun'
require 'just_checkers/vector'

describe JustCheckers::Vector do
  describe 'a diagonal vector' do
    let(:point_a) { JustCheckers::Point.new(0, 0) }
    let(:point_b) { JustCheckers::Point.new(1, 1) }

    let(:vector) { JustCheckers::Vector.new(point_a, point_b) }

    it 'must have a magnitude equal to the distance' do
      assert_equal(vector.magnitude, 1)
    end
  end

  describe 'an orthogonal vector' do
    let(:point_a) { JustCheckers::Point.new(0, 0) }
    let(:point_b) { JustCheckers::Point.new(0, 1) }

    let(:vector) { JustCheckers::Vector.new(point_a, point_b) }

    it 'must not have a magnitude' do
      assert_nil(vector.magnitude)
    end
  end

  describe 'a vector moving down' do
    let(:point_a) { JustCheckers::Point.new(0, 0) }
    let(:point_b) { JustCheckers::Point.new(0, 1) }

    let(:vector) { JustCheckers::Vector.new(point_a, point_b) }

    it 'must have a positive y direction' do
      assert_equal(1, vector.direction_y)
    end
  end

  describe 'a vector moving up' do
    let(:point_a) { JustCheckers::Point.new(0, 1) }
    let(:point_b) { JustCheckers::Point.new(0, 0) }

    let(:vector) { JustCheckers::Vector.new(point_a, point_b) }

    it 'must have a negative y direction' do
      assert_equal(-1, vector.direction_y)
    end
  end

  describe 'a vector' do
    let(:point_a) { JustCheckers::Point.new(1, 1) }
    let(:point_b) { JustCheckers::Point.new(0, 0) }

    let(:vector) { JustCheckers::Vector.new(point_a, point_b) }
    let(:direction) { JustCheckers::Direction.new(-1, -1) }

    it 'must have a direction' do
      assert_equal(direction, vector.direction)
    end
  end
end
