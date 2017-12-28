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

  describe 'searching' do
    let(:piece) { JustCheckers::Piece.new(player_number: 1, king: false) }
    let(:square) { JustCheckers::Square.new(id: 1, x: 0, y: 0, piece: piece) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [square]) }

    it 'by player number must return the matching squares' do
      assert_instance_of(JustCheckers::Square, square_set.where(piece: { player_number: piece.player_number }).first)
    end

    it 'by x and y must return the matching square' do
      assert_instance_of(JustCheckers::Square, square_set.find_by_x_and_y(0, 0))
    end
  end

  describe 'one square away from' do
    let(:square) { JustCheckers::Square.new(id: 1, x: 0, y: 0) }
    let(:one_square_away_from) { JustCheckers::Square.new(id: 2, x: 1, y: 1) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [square, one_square_away_from]) }

    it 'must return all squares one square away from the square' do
      assert(square_set.one_square_away_from(square).include?(one_square_away_from))
    end

    it 'must not return other squares' do
      refute(square_set.one_square_away_from(square).include?(square))
    end
  end

  describe 'two squares away from' do
    let(:square) { JustCheckers::Square.new(id: 1, x: 0, y: 0) }
    let(:two_squares_away_from) { JustCheckers::Square.new(id: 1, x: 2, y: 2) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [square, two_squares_away_from]) }

    it 'must return all squares one square away from the square' do
      assert(square_set.two_squares_away_from(square).include?(two_squares_away_from))
    end

    it 'must not return other squares' do
      refute(square_set.two_squares_away_from(square).include?(square))
    end
  end

  describe 'in direction of' do
    let(:piece) { JustCheckers::Piece.new(player_number: 1, king: false) }
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

  describe 'unoccupied' do
    let(:piece) { JustCheckers::Piece.new(player_number: 1, king: false) }
    let(:occupied) { JustCheckers::Square.new(id: 1, x: 0, y: 0, piece: piece) }
    let(:unoccupied) { JustCheckers::Square.new(id: 2, x: 1, y: 1) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [unoccupied, occupied]) }

    it 'must return squares without pieces' do
      assert(square_set.unoccupied.include?(unoccupied))
    end

    it 'must not return squares with pieces' do
      refute(square_set.unoccupied.include?(occupied))
    end
  end

  describe 'between' do
    let(:from) { JustCheckers::Square.new(id: 1, x: 0, y: 0) }
    let(:to) { JustCheckers::Square.new(id: 2, x: 2, y: 2) }
    let(:between) { JustCheckers::Square.new(id: 3, x: 1, y: 1) }
    let(:outside) { JustCheckers::Square.new(id: 4, x: 4, y: 4) }
    let(:square_set) { JustCheckers::SquareSet.new(squares: [from, to, between, outside]) }

    it 'must return squares between from and to' do
      assert(square_set.between(from, to).include?(between))
    end

    it 'must not return squares outside of from and to' do
      refute(square_set.between(from, to).include?(outside))
    end
  end

  describe 'occupied by opponent of' do
    let(:player_number) { 1 }
    let(:opponent_square) { JustCheckers::Square.new(id: 1, x: 1, y: 1, piece: {player_number: 2}) }
    let(:own_square) { JustCheckers::Square.new(id: 2, x: 2, y: 2, piece: {player_number: player_number}) }
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
