require 'minitest/spec'
require 'minitest/autorun'
require 'just_checkers/square'

describe JustCheckers::Square do
  describe 'a square initialized' do
    describe 'with a hash piece' do
      let(:square) { JustCheckers::Square.new(x: 0, y: 0, piece: {player_number: 1, direction: -1, king: false}) }

      it 'must have a piece' do
        assert_instance_of JustCheckers::Piece, square.piece
      end
    end

    describe 'with an actual piece' do
      let(:piece) { JustCheckers::Piece.new(player_number: 1, direction: -1, king: false) }
      let(:square) { JustCheckers::Square.new(x: 0, y: 0, piece: piece) }

      it 'must have a piece' do
        assert_instance_of JustCheckers::Piece, square.piece
      end
    end

    describe 'with a piece' do
      let(:square) { JustCheckers::Square.new(x: 0, y: 0, piece: {player_number: 1, direction: -1, king: false}) }

      it 'must not be unoccupied' do
        refute square.unoccupied?
      end
    end

    describe 'without a piece' do
      let(:square) { JustCheckers::Square.new(x: 0, y: 0) }

      it 'must be unoccupied' do
        assert square.unoccupied?
      end
    end

    describe 'attribute_match?' do
      let(:piece) { JustCheckers::Piece.new(player_number: 1, direction: -1, king: false) }
      let(:square) { JustCheckers::Square.new(x: 0, y: 0, piece: piece) }

      it 'must match' do
        assert square.attribute_match?(:piece, {king: false})
      end
    end
  end

  describe 'point' do
    let(:square) { JustCheckers::Square.new(x: 1, y: 1) }
    let(:point) { square.point }

    it 'must be a point' do
      assert_instance_of JustCheckers::Point, point
    end

    it 'must have the same coordinates' do
      assert_equal square.x, point.x
      assert_equal square.y, point.y
    end
  end

  describe 'a blocked square' do
    let(:blocking_square_a) { JustCheckers::Square.new(x: 0, y: 1, piece: {player_number: 2, direction: -1}) }
    let(:blocking_square_b) { JustCheckers::Square.new(x: 2, y: 1, piece: {player_number: 2, direction: -1}) }
    let(:blocked_square) { JustCheckers::Square.new(x: 1, y: 0, piece: {player_number: 1, direction: 1}) }

    let(:square_set) { JustCheckers::SquareSet.new(squares: [blocking_square_a, blocking_square_b, blocked_square]) }

    it 'must not have possible jumps' do
      assert blocked_square.possible_jumps(blocked_square.piece, square_set).empty?
    end

    it 'must not have possible moves' do
      assert blocked_square.possible_moves(blocked_square.piece, square_set).empty?
    end
  end

  describe 'a square with no neighbours' do
    let(:empty_square_a) { JustCheckers::Square.new(x: 0, y: 1) }
    let(:empty_square_b) { JustCheckers::Square.new(x: 2, y: 1) }
    let(:empty_square_c) { JustCheckers::Square.new(x: 3, y: 2) }
    let(:alone_square) { JustCheckers::Square.new(x: 1, y: 0, piece: {player_number: 1, direction: 1}) }

    let(:square_set) { JustCheckers::SquareSet.new(squares: [alone_square, empty_square_a, empty_square_b, empty_square_c]) }

    it 'must not have possible jumps' do
      assert alone_square.possible_jumps(alone_square.piece, square_set).empty?
    end

    it 'must have possible moves' do
      assert alone_square.possible_moves(alone_square.piece, square_set).any?
    end
  end

  describe 'a square with an enemy neighbour with an empty square beyond' do
    let(:jumping_square) { JustCheckers::Square.new(x: 1, y: 0, piece: {player_number: 1, direction: 1}) }
    let(:enemy_neighbour) { JustCheckers::Square.new(x: 2, y: 1, piece: {player_number: 2, direction: -1}) }
    let(:empty_square) { JustCheckers::Square.new(x: 3, y: 2) }

    let(:square_set) { JustCheckers::SquareSet.new(squares: [jumping_square, empty_square, enemy_neighbour]) }

    it 'must have possible jumps' do
      assert jumping_square.possible_jumps(jumping_square.piece, square_set).any?
    end

    it 'must not have possible moves' do
      assert jumping_square.possible_moves(jumping_square.piece, square_set).empty?
    end
  end

  describe 'a king piece with no blocks behind' do
    let(:empty_square_a) { JustCheckers::Square.new(x: 1, y: 0) }
    let(:empty_square_b) { JustCheckers::Square.new(x: 4, y: 1) }
    let(:enemy_neighbour) { JustCheckers::Square.new(x: 2, y: 1, piece: {player_number: 2, direction: -1}) }
    let(:king_square) { JustCheckers::Square.new(x: 3, y: 2, piece: {king: true, player_number: 1, direction: 1}) }

    let(:square_set) { JustCheckers::SquareSet.new(squares: [king_square, enemy_neighbour, empty_square_a, empty_square_b]) }

    it 'must have possible jumps' do
      assert king_square.possible_jumps(king_square.piece, square_set).any?
    end

    it 'must have possible moves' do
      assert king_square.possible_moves(king_square.piece, square_set).any?
    end
  end
end
