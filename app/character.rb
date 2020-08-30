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
        map_salle = Object.const_get("MAP_" + @salle_id.to_s)

        inside = false

        map_salle["collision"].each do |pos_rect|
            #CETTE BOUCLE N'EST PAS TERRIBLE. Voir si on peut faire une seule condition sans boucle
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

end