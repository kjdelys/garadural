class Sword
    attr_accessor :orientation, :pos_x, :pos_y, :size, :salle_id, :image

    def initialize(orientation, pos_x, pos_y, size, salle_id, params_size={})
        @orientation = orientation
        @pos_x = pos_x
        @pos_y = pos_y
        @size = size
        @image = define_image(pos_x, pos_y, orientation, params_size)
        @salle_id = salle_id
    end

    def define_image(pos_x, pos_y, orientation, params_size)
        puts(orientation)
        x_shift = 25 if params_size["largeur"].nil?
        y_shift = 25 if params_size["longueur"].nil?
        if orientation == 45
            pos_x+=x_shift
            pos_y-=y_shift
        elsif orientation == 90
            pos_x+=x_shift
            pos_y-=(y_shift*2)
        elsif orientation == 135
            pos_x+=x_shift
            pos_y-=(y_shift*3)
        elsif orientation == 180
            pos_y-=(y_shift*3)
        elsif orientation == 225
            pos_x-=x_shift
            pos_y-=(y_shift*3)
        elsif orientation == 270
            pos_x-=(x_shift*2)
            pos_y-=(y_shift*2)
        elsif orientation == 315
            pos_x-=(x_shift*1.5)
            pos_y-=(y_shift)
        end
        [pos_x, pos_y, 10, 100, "sprites/sword.png", -orientation]
    end

    def rect
        [pos_x, pos_y, 10, 100]
    end
end