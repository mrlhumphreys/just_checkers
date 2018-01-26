require 'minitest/spec'
require 'minitest/autorun'
require 'just_checkers/square_set'

describe JustCheckers::SquareSet do
  describe 'initialize' do
    describe 'with squares' do
      let(:square_set) { JustCheckers::SquareSet.new(squares: [JustCheckers::Square.new(id: 1, x: 0, y: 0, piece: nil)]) }

      it 'must initialize squares' do
        assert_instance_of(JustCheckers::Square, square_set.squares.first)
      end
    end

    describe 'with hash' do
      let(:square_set) { JustCheckers::SquareSet.new(squares: [{id: 1, x: 0, y: 0, piece: nil}]) }

      it 'must initialize squares' do
        assert_instance_of(JustCheckers::Square, square_set.squares.first)
      end
    end
  end

  describe 'in direction of' do
    let(:piece) { JustCheckers::Piece.new(id: 1, player_number: 1, king: false) }
    let(:square) { JustCheckers::Square.new(id: 1, x: 4, y: 4, piece: piece) }
    let(:in_direction) { JustCheckers::Square.new(id: 2, x: 5, y: 5) }
    let(:not_in_direction) { JustCheckers::Square.new(id: 3, x: 3, y: 3) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [square, in_direction, not_in_direction]) }

    it 'must return all squares in the direction of the piece' do
      assert(square_set.in_direction_of(piece, square).include?(in_direction))
    end

    it 'must not return squares not in direction of the piece' do
      refute(square_set.in_direction_of(piece, square).include?(not_in_direction))
    end
  end

  describe 'occupied by opponent of' do
    let(:player_number) { 1 }
    let(:opponent_square) { JustCheckers::Square.new(id: 1, x: 1, y: 1, piece: {id: 1, player_number: 2}) }
    let(:own_square) { JustCheckers::Square.new(id: 2, x: 2, y: 2, piece: {id: 2, player_number: player_number}) }
    let(:empty_square) { JustCheckers::Square.new(id: 3, x: 3, y: 3) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [opponent_square, own_square, empty_square]) }

    it 'must return opponent squares' do
      assert(square_set.occupied_by_opponent_of(player_number).include?(opponent_square))
    end

    it 'must not return empty squares' do
      refute(square_set.occupied_by_opponent_of(player_number).include?(empty_square))
    end

    it 'must not return own squares' do
      refute(square_set.occupied_by_opponent_of(player_number).include?(own_square))
    end
  end
end
