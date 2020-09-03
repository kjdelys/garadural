class Bullet
    attr_accessor :orientation, :last_pos_x, :last_pos_y, :speed
    attr_reader :oblique_speed
    def initialize(orientation, last_pos_x, last_pos_y, speed)
        @orientation = orientation
        @last_pos_x = last_pos_x
        @last_pos_y = last_pos_y
        @speed = speed
        @oblique_speed = Math.sqrt((speed*speed)/2)
    end

    def move_on
        case @orientation
        when 0
            @last_pos_y = @last_pos_y + @speed
        when 45
            @last_pos_y = @last_pos_y + @oblique_speed
            @last_pos_x = @last_pos_x + @oblique_speed
        when 90
            @last_pos_x = @last_pos_x + @speed
        when 135
            @last_pos_y = @last_pos_y - @oblique_speed
            @last_pos_x = @last_pos_x + @oblique_speed
        when 180
            @last_pos_y = @last_pos_y - @speed
        when 225
            @last_pos_y = @last_pos_y - @oblique_speed
            @last_pos_x = @last_pos_x - @oblique_speed
        when 270
            @last_pos_x = @last_pos_x - @speed
        when 315
            @last_pos_y = @last_pos_y + @oblique_speed
            @last_pos_x = @last_pos_x - @oblique_speed
        end
    end

    def rect
        [@last_pos_x, @last_pos_y, 10, 10]
    end
end