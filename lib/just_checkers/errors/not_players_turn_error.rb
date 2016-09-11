require 'just_checkers/errors/error'

module JustCheckers

  # = NotPlayersTurnError
  #
  # A not players turn error with a message
  class NotPlayersTurnError < Error

    # New not players turn errors can be instantiated with
    #
    # @option [String] message
    #   the x co-ordinate.
    #
    # ==== Example:
    #   # Instantiates a new NotPlayersTurnError
    #   JustCheckers::NotPlayersTurnError.new("Custom Message")
    def initialize(message="It is not the player's turn yet.")
      super
    end
  end
end