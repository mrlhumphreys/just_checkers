module JustCheckers

  # = Direction
  #
  # The Direction that something is moving on a 2d plane
  class Direction

    # New objects can be instantiated with
    #
    # * +x+ - x magnitude
    # * +y+ - y magnitude
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

    attr_reader :x, :y

    # check if directions are equal by seeing if their magnitudes are equal.
    def ==(other)
      self.x == other.x && self.y == other.y
    end
  end
end