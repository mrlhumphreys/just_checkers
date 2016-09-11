module JustCheckers

  # = Error
  #
  # An error with a message
  class Error

    # New errors can be instantiated with
    #
    # @option [String] message
    #   the x co-ordinate.
    #
    # ==== Example:
    #   # Instantiates a new Error
    #   JustCheckers::Error.new("Custom Message")
    def initialize(message="Generic Error")
      @message = message
    end
  end
end