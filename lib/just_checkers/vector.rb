require 'just_checkers/direction'

module JustCheckers

  # = Vector
  #
  # An element of Vector space
  class Vector

    # New objects can be instantiated by passing in a two points with x and y co-ordinates
    #
    # * +a+ - A point with an x and y co-ordinates.
    # * +b+ - A point with an x and y co-ordinates.
    #
    # ==== Example:
    #   # Instantiates a new Vector
    #   JustCheckers::Vector.new({
    #     a: JustCheckers::Point.new(x: 1, y: 1),
    #     b: JustCheckers::Point.new(x: 3, y: 3)
    #   })
    def initialize(a, b)
      @a, @b = a, b
    end

    attr_reader :a, :b

    # returns how big the vector is if it's diagonal, otherwise, nil.
    def magnitude
      if diagonal
        dx.abs
      else
        nil
      end
    end

    # returns a direction of the vector as a object
    def direction
      Direction.new(direction_x, direction_y)
    end

    # returns the x component of the direction, 1 if moving down, -1 if moving up, 0 otherwise
    def direction_x
      if dx > 0
        1
      elsif dx == 0
        0
      else
        -1
      end
    end

    # returns the y component of the direction, 1 if moving right, -1 if moving left, 0 otherwise
    def direction_y
      if dy > 0
        1
      elsif dy == 0
        0
      else
        -1
      end
    end

    # returns true if the vector is diagonal.
    def diagonal
      dx.abs == dy.abs
    end

    private

    def dx
      b.x - a.x
    end

    def dy
      b.y - a.y
    end
  end
end