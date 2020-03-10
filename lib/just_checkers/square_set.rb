require 'board_game_grid'
require 'just_checkers/square'

module JustCheckers

  # = Square Set
  #
  # A collection of Squares with useful filtering functions
  class SquareSet < BoardGameGrid::SquareSet

    # New objects can be instantiated by passing in a hash with squares.
    # They can be square objects or hashes.
    #
    # @param [Array<Square,Hash>] squares
    #   An array of squares, each with x and y co-ordinates and a piece.
    #
    # ==== Example:
    #   # Instantiates a new Square Set
    #   JustCheckers::SquareSet.new({
    #     squares: [
    #       { x: 1, y: 0, piece: { player_number: 1, king: false }}
    #     ]
    #   })
    def initialize(squares: [])
      @squares = if squares.all? { |element| element.instance_of?(Hash) }
        squares.map { |args| JustCheckers::Square.new(**args) }
      elsif squares.all? { |element| element.instance_of?(JustCheckers::Square) }
        squares
      else
        raise ArgumentError, "all squares must have the same class"
      end
    end

    # Find squares in the direction of the piece from the square
    # If the piece is normal, it returns squares in front of it.
    # If the piece is king, it returns all squares.
    #
    # @param [Piece] piece
    #   the piece in question.
    #
    # @param [Square] square
    #   the square the piece is on.
    #
    # @return [SquareSet]
    #
    # ==== Example:
    #   # Get all squares in the direction of the piece.
    #   square_set.in_direction_of(piece, square)
    def in_direction_of(piece, square)
      select do |s|
        piece.king? || BoardGameGrid::Vector.new(square, s).direction.y == piece.direction
      end
    end

    # Takes a player number and returns all squares occupied by the opponent of the player
    #
    # @param [Fixnum] player_number
    #   the player's number.
    #
    # @return [SquareSet]
    def occupied_by_opponent_of(player_number)
      select { |s| s.piece && s.piece.player_number != player_number }
    end

    # Takes a player number and returns all squares occupied by the player
    #
    # @param [Fixnum] player_number
    #   the player's number.
    #
    # @return [SquareSet]
    def occupied_by(player_number)
      select { |s| s.piece && s.piece.player_number == player_number }
    end
  end
end
