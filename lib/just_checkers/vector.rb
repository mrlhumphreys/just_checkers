require 'just_checkers/direction'

module JustCheckers

  # = Vector
  #
  # An element of Vector space
  class Vector

    # New objects can be instantiated by passing in a two points with x and y co-ordinates
    #
    # @param [Point] origin
    #   the start point.
    #
    # @param [Point] destination
    #   the end point.
    #
    # ==== Example:
    #   # Instantiates a new Vector
    #   JustCheckers::Vector.new(
    #     JustCheckers::Point.new(x: 1, y: 1),
    #     JustCheckers::Point.new(x: 3, y: 3)
    #   )
    def initialize(origin, destination)
      @origin, @destination = origin, destination
    end

    # @return [Object] the origin.
    attr_reader :origin

    # @return [Object] the destination.
    attr_reader :destination

    # The direction of the vector as a object
    #
    # @return [Direction]
    def direction
      Direction.new(dx, dy)
    end

    # How big the vector is if it's diagonal, otherwise, nil.
    #
    # @return [Fixnum,NilClass]
    def magnitude
      if diagonal?
        dx.abs
      else
        nil
      end
    end

    # The x component of the direction, 1 if moving down, -1 if moving up, 0 otherwise
    #
    # @return [Fixnum]
    def direction_x
      direction.x
    end

    # The y component of the direction, 1 if moving right, -1 if moving left, 0 otherwise
    #
    # @return [Fixnum]
    def direction_y
      direction.y
    end

    # Is the vector diagonal?
    #
    # @return [Boolean]
    def diagonal?
      dx.abs == dy.abs
    end

    private

    def dx
      destination.x - origin.x
    end

    def dy
      destination.y - origin.y
    end
  end
end