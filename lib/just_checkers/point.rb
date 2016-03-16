module JustCheckers

  # = Point
  #
  # A point with an x and y co-ordinates
  class Point

    # New objects can be instantiated with
    #
    # @param [Fixnum] x
    #   the x co-ordinate.
    #
    # @param [Fixnum] y
    #   the y co-ordinate.
    #
    # ==== Example:
    #   # Instantiates a new Point
    #   JustCheckers::Point.new({
    #     x: 1,
    #     y: 1
    #   })
    def initialize(x, y)
      @x, @y = x, y
    end

    # @return [Fixnum] the x co-ordinate.
    attr_reader :x
    
    # @return [Fixnum] the y co-ordinate.
    attr_reader :y

    # Add a point to another point by adding their co-ordinates and returning a new point.
    #
    # @param [Point] other
    #   the other point to add.
    #
    # @return [Point]
    def +(other)
      self.class.new(self.x + other.x, self.y + other.y)
    end

    # Check if popints are equal by seeing if their co-ordinates are equal.
    #
    # @param [Point] other
    #   the other point to compare to.
    #
    # @return [TrueClass, FalseClass]
    def ==(other)
      self.x == other.x && self.y == other.y
    end
  end
end