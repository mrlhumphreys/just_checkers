require 'just_checkers/errors/error'

module JustCheckers

  # = EmptySquareError
  #
  # An empty square error with a message
  class EmptySquareError < Error

    # New empty square errors can be instantiated with
    #
    # @option [String] message
    #   the x co-ordinate.
    #
    # ==== Example:
    #   # Instantiates a new EmptySquareError
    #   JustCheckers::EmptySquareError.new("Custom Message")
    def initialize(message="Square is empty.")
      super
    end
  end
end