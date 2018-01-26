module JustCheckers

  # = Direction
  #
  # The Direction that something is moving on a 2d plane
  class Direction

    # New objects can be instantiated with
    #
    # @param [Fixnum] dx
    #   the dx magnitude.
    #
    # @param [Fixnum] dy
    #   the dy magnitude.
    #
    # ==== Example:
    #   # Instantiates a new Direction
    #   JustCheckers::Direction.new({
    #     dx: 1,
    #     dy: 1
    #   })
    def initialize(dx, dy)
      x = dx == 0 ? dx : dx/dx.abs
      y = dy == 0 ? dy : dy/dy.abs

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