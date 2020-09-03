class Character

    attr_accessor :longueur, :largeur, :pos_x,:pos_y, :image, :salle_id, :orientation, :pv
    def initialize(longueur, largeur, pos_x, pos_y, image, salle_id)
        @longueur = longueur
        @largeur = largeur
        @pos_x = pos_x
        @pos_y = pos_y
        @orientation = 180
        @image = [pos_x, pos_y, longueur, largeur, image, @orientation]
        @salle_id = salle_id
        @pv = 100
    end

    def collision_points
        [
            [@pos_x, @pos_y],
            [@pos_x+(@largeur/2), @pos_y],
            [@pos_x+@largeur, @pos_y],
            [@pos_x, @pos_y+@longueur],
            [@pos_x, @pos_y+(@longueur/2)],
            [@pos_x+(@largeur/2), @pos_y+(@longueur/2)],
            [@pos_x+@largeur, @pos_y+@longueur],
            [@pos_x+@largeur, @pos_y+(@longueur/2)],
            [@pos_x+(@largeur/2), @pos_y+@longueur]
        ]
    end

    def move_x(x, auto=false, direction=1, force_auto=false, attempt=0)
        map_salle = Object.const_get("MAP_" + @salle_id.to_s)

        inside = false

        map_salle["collision"].each do |pos_rect|
            #CETTE BOUCLE N'EST PAS TERRIBLE. Voir si on peut faire une seule condition sans boucle
            #LES COLLISIONS SONT BUGUEES, elles n'utilisent qu'un point du personnage, et pas son corps entier.
            collision_points.each do |cp|
                if [cp[0]+x, cp[1]].inside_rect? pos_rect
                    inside = true
                    break
                end
            end
        end

        unless inside
            @pos_x += x
            @image[0] += x
        end

        if (inside == true && auto == true) || force_auto == true
            if attempt == 5 || rand(10) == 0
                return "stop"
            end
            direction = (-1)* direction if rand(5) == 0
            move_y(direction*x, true, direction, true, attempt+1)        
        end
    end

    def move_y(y, auto=false, direction=1, force_auto=false, attempt=0)
        map_salle = Object.const_get("MAP_" + @salle_id)

        inside = false

        map_salle["collision"].each do |pos_rect|
            #CETTE BOUCLE N'EST PAS TERRIBLE. Voir si on peut faire une seule condition sans boucle
            #LES COLLISIONS SONT BUGUEES, elles n'utilisent qu'un point du personnage, et pas son corps entier.
            collision_points.each do |cp|
                if [cp[0], cp[1]+y].inside_rect? pos_rect
                    inside = true
                    break
                end
            end
        end

        unless inside
            @pos_y += y
            @image[1] += y
        end

        if (inside == true && auto == true) || force_auto == true
            if attempt == 5 || rand(10) == 0
                return "stop"
            end
            direction = (-1)* direction if rand(5) == 0
            move_x(direction*y, true, direction, true, attempt+1)       
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

    def change_orientation(orientation)
        @orientation = orientation
        @image[5] = orientation
    end

    def can_see?(character)
        map_salle = Object.const_get("MAP_" + @salle_id)
        character_pos_x = character.pos_x
        character_pos_y = character.pos_y
        nbr_points = 50
        (2..nbr_points-1).each do |k|
            map_salle["collision"].each do |pos_rect|
                if [k*(character_pos_x + @pos_x)/nbr_points, k*(character_pos_y + @pos_y)/nbr_points].inside_rect? pos_rect
                    return false
                end
            end
        end
        return true
    end

    def shoot
        Bullet.new(@orientation, @pos_x, @pos_y, 25)
    end
end