module JustCheckers
  # = Game State
  #
  # A piece that can move on a checkers board
  class Piece

    # New objects can be instantiated by passing in a hash with
    #
    # @param [Hash] args
    #   The data needed for a piece
    #
    # @option args [Fixnum] player_number
    #   the owner of the piece.
    #
    # @option args [Fixnum] direction
    #   the direction forward on the board, 1 for moving down, -1 for moving up.
    #
    # @option args [Boolean] king
    #   set to true if the piece has been crowned.
    #
    # ==== Example:
    #   # Instantiates a new Piece
    #   JustCheckers::Piece.new({
    #     player_number: 1,
    #     direction: 1,
    #     king: false
    #   })
    def initialize(args = {})
      @player_number = args[:player_number]
      @direction = args[:direction]
      @king = args[:king]
    end

    # @return [Fixnum] the owner of the piece.
    attr_reader :player_number
    
    # @return [Fixnum] the direction forward on the board, 1 for moving down, -1 for moving up.
    attr_reader :direction
    
    # @return [Boolean] set to true if the piece has been crowned.
    attr_reader :king
    
    alias_method :king?, :king

    # promotes the piece by setting the +king+ attribute to true.
    #
    # @return [TrueClass]
    def promote!
      @king = true
    end

    # returns a serialized piece as a hash
    #
    # @return [Hash]
    def as_json
      { player_number: player_number, direction: direction, king: king }
    end
  end
end