class Character

    attr_accessor :longueur, :largeur, :pos_x,:pos_y, :image, :salle_id, :orientation, :pv, :can_move, :can_attack
    def initialize(longueur, largeur, pos_x, pos_y, image, salle_id)
        @longueur = longueur
        @largeur = largeur
        @pos_x = pos_x
        @pos_y = pos_y
        @orientation = 180
        @image = [pos_x, pos_y, longueur, largeur, image, @orientation]
        @salle_id = salle_id
        @pv = 100
        @id = rand(10000)
        @can_move = true
        @can_attack = true
    end

    def serialize
        { 
            longueur: @longueur,
            largeur: @largeur,
            pos_x: @pos_x,
            pos_y: @pos_y, 
            orientation: @orientation,
            image: @image,
            salle_id: @salle_id,
            pv: @pv       
        }
    end
    
    def collision_points(x=0,y=0)
        [
            [@pos_x+x, @pos_y+y],
            [@pos_x+(@largeur/2)+x, @pos_y+y],
            [@pos_x+x+@largeur, @pos_y+y],
            [@pos_x+x, @pos_y+y+@longueur],
            [@pos_x+x, @pos_y+y+(@longueur/2)],
            [@pos_x+x+(@largeur/2), @pos_y+y+(@longueur/2)],
            [@pos_x+x+@largeur, @pos_y+y+@longueur],
            [@pos_x+x+@largeur, @pos_y+y+(@longueur/2)],
            [@pos_x+x+(@largeur/2), @pos_y+y+@longueur]
        ]
    end

    def image_size
        return @image[0...-2]
    end

    def image_rectangle
        return [@pos_x, @pos_y, @pos_x+@largeur, @pos_y+@longueur]   
    end

    def class_id
        self.subclass_name + "_" + @id.to_s
    end

    def to_s
        serialize.to_s
    end
    
    def inspect
        serialize.to_s
    end
    
    def move_x(x, collision_inter, auto=false, direction=1, force_auto=false, attempt=0)
        unless collision_inter.class.to_s.include?("String")
            puts("PATCH WORKED : " + collision_inter.class.to_s)
            return
        end
        collision_points = collision_points(x, 0)
        inside = collision?(collision_points, collision_inter)
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

    def move_y(y, collision_inter, auto=false, direction=1, force_auto=false, attempt=0)
        unless collision_inter.class.to_s.include?("String")
            puts("PATCH WORKED : " + collision_inter.class.to_s)
            return
        end
        collision_points = collision_points(0, y)
        inside = collision?(collision_points, collision_inter)
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
        if [0, 180].include? orientation
            @image[5] = orientation
        else
            @image[5] = 360 - orientation
        end
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
        Bullet.new(@orientation, @pos_x+(@largeur/2), @pos_y+(@longueur/2), 25, @salle_id)
    end

    def use_sword
        return Sword.new(@orientation, central_point[0], central_point[1], 20, @salle_id, self)
    end

    def central_point
        collision_points[5]
    end

    def change_pv(hp)
        @pv += hp
    end

    def is_dead?
        @pv < 0 ? true : false 
    end

end