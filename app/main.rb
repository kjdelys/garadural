require 'app/lib/map_generator.rb'
require 'app/lib/helper.rb'
require 'app/map.rb'
require 'app/character.rb'
require 'app/player.rb'
require 'app/ennemy.rb'
require 'app/bullet.rb'
require 'app/sword.rb'

STEP_SIZE = 10
WIDTH_MAP = 5
HEIGHT_MAP = 5
NBR_FRAGMENTS = (WIDTH_MAP*HEIGHT_MAP)/12
def tick args

  args.state.game_started ||= false
  args.state.map_loaded ||= false
  args.state[:ennemies] ||= []
  args.state.ennemies_loaded ||= false
  args.state[:bullets] ||= []
  args.state[:swords] ||= []
  args.state[:collision_intervalles] ||= ''

  
  if args.state.game_started == false
    generate_map()
    args.state.game_started = true
  end
  
  #initialize screen
  #-player
  args.state.player = Player.new(50, 50, 500, 50, "sprites/main.png", "3_3") if args.state.player.nil?
  player = args.state.player
  #args.outputs.labels << [500, 30, player.pos_x.to_s + " " + player.pos_y.to_s]
  player.collision_points.each do |cp|
    args.outputs.labels << [cp[0], cp[1], "X", 255, 0, 0]
  end

  args.outputs.labels << [50, 50, args.gtk.current_framerate.to_s + " " + player.salle_id]

  #-map
  current_salle = 'MAP_' + player.salle_id
  current_map = Object.const_get(current_salle)


  current_map["rects"].each do |rect|
    args.outputs.solids << rect
  end
  current_map["borders"].each do |border|
    args.outputs.solids << border
  end

  args.state[:bullets].each do |bullet|
    args.outputs.solids << bullet.rect
  end


  if args.state.ennemies_loaded == false
    current_map["ennemies"].each do |ennemy_prop|
      ennemy = Ennemy.new(ennemy_prop[0], ennemy_prop[1], ennemy_prop[2], ennemy_prop[3], ennemy_prop[4], current_salle.gsub('MAP_', ''))
      ennemy.aggressive = true
      args.state[:ennemies] << ennemy
    end
    args.state.ennemies_loaded = true
  end

  args.state[:ennemies].each do |ennemy|
    if ennemy.aggressive == true
      attack = ennemy.attack(player.collision_points, args.state[:collision_intervalles])
      ennemy.aggressive = false if attack == "stop"
    else
      if ennemy.can_see?(player) == true
        ennemy.aggressive = true 
      end
    end
    args.outputs.sprites << ennemy.image
  end
  
  args.state.map_loaded = true
  
  unless current_map["fragment"].nil?
    args.outputs.sprites << current_map["fragment"]
  end
  args.outputs.sprites << player.image

  args.state[:swords].each do |sword|
    args.outputs.sprites << sword.image
  end

  unless current_map["statue"].nil?
    args.outputs.solids << current_map["statue"]
  end
  
  if args.state[:collision_intervalles] == ''
    args.state[:collision_intervalles] = collision_intervalles(current_map["collision"])
  end
   
  #viser
  if args.inputs.keyboard.key_down.exclamation_point
    if player.orientation != 315
      player.change_orientation(player.orientation+45) 
    elsif player.orientation == 315
      player.change_orientation(0)
    end
  end
  #move player
  if args.inputs.keyboard.right && args.inputs.keyboard.up
    player.move_x(STEP_SIZE, args.state[:collision_intervalles])
    player.move_y(STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(45)
  elsif args.inputs.keyboard.right && args.inputs.keyboard.down
    player.move_x(STEP_SIZE, args.state[:collision_intervalles])
    player.move_y(-STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(135)
  elsif args.inputs.keyboard.right
    player.move_x(STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(90)
  end

  if args.inputs.keyboard.left && args.inputs.keyboard.up
    player.move_x(-STEP_SIZE, args.state[:collision_intervalles])
    player.move_y(STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(315)
  elsif args.inputs.keyboard.left && args.inputs.keyboard.down
    player.move_x(-STEP_SIZE, args.state[:collision_intervalles])
    player.move_y(-STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(225)
  elsif args.inputs.keyboard.left
    player.move_x(-STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(270)
  end

  if args.inputs.keyboard.up && !args.inputs.keyboard.left && !args.inputs.keyboard.right
    player.move_y(STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(0)
  end
  if args.inputs.keyboard.down && !args.inputs.keyboard.left && !args.inputs.keyboard.right
    player.move_y(-STEP_SIZE, args.state[:collision_intervalles])
    player.change_orientation(180)
  end

  if args.inputs.keyboard.key_down.space
    args.state[:bullets] << player.shoot
  end

  if args.inputs.keyboard.key_down.escape
    args.state[:swords] << player.use_sword
  end

  #update bullets
  bullets = args.state[:bullets]
  args.state[:bullets] = []
  bullets.each do |bullet|
    has_moved = (bullet.move_on(args.state[:collision_intervalles]) && bullet.move_on(collision_intervalles(args.state[:ennemies].map{|ennemy| ennemy.image_size})))
    if has_moved
      args.state[:bullets] << bullet 
    else
      ennemies = args.state[:ennemies]
      (ennemies+[player]).each do |character|
        if [bullet.last_pos_x, bullet.last_pos_y].inside_rect? character.image_rectangle
          character.change_pv(-10)
          if character != player
            character.aggressive = true
          end
          if character.is_dead?
            if character == player
              puts("PARTIE TERMINE")
            else
              args.state[:ennemies].delete(character)
            end
          end
          break
        end
      end
    end
  end



  player_position = player.position
  if player_position != [0,0]
    player.change_salle(player.position)
    next_salle = 'MAP_' + player.salle_id
    if player_position == [1, 0]
      player.teleport([20, player.pos_y])
    elsif player_position == [0, 1]
      player.teleport([player.pos_x, 690])
    elsif player_position == [-1, 0]
      player.teleport([1240, player.pos_y])
    elsif player_position == [0, -1]
      player.teleport([player.pos_x, 20])
    end
    
    args.state[:bullets] = []
    args.state[:ennemies] = []
    args.state.ennemies_loaded = false
    args.state[:collision_intervalles] = ''
  end

end