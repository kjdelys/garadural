class Bullet
    attr_accessor :orientation, :last_pos_x, :last_pos_y, :speed, :salle_id
    attr_reader :oblique_speed
    def initialize(orientation, last_pos_x, last_pos_y, speed, salle_id)
        @orientation = orientation
        @last_pos_x = last_pos_x
        @last_pos_y = last_pos_y
        @speed = speed
        @oblique_speed = Math.sqrt((speed*speed)/2)
        @salle_id = salle_id
    end

    def move_on(collision_intervalles)
        return false if self.hit?(collision_intervalles)
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
        return true
    end

    def hit?(collision_intervalles)
        return collision?([[@last_pos_x, @last_pos_y]], collision_intervalles)        
    end

    def rect
        [@last_pos_x, @last_pos_y, 5, 5]
    end
end