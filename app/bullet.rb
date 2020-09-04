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

    def move_on
        return false if self.hit?
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

    def hit?
        map_salle = Object.const_get("MAP_" + @salle_id.to_s)
        inside = false

        map_salle["collision"].each do |pos_rect|
            #CETTE BOUCLE N'EST PAS TERRIBLE. Voir si on peut faire une seule condition sans boucle
            if [@last_pos_x, @last_pos_y].inside_rect? pos_rect
                inside = true
                break
            end
        end
        return inside        
    end

    def rect
        [@last_pos_x, @last_pos_y, 10, 10]
    end
end