class Character

    attr_accessor :longueur, :largeur, :pos_x,:pos_y, :image
    def initialize(longueur, largeur, pos_x, pos_y, image)
        @longueur = longueur
        @largeur = largeur
        @pos_x = pos_x
        @pos_y = pos_y
        @image = [pos_x, pos_y, longueur, largeur, image]
    end

    def move_x(x)
        unless [@pos_x+x, @pos_y].inside_rect? [0, 0, 500, 500]
            @pos_x += x
            @image[0] += x
        end
    end

    def move_y(y)
        unless [@pos_x, @pos_y+y].inside_rect? [0, 0, 500, 500]
            @pos_y += y
            @image[1] += y    
        end
    end

end