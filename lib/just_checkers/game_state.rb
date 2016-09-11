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
    #       { x: 1, y: 0, piece: { player_number: 1, direction: 1, king: false }}
    #     ]
    #   })
    def initialize(current_player_number: , squares: [])
      @current_player_number = current_player_number
      @squares = SquareSet.new(squares: squares)
      @errors = []
    end

    # @return [Fixnum] who's turn it is.
    attr_reader :current_player_number

    # @return [Array<Square>] the board state.
    attr_reader :squares

    # @return [Array<Error>] errors if any.
    attr_reader :errors

    # Instantiates a new GameState object in the starting position
    #
    # @return [GameState]
    def self.default
      new({
        current_player_number: 1,
        squares: [
          { x: 1, y: 0, piece: { player_number: 1, direction: 1, king: false }},
          { x: 3, y: 0, piece: { player_number: 1, direction: 1, king: false }},
          { x: 5, y: 0, piece: { player_number: 1, direction: 1, king: false }},
          { x: 7, y: 0, piece: { player_number: 1, direction: 1, king: false }},

          { x: 0, y: 1, piece: { player_number: 1, direction: 1, king: false }},
          { x: 2, y: 1, piece: { player_number: 1, direction: 1, king: false }},
          { x: 4, y: 1, piece: { player_number: 1, direction: 1, king: false }},
          { x: 6, y: 1, piece: { player_number: 1, direction: 1, king: false }},

          { x: 1, y: 2, piece: { player_number: 1, direction: 1, king: false }},
          { x: 3, y: 2, piece: { player_number: 1, direction: 1, king: false }},
          { x: 5, y: 2, piece: { player_number: 1, direction: 1, king: false }},
          { x: 7, y: 2, piece: { player_number: 1, direction: 1, king: false }},

          { x: 0, y: 3, piece: nil },
          { x: 2, y: 3, piece: nil },
          { x: 4, y: 3, piece: nil },
          { x: 6, y: 3, piece: nil },

          { x: 1, y: 4, piece: nil },
          { x: 3, y: 4, piece: nil },
          { x: 5, y: 4, piece: nil },
          { x: 7, y: 4, piece: nil },

          { x: 0, y: 5, piece: { player_number: 2, direction: -1, king: false }},
          { x: 2, y: 5, piece: { player_number: 2, direction: -1, king: false }},
          { x: 4, y: 5, piece: { player_number: 2, direction: -1, king: false }},
          { x: 6, y: 5, piece: { player_number: 2, direction: -1, king: false }},

          { x: 1, y: 6, piece: { player_number: 2, direction: -1, king: false }},
          { x: 3, y: 6, piece: { player_number: 2, direction: -1, king: false }},
          { x: 5, y: 6, piece: { player_number: 2, direction: -1, king: false }},
          { x: 7, y: 6, piece: { player_number: 2, direction: -1, king: false }},

          { x: 0, y: 7, piece: { player_number: 2, direction: -1, king: false }},
          { x: 2, y: 7, piece: { player_number: 2, direction: -1, king: false }},
          { x: 4, y: 7, piece: { player_number: 2, direction: -1, king: false }},
          { x: 6, y: 7, piece: { player_number: 2, direction: -1, king: false }},
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
      if squares.occupied_by(1).none? { |s| s.possible_jumps(s.piece, squares).any? || s.possible_moves(s.piece, squares).any? }
        2
      elsif squares.occupied_by(2).none? { |s| s.possible_jumps(s.piece, squares).any? || s.possible_moves(s.piece, squares).any? }
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
    #   game_state.move!(1, {x: 0, y: 1}, [{x: 1, y: 2}, {x: 3, y: 4}])
    #
    # @param [Fixnum] player_number
    #   the player number, 1 or 2.
    #
    # @param [Hash] from
    #   where the moving piece currently is.
    #
    # @param [Array<Hash>] to
    #   each place the piece is going to move to.
    #
    # @return [Boolean]
    def move!(player_number, from, to)
      @errors = []
      from_square = squares.find_by_x_and_y(from[:x].to_i, from[:y].to_i)
      to_squares = to.map { |p| squares.find_by_x_and_y(p[:x].to_i, p[:y].to_i) }

      if player_number != current_player_number
        @errors.push NotPlayersTurnError.new
      else
        if move_valid?(from_square, to_squares)
          perform_move!(from_square, to_squares)
          promote!(to_squares.last) if promotable?(to_squares.last)
          turn!
        end
      end

      @errors.empty?
    end

    private

    def move_valid?(from, to) # :nodoc:
      legs = to.unshift(from)
      if from && from.piece
        legs.each_cons(2).map do |a, b|
          if squares.occupied_by(from.piece.player_number).any? { |s| s.possible_jumps(s.piece, squares).any? }
            unless a.possible_jumps(from.piece, squares).include?(b)
              @errors.push PieceMustCaptureError.new
            end
          else
            unless a.possible_moves(from.piece, squares).include?(b)
              @errors.push InvalidMoveError.new
            end
          end
        end.all?
      else
        @errors.push EmptySquareError.new
      end

      @errors.empty?
    end

    def promote!(square) # :nodoc:
      square.piece.promote!
    end

    def perform_move!(from, to) # :nodoc:
      legs = to.unshift(from)
      legs.each_cons(2) do |a, b|
        between_square = squares.between(a, b).first
        between_square.piece = nil if between_square
      end

      to.last.piece = from.piece
      from.piece = nil
    end

    def turn! # :nodoc:
      @current_player_number = other_player_number
    end

    def other_player_number # :nodoc:
      current_player_number == 1 ? 2 : 1
    end

    def promotable?(square) # :nodoc:
      case square.piece.direction
      when 1
        square.y == 7
      when -1
        square.y == 0
      else
        false
      end
    end

  end
end