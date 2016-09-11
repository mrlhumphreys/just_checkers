require 'just_checkers/errors/error'

module JustCheckers

  # = InvalidMoveError
  #
  # An invalid move error with a message
  class InvalidMoveError < Error

    # New invalid move errors can be instantiated with
    #
    # @option [String] message
    #   the x co-ordinate.
    #
    # ==== Example:
    #   # Instantiates a new InvalidMoveError
    #   JustCheckers::InvalidMoveError.new("Custom Message")
    def initialize(message="Move is invalid.")
      super
    end
  end
end