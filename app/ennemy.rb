class Ennemy < Character

    def move(player_pos)

        vitesse = STEP_SIZE/2
        player_x = player_pos[0]
        player_y = player_pos[1]

        haut = ((@pos_y > player_y) ? -1 : 1)
        gauche = ((@pos_x > player_x) ? -1 : 1)
        if (@pos_y - player_y).abs < 40
            haut = 0
        end
        if (@pos_x - player_x).abs < 40
            gauche = 0
        end
        move_y(haut*vitesse)
        move_x(gauche*vitesse)
    end
end