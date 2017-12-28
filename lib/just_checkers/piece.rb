module JustCheckers
  # = Game State
  #
  # A piece that can move on a checkers board
  class Piece

    # New objects can be instantiated by passing in a hash with
    #
    # @param [Fixnum] id
    #   the unique id of the piece.
    #
    # @param [Fixnum] player_number
    #   the owner of the piece.
    #
    # @option [Boolean] king
    #   set to true if the piece has been crowned.
    #
    # ==== Example:
    #   # Instantiates a new Piece
    #   JustCheckers::Piece.new({
    #     player_number: 1,
    #     king: false
    #   })
    def initialize(id: , player_number: , king: false)
      @id = id
      @player_number = player_number
      @king = king
    end

    # @return [Fixnum] the unique id of the piece.
    attr_reader :id

    # @return [Fixnum] the owner of the piece.
    attr_reader :player_number

    # @return [Boolean] set to true if the piece has been crowned.
    attr_reader :king

    alias_method :king?, :king

    # promotes the piece by setting the +king+ attribute to true.
    #
    # @return [TrueClass]
    def promote
      @king = true
    end


    # the direction forward on the board, 1 for moving down, -1 for moving up.
    #
    # @return [Fixnum]
    def direction
      @player_number == 1 ? 1 : -1
    end

    # returns a serialized piece as a hash
    #
    # @return [Hash]
    def as_json
      { id: id, player_number: player_number, king: king }
    end
  end
end