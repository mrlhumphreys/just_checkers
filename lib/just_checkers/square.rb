require 'just_checkers/piece'
require 'just_checkers/point'
require 'board_game_grid'

module JustCheckers

  # = Square
  #
  # A Square on a board of checkers
  class Square < BoardGameGrid::Square

    # New objects can be instantiated by passing in a hash with
    #
    # @param [Fixnum] id
    #   the unique identifier of the square.
    #
    # @param [Fixnum] x
    #   the x co-ordinate of the square.
    #
    # @param [Fixnum] y
    #   the y co-ordinate of the square.
    #
    # @option [Piece,Hash,NilClass] piece
    #   The piece on the square, can be a piece object or hash or nil.
    #
    # ==== Example:
    #   # Instantiates a new Square
    #   JustCheckers::Square.new({
    #     id: 1,
    #     x: 1,
    #     y: 0,
    #     piece: { player_number: 1, king: false }
    #   })
    def initialize(id: , x: , y: , piece: nil)
      @id = id
      @x = x
      @y = y
      @piece = if piece.is_a?(Hash)
        Piece.new(**piece)
      else
        piece
      end
    end

    # A serialized version of the square as a hash
    #
    # @return [Hash]
    def as_json
      { id: id, x: x, y: y, piece: piece && piece.as_json }
    end

    # All squares that a piece on this square could jump to, given the board.
    #
    # @param [Piece] piece
    #   the piece on this square
    #
    # @param [SquareSet] squares
    #   the board
    #
    # @return [SquareSet]
    def possible_jumps(piece, squares)
      squares.at_range(self, 2).in_direction_of(piece, self).unoccupied.select do |s|
        squares.between(self, s).occupied_by_opponent_of(piece.player_number).any?
      end
    end

    # All squares that a piece on this square could move to, given the board.
    #
    # @param [Piece] piece
    #   the piece on this square
    #
    # @param [SquareSet] squares
    #   the board
    #
    # @return [SquareSet]
    def possible_moves(piece, squares)
      squares.at_range(self, 1).in_direction_of(piece, self).unoccupied
    end

    # Checks if the piece on the square can promote.
    #
    # @return [Boolean]
    def promotable?
      case piece && piece.direction
      when 1
        y == 7
      when -1
        y == 0
      else
        false
      end
    end

    # Promotes the piece if the piece exists.
    #
    # @return [Boolean]
    def promote
      piece && piece.promote
    end
  end
end
