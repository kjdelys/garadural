class Character

    attr_accessor :longueur, :largeur, :pos_x,:pos_y, :image, :salle_id
    def initialize(longueur, largeur, pos_x, pos_y, image, salle_id)
        @longueur = longueur
        @largeur = largeur
        @pos_x = pos_x
        @pos_y = pos_y
        @image = [pos_x, pos_y, longueur, largeur, image]
        @salle_id = salle_id
    end

    def move_x(x)
        map_salle = Object.const_get("MAP_" + @salle_id.to_s)

        inside = false

        map_salle["collision"].each do |pos_rect|
            #CETTE BOUCLE N'EST PAS TERRIBLE. Voir si on peut faire une seule condition sans boucle
            #LES COLLISIONS SONT BUGUEES, elles n'utilisent qu'un point du personnage, et pas son corps entier.
            if [@pos_x+x, @pos_y].inside_rect? pos_rect
                inside = true
                break
            end
        end

        unless inside
            @pos_x += x
            @image[0] += x
        end
    end

    def move_y(y)
        map_salle = Object.const_get("MAP_" + @salle_id)

        inside = false

        map_salle["collision"].each do |pos_rect|
            #CETTE BOUCLE N'EST PAS TERRIBLE. Voir si on peut faire une seule condition sans boucle
            #LES COLLISIONS SONT BUGUEES, elles n'utilisent qu'un point du personnage, et pas son corps entier.
            if [@pos_x, @pos_y+y].inside_rect? pos_rect
                inside = true
                break
            end
        end

        unless inside
            @pos_y += y
            @image[1] += y
        end
    end

    def change_salle(position)
        x, y = @salle_id.split("_")
        x = x.to_i
        y = y.to_i
        
        if position[0] != 0
            if (position[0] + x >= 1) && (position[0] + x <= WIDTH_MAP)
                new_position = [position[0] + x, y]
            elsif position[0] + x == 0
                new_position = [WIDTH_MAP, y]
            elsif position[0] + x == WIDTH_MAP + 1
                new_position = [1, y]
            end
        end
        
        if position[1] != 0
            if (position[1] + y >= 1) && (position[1] + y <= HEIGHT_MAP)
                new_position = [x, position[1] + y]
            elsif position[1] + y == 0
                new_position = [x, HEIGHT_MAP]
            elsif position[1] + y == HEIGHT_MAP + 1
                new_position = [x, 1]
            end
        end
        @salle_id = new_position.join("_")
    end

    def teleport(position)
        @pos_x = position[0]
        @pos_y = position[1]
        @image[0] = @pos_x
        @image[1] = @pos_y
    end
end