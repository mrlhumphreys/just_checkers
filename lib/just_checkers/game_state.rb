require 'just_checkers/square_set'
require 'just_checkers/errors/not_players_turn_error'
require 'just_checkers/errors/piece_must_capture_error'
require 'just_checkers/errors/invalid_move_error'
require 'just_checkers/errors/empty_square_error'

module JustCheckers

  # = Game State
  #
  # Represents a game of Checkers in progress.
  class GameState

    # New objects can be instantiated.
    #
    # @param [Fixnum] current_player_number
    #   Who's turn it is, 1 or 2
    #
    # @param [Array<Square>] squares
    #   An array of squares, each with x and y co-ordinates and a piece.
    #
    # ==== Example:
    #   # Instantiates a new Game of Checkers
    #   JustCheckers::GameState.new({
    #     current_player_number: 1,
    #     squares: [
    #       { x: 1, y: 0, piece: { player_number: 1, king: false }}
    #     ]
    #   })
    def initialize(current_player_number: , squares: [])
      @current_player_number = current_player_number
      @squares = SquareSet.new(squares: squares)
      @errors = []
      @last_change = {}
    end

    # @return [Fixnum] who's turn it is.
    attr_reader :current_player_number

    # @return [Array<Square>] the board state.
    attr_reader :squares

    # @return [Array<Error>] errors if any.
    attr_reader :errors

    # @return [Hash] most recent change.
    attr_reader :last_change

    # Instantiates a new GameState object in the starting position
    #
    # @return [GameState]
    def self.default
      new({
        current_player_number: 1,
        squares: [
          { id: 1, x: 1, y: 0, piece: { player_number: 1, king: false }},
          { id: 2, x: 3, y: 0, piece: { player_number: 1, king: false }},
          { id: 3, x: 5, y: 0, piece: { player_number: 1, king: false }},
          { id: 4, x: 7, y: 0, piece: { player_number: 1, king: false }},

          { id: 5, x: 0, y: 1, piece: { player_number: 1, king: false }},
          { id: 6, x: 2, y: 1, piece: { player_number: 1, king: false }},
          { id: 7, x: 4, y: 1, piece: { player_number: 1, king: false }},
          { id: 8, x: 6, y: 1, piece: { player_number: 1, king: false }},

          { id: 9, x: 1, y: 2, piece: { player_number: 1, king: false }},
          { id: 10, x: 3, y: 2, piece: { player_number: 1, king: false }},
          { id: 11, x: 5, y: 2, piece: { player_number: 1, king: false }},
          { id: 12, x: 7, y: 2, piece: { player_number: 1, king: false }},

          { id: 13, x: 0, y: 3, piece: nil },
          { id: 14, x: 2, y: 3, piece: nil },
          { id: 15, x: 4, y: 3, piece: nil },
          { id: 16, x: 6, y: 3, piece: nil },

          { id: 17, x: 1, y: 4, piece: nil },
          { id: 18, x: 3, y: 4, piece: nil },
          { id: 19, x: 5, y: 4, piece: nil },
          { id: 20, x: 7, y: 4, piece: nil },

          { id: 21, x: 0, y: 5, piece: { player_number: 2, king: false }},
          { id: 22, x: 2, y: 5, piece: { player_number: 2, king: false }},
          { id: 23, x: 4, y: 5, piece: { player_number: 2, king: false }},
          { id: 24, x: 6, y: 5, piece: { player_number: 2, king: false }},

          { id: 25, x: 1, y: 6, piece: { player_number: 2, king: false }},
          { id: 26, x: 3, y: 6, piece: { player_number: 2, king: false }},
          { id: 27, x: 5, y: 6, piece: { player_number: 2, king: false }},
          { id: 28, x: 7, y: 6, piece: { player_number: 2, king: false }},

          { id: 29, x: 0, y: 7, piece: { player_number: 2, king: false }},
          { id: 30, x: 2, y: 7, piece: { player_number: 2, king: false }},
          { id: 31, x: 4, y: 7, piece: { player_number: 2, king: false }},
          { id: 32, x: 6, y: 7, piece: { player_number: 2, king: false }},
        ]
      })
    end

    # A hashed serialized representation of the game state
    #
    # @return [Hash]
    def as_json
      {
        current_player_number: current_player_number,
        squares: squares.as_json
      }
    end

    # The player number of the winner. It returns nil if there is no winner.
    #
    # @return [Fixnum,NilClass]
    def winner
      if no_pieces_for_player?(1)
        2
      elsif no_pieces_for_player?(2)
        1
      else
        nil
      end
    end

    # Moves a piece owned by the player, from one square, to another
    #
    # It moves the piece and returns true if the move is valid and it's the player's turn.
    # It returns false otherwise.
    #
    # ==== Example:
    #   # Moves a piece from a square to perform a double jump
    #   game_state.move(1, {x: 0, y: 1}, [{x: 1, y: 2}, {x: 3, y: 4}])
    #
    # @param [Fixnum] player_number
    #   the player number, 1 or 2.
    #
    # @param [Hash, Fixnum] from
    #   where the moving piece currently is.
    #
    # @param [Array<Hash>, Array<Fixnum>] to
    #   each place the piece is going to move to.
    #
    # @return [Boolean]
    def move(player_number, from, to)
      @errors = []

      from_square = if from.is_a?(Hash)
        squares.find_by_x_and_y(from[:x].to_i, from[:y].to_i)
      else
        squares.find_by_id(from.to_i)
      end

      to_squares = if to.all? { |s| s.is_a?(Hash) }
        to.map { |position| squares.find_by_x_and_y(position[:x].to_i, position[:y].to_i) }
      else
        to.map { |id| squares.find_by_id(id.to_i) }
      end

      if player_number != current_player_number
        @errors.push NotPlayersTurnError.new
      elsif move_valid?(from_square, to_squares)
        @last_change = { type: 'move', data: {player_number: player_number, from: from, to: to} }
        perform_move(from_square, to_squares)
        to_squares.last.promote if to_squares.last.promotable?
        turn
      end

      @errors.empty?
    end

    private

    def move_valid?(from, to) # :nodoc:
      legs = to.unshift(from)
      from_piece = from && from.piece

      if from_piece
        legs.each_cons(2).map do |origin, destination|
          if squares.occupied_by(from_piece.player_number).any? { |s| s.possible_jumps(s.piece, squares).any? }
            @errors.push(PieceMustCaptureError.new) unless origin.possible_jumps(from_piece, squares).include?(destination)
          else
            @errors.push(InvalidMoveError.new) unless origin.possible_moves(from_piece, squares).include?(destination)
          end
        end.all?
      else
        @errors.push EmptySquareError.new
      end

      @errors.empty?
    end

    def perform_move(from, to) # :nodoc:
      legs = to.unshift(from)
      legs.each_cons(2) do |origin, destination|
        between_square = squares.between(origin, destination).first
        between_square.piece = nil if between_square
      end

      to.last.piece = from.piece
      from.piece = nil
    end

    def turn # :nodoc:
      @current_player_number = other_player_number
    end

    def other_player_number # :nodoc:
      current_player_number == 1 ? 2 : 1
    end

    def no_pieces_for_player?(player_number) # :nodoc:
      squares.occupied_by(player_number).none? { |s| s.possible_jumps(s.piece, squares).any? || s.possible_moves(s.piece, squares).any? }
    end
  end
end