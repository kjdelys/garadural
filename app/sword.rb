class Sword
    attr_accessor :orientation, :pos_x, :pos_y, :size, :salle_id, :image, :character

    def initialize(orientation, pos_x, pos_y, size, salle_id, character, params_size={})
        @orientation = 0
        #@orientation = orientation
        @pos_x = pos_x
        @pos_y = pos_y
        @size = size
        @image = define_image(pos_x, pos_y, orientation, @size, params_size)
        @salle_id = salle_id
        @character = character
    end

    def define_image(pos_x, pos_y, orientation, image_size, params_size)

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
        [pos_x, pos_y, 10, image_size, "sprites/sword.png", -orientation]
    end

    def rect
        [pos_x, pos_y, 10, 100]
    end

    def update_sword
        @orientation += 45
        if @orientation < 361
            @image = define_image(pos_x, pos_y, @orientation, @size, {})
            return @image
        else
            return nil
        end
    end

    def collision_points
        sens = case @orientation
            when 0
                [0, 1]
            when 45
                [1/Math.sqrt(2), 1/Math.sqrt(2)]
            when 90
                [1, 0]
            when 135
                [1/Math.sqrt(2), (-1)/Math.sqrt(2)]
            when 180
                [0, -1]
            when 225
                [(-1)/Math.sqrt(2), (-1)/Math.sqrt(2)]
            when 270
                [-1, 0]
            when 315
                [(-1)/Math.sqrt(2), 1/Math.sqrt(2)]
            when 360
                [0, 1]
            end
        
        [
            [@pos_x, @pos_y],
            [@pos_x + (sens[0]*(size/2)), @pos_y + (sens[1]*(size/2))],
            [@pos_x + (sens[0]*size), @pos_y + (sens[1]*size)]
        ]
    end

    def hit_someone(collision_intervalles)
        collision_points.each do |point|
            return point if collision?([point], collision_intervalles) == true
        end
        return [nil, nil]
    end
end