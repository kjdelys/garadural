class Player < Character
    def position
        if (0..1280).include?(@pos_x) && (0..720).include?(@pos_y)
            [0, 0]
        elsif @pos_x > 1280
            [1, 0]
        elsif @pos_x < 0
            [-1, 0]
        elsif @pos_x > 720
            [0, -1]
        elsif @pos_x < 0
            [0, 1]
        end
    end
end