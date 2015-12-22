module JustCheckers

  # = Point
  #
  # A point with an x and y co-ordinates
  class Point

    # New objects can be instantiated with
    #
    # * +x+ - x co-ordinate
    # * +y+ - y co-ordinate
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

    attr_reader :x, :y

    # add a point to another point by adding their co-ordinates and returning a new point.
    def +(other)
      self.class.new(self.x + other.x, self.y + other.y)
    end

    # check if points are equal by seeing if their co-ordinates are equal.
    def ==(other)
      self.x == other.x && self.y == other.y
    end
  end
end