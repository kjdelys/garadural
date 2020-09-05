class Player < Character

    def subclass_name
        "Player"
    end

    def position
        if (0..1280).include?(@pos_x) && (0..720).include?(@pos_y)
            pos = [0, 0]
        elsif @pos_x > 1280
            pos = [1, 0]
        elsif @pos_x < 0
            pos = [-1, 0]
        elsif @pos_y > 720
            pos = [0, -1]
        elsif @pos_y < 0
            pos = [0, 1]
        end
        return pos
    end

end