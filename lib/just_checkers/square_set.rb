require 'forwardable'
require 'just_checkers/square'
require 'just_checkers/vector'

module JustCheckers

  # = Square Set
  #
  # A collection of Squares with useful filtering functions
  class SquareSet
    extend Forwardable

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
    #       { x: 1, y: 0, piece: { player_number: 1, direction: 1, king: false }}
    #     ]
    #   })
    def initialize(squares: [])
      @squares = if squares.first.class == Square
        squares
      else
        squares.map { |s| Square.new(s) }
      end
    end

    # @return [Array<Square>] The squares in the set.
    attr_reader :squares

    def_delegator :squares, :first
    def_delegator :squares, :size
    def_delegator :squares, :include?
    def_delegator :squares, :any?
    def_delegator :squares, :none?
    def_delegator :squares, :empty?

    # Iterate over the squares with a block and behaves like Enumerable#each.
    #
    # @return [Enumerable]
    def each(&block)
      squares.each(&block)
    end

    # Filter the squares with a block and behaves like Enumerable#select.
    # It returns a SquareSet with the filtered squares.
    #
    # @return [SquareSet]
    def select(&block)
      self.class.new(squares: squares.select(&block))
    end

    # Filter the squares with a hash of attribute and matching values.
    #
    # @param [Hash] hash
    #   attributes to query for.
    #
    # @return [SquareSet]
    #
    # ==== Example:
    #   # Find all squares where piece is nil
    #   square_set.where(piece: nil)
    def where(hash)
      res = hash.inject(squares) do |memo, (k, v)|
        memo.select { |s| s.attribute_match?(k, v) }
      end
      self.class.new(squares: res)
    end

    # Find the square with the matching x and y co-ordinates
    #
    # @param [Fixnum] x
    #   the x co-ordinate.
    #
    # @param [Fixnum] y
    #   the y co-ordinate.
    #
    # @return [Square]
    # ==== Example:
    #   # Find the square at 4,2
    #   square_set.find_by_x_and_y(4, 2)
    def find_by_x_and_y(x, y)
      select { |s| s.x == x && s.y == y }.first
    end

    # Return all squares that are one square away from the passed square.
    #
    # @param [Square] square
    #   the square in question.
    #
    # @return [SquareSet]
    def one_square_away_from(square)
      select { |s| Vector.new(square, s).magnitude == 1 }
    end

    # Return all squares that are two squares away from the passed square.
    #
    # @param [Square] square
    #   the square in question.
    #
    # @return [SquareSet]
    def two_squares_away_from(square)
      select { |s| Vector.new(square, s).magnitude == 2 }
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
        piece.king? || Vector.new(square, s).direction_y == piece.direction
      end
    end

    # Find all squares without pieces on them.
    #
    # @return [SquareSet]
    def unoccupied
      select { |s| s.piece.nil? }
    end

    # Returns squares between a and b.
    # Only squares that are in the same diagonal will return squares.
    #
    # @param [Square] a
    #   a square.
    #
    # @param [Square] b
    #   another square.
    #
    # @return [SquareSet]
    #
    # ==== Example:
    #   # Get all squares between square_a and square_b
    #   square_set.between(square_a, square_b)
    def between(a, b)
      vector = Vector.new(a, b)
      if vector.diagonal
        point_counter = a.point
        direction = vector.direction
        squares = []

        while point_counter != b.point
          point_counter = point_counter + direction
          square = find_by_x_and_y(point_counter.x, point_counter.y)
          if square && square.point != b.point
            squares.push(square)
          end
        end
      else
        squares = []
      end
      self.class.new(squares: squares)
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

    attr_reader :squares

    # serializes the squares as a hash
    #
    # @return [Hash]
    def as_json
      squares.map(&:as_json)
    end
  end
end