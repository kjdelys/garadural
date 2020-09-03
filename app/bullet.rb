class Bullet
    attr_accessor :orientation, :last_pos_x, :last_pos_y, :speed

    def initialize(orientation, last_pos_x, last_pos_y, speed)
        @orientation = orientation
        @last_pos_x = last_pos_x
        @last_pos_y = last_pos_y
        @speed = speed
    end
end