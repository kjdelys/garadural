class Ennemy < Character
    RECOVERY_TIME = 30
    attr_accessor :last_pos, :attempt, :aggressive

    def subclass_name
        "Ennemy"
    end

    def follow(player_pos, collision_intervalles)

        vitesse = STEP_SIZE/2
        player_x = player_pos[0][0]
        player_y = player_pos[0][1]

        haut = ((@pos_y > player_y) ? -1 : 1)
        gauche = ((@pos_x > player_x) ? -1 : 1)
        player_pos.each do |player_x, player_y|
            if (@pos_y - player_y).abs < 40
                haut = 0
            end
            if (@pos_x - player_x).abs < 40
                gauche = 0
            end
        end
        move_y(haut*vitesse, collision_intervalles, force_move?)
        move_x(gauche*vitesse, collision_intervalles, force_move?)
    end

    def sword_attack(player)
        if (@pos_x - player.central_point[0]).abs < 80 && (@pos_y - player.central_point[1]).abs < 80
            true
        else
            false
        end
    end

    def force_move?
        (rand(3) == 1)
    end

end