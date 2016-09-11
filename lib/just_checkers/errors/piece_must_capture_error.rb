require 'just_checkers/errors/error'

module JustCheckers

  # = PieceMustCaptureError
  #
  # A piece must capture error with a message
  class PieceMustCaptureError < Error

    # New piece must capture errors can be instantiated with
    #
    # @option [String] message
    #   the x co-ordinate.
    #
    # ==== Example:
    #   # Instantiates a new PieceMustCaptureError
    #   JustCheckers::PieceMustCaptureError.new("Custom Message")
    def initialize(message="Another piece must capture first.")
      super
    end
  end
end