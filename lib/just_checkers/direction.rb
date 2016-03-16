module JustCheckers

  # = Direction
  #
  # The Direction that something is moving on a 2d plane
  class Direction

    # New objects can be instantiated with
    #
    # @param [Fixnum] x
    #   the x magnitude.
    #
    # @param [Fixnum] y
    #   the y magnitude.
    #
    # ==== Example:
    #   # Instantiates a new Direction
    #   JustCheckers::Direction.new({
    #     x: 1,
    #     y: 1
    #   })
    def initialize(x, y)
      @x, @y = x, y
    end

    # @return [Fixnum] the x magnitude.
    attr_reader :x
    
    # @return [Fixnum] the y magnitude.
    attr_reader :y

    # Check if directions are equal by seeing if their magnitudes are equal.
    #
    # @param [Direction] other
    #   the other direction to compare to.
    #
    # @return [Boolean]
    def ==(other)
      self.x == other.x && self.y == other.y
    end
  end
end