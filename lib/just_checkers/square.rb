require 'just_checkers/piece'
require 'just_checkers/point'

module JustCheckers

  # = Square
  #
  # A Square on a board of checkers
  class Square

    # New objects can be instantiated by passing in a hash with
    #
    # @param [Hash] args
    #   The data needed for a square
    #
    # @option args [Fixnum] x
    #   the x co-ordinate of the square.
    #
    # @option args [Fixnum] y
    #   the y co-ordinate of the square.
    #
    # @option args [Piece,Hash,NilClass] piece
    #   The piece on the square, can be a piece object or hash or nil.
    #
    # ==== Example:
    #   # Instantiates a new Square
    #   JustCheckers::Square.new({
    #     x: 1,
    #     y: 0,
    #     piece: { player_number: 1, direction: 1, king: false }
    #   })
    def initialize(args = {})
      @x = args[:x]
      @y = args[:y]
      if args[:piece].is_a?(Hash)
        @piece = Piece.new(args[:piece])
      else
        @piece = args[:piece]
      end
    end

    # @return [Fixnum] the x co-ordinate of the square.
    attr_reader :x 
    
    # @return [Fixnum] the y co-ordinate of the square.
    attr_reader :y
    
    # @return [Piece,NilClass] The piece on the square if any.
    attr_accessor :piece

    # checks if the square matches the attributes passed.
    #
    # @param [Symbol] attribute
    #   the square's attribute.
    #
    # @param [Object,Hash] value
    #   a value to match on. Can be a hash of attribute/value pairs for deep matching
    #
    # ==== Example:
    #   # Check if square has a piece owned by player 1
    #   square.attribute_match?(:piece, player_number: 1)
    def attribute_match?(attribute, value)
      hash_obj_matcher = lambda do |obj, k, v|
        value = obj.send(k)
        if !value.nil? && v.is_a?(Hash)
          v.all? { |k2,v2| hash_obj_matcher.call(value, k2, v2) }
        else
          value == v
        end
      end

      hash_obj_matcher.call(self, attribute, value)
    end

    # Is the square unoccupied by a piece?
    #
    # @return [Boolean]
    def unoccupied?
      piece.nil?
    end

    # A point object with the square's co-ordinates.
    #
    # @return [Point]
    def point
      Point.new(x, y)
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
      squares.two_squares_away_from(self).in_direction_of(piece, self).unoccupied.select do |s|
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
      squares.one_square_away_from(self).in_direction_of(piece, self).unoccupied
    end

    # A serialized version of the square as a hash
    #
    # @return [Hash]
    def as_json
      { x: x, y: y, piece: piece && piece.as_json }
    end
  end
end