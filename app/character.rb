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
        @pos_x += x
        @image[0] += x
    end

    def move_y(y)
        @pos_y += y
        @image[1] += y
    end

end