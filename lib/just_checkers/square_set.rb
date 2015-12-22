require 'forwardable'
require 'just_checkers/square'

module JustCheckers

  # = Square Set
  #
  # A collection of Squares with useful filtering functions
  class SquareSet
    extend Forwardable

    # New objects can be instantiated by passing in a hash with squares.
    # They can be square objects or hashes.
    #
    # * +squares+ - An array of squares, each with x and y co-ordinates and a piece.
    #
    # ==== Example:
    #   # Instantiates a new Square Set
    #   JustCheckers::SquareSet.new({
    #     squares: [
    #       { x: 1, y: 0, piece: { player_number: 1, direction: 1, king: false }}
    #     ]
    #   })
    def initialize(args = {})
      if args[:squares].first.class == Square
        @squares = args[:squares]
      else
        @squares = args[:squares].map { |s| Square.new(s) }
      end
    end

    attr_reader :squares

    def_delegator :squares, :first
    def_delegator :squares, :size
    def_delegator :squares, :include?
    def_delegator :squares, :any?
    def_delegator :squares, :none?
    def_delegator :squares, :empty?

    # Iterate over the squares with a block and behaves like Enumerable#each.
    def each(&block)
      squares.each(&block)
    end

    # Filter the squares with a block and behaves like Enumerable#select.
    # It returns a SquareSet with the filtered squares.
    def select(&block)
      self.class.new(squares: squares.select(&block))
    end

    # Filter the squares with a hash of attribute and matching values.
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
    # ==== Example:
    #   # Find the square at 4,2
    #   square_set.find_by_x_and_y(4, 2)
    def find_by_x_and_y(x, y)
      select { |s| s.x == x && s.y == y }.first
    end

    # Return all squares that are one square away from the passed square.
    def one_square_away_from(square)
      select { |s| Vector.new(square, s).magnitude == 1 }
    end

    # Return all squares that are two squares away from the passed square.
    def two_squares_away_from(square)
      select { |s| Vector.new(square, s).magnitude == 2 }
    end

    # Returns squares in the direction of the piece from the square
    # If the piece is normal, it returns squares in front of it.
    # If the piece is king, it returns all squares.
    #
    # ==== Example:
    #   # Get all squares in the direction of the piece.
    #   square_set.in_direction_of(piece, square)
    def in_direction_of(piece, square)
      select do |s|
        piece.king? || Vector.new(square, s).direction_y == piece.direction
      end
    end

    # Returns all squares without pieces on them.
    def unoccupied
      select { |s| s.piece.nil? }
    end

    # Returns squares between a and b.
    # Only squares that are in the same diagonal will return squares.
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

    # takes a player number and returns all squares occupied by the opponent of the player
    def occupied_by_opponent_of(player_number)
      select { |s| s.piece && s.piece.player_number != player_number }
    end

    # takes a player number and returns all squares occupied by the player
    def occupied_by(player_number)
      select { |s| s.piece && s.piece.player_number == player_number }
    end

    attr_reader :squares

    # serializes the squares as a hash
    def as_json
      squares.map(&:as_json)
    end
  end
end