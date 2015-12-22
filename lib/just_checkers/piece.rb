module JustCheckers
  # = Game State
  #
  # A piece that can move on a checkers board
  class Piece

    # New objects can be instantiated by passing in a hash with
    #
    # * +player_number+ - The player who owns the piece, 1 or 2
    # * +direction+ - The direction forward on the board, 1 for moving down, -1 for moving up.
    # * +king+ - Set to true if the piece has been crowned
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

    attr_reader :player_number, :direction, :king
    alias_method :king?, :king

    # promotes the piece by setting the +king+ attribute to true.
    def promote!
      @king = true
    end

    # returns a serialized piece as a hash
    def as_json
      { player_number: player_number, direction: direction, king: king }
    end
  end
end