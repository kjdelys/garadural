class Player < Character
    def is_inside_visible?
        return (0..1280).include?(@pos_x) && (0..720).include?(@pos_y)
    end
end