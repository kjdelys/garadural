class Ennemy < Character
    attr_accessor :last_pos, :attempt, :aggressive

    def subclass_name
        "Ennemy"
    end

    def attack(player_pos, collision_intervalles)

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

    def force_move?
        (rand(3) == 1)
    end

end