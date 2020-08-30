require 'app/lib/map_generator.rb'
require 'app/map.rb'
require 'app/character.rb'
require 'app/player.rb'
require 'app/ennemy.rb'

STEP_SIZE = 10
WIDTH_MAP = 5
HEIGHT_MAP = 5
NBR_FRAGMENTS = (WIDTH_MAP*HEIGHT_MAP)/12
def tick args

  args.state.game_started ||= false
  args.state.map_loaded ||= false
  args.state[:ennemies] ||= []
  args.state.ennemies_loaded ||= false

  args.outputs.labels << [10, 30, args.gtk.current_framerate]
  if args.state.game_started == false
    generate_map()
    args.state.game_started = true
  end

  #initialize screen
  #-player
  args.state.player = Player.new(50, 50, 500, 50, "sprites/icon.png", "3_3") if args.state.player.nil?
  player = args.state.player
  #args.outputs.labels << [500, 30, player.pos_x.to_s + " " + player.pos_y.to_s]

  #-map
  current_salle = 'MAP_' + player.salle_id
  current_map = Object.const_get(current_salle)
  
  
  current_map["rects"].each do |rect|
    args.outputs.solids << rect
  end
  current_map["borders"].each do |border|
    args.outputs.solids << border
  end

  if args.state.ennemies_loaded == false
    current_map["ennemies"].each do |ennemy_prop|
      ennemy = Ennemy.new(ennemy_prop[0], ennemy_prop[1], ennemy_prop[2], ennemy_prop[3], ennemy_prop[4], current_salle.gsub('MAP_', ''))
      args.state[:ennemies] << ennemy
    end
    args.state.ennemies_loaded = true
  end

  args.state[:ennemies].each do |ennemy|
    ennemy.move([player.pos_x, player.pos_y])
    args.outputs.sprites << ennemy.image
  end
  
  args.state.map_loaded = true
  
  unless current_map["fragment"].nil?
    args.outputs.sprites << current_map["fragment"]
  end
  args.outputs.sprites << player.image

   
  #move player

  if args.inputs.keyboard.right && args.inputs.keyboard.up
    player.move_x(STEP_SIZE)
    player.move_y(STEP_SIZE)
    player.change_orientation(45)
  elsif args.inputs.keyboard.right && args.inputs.keyboard.down
    player.move_x(STEP_SIZE)
    player.move_y(-STEP_SIZE)
    player.change_orientation(135)
  elsif args.inputs.keyboard.right
    player.move_x(STEP_SIZE)
    player.change_orientation(90)
  end

  if args.inputs.keyboard.left && args.inputs.keyboard.up
    player.move_x(-STEP_SIZE)
    player.move_y(STEP_SIZE)
    player.change_orientation(315)
  elsif args.inputs.keyboard.left && args.inputs.keyboard.down
    player.move_x(-STEP_SIZE)
    player.move_y(-STEP_SIZE)
    player.change_orientation(225)
  elsif args.inputs.keyboard.left
    player.move_x(-STEP_SIZE)
    player.change_orientation(270)
  end

  if args.inputs.keyboard.up && !args.inputs.keyboard.left && !args.inputs.keyboard.right
    player.move_y(STEP_SIZE)
    player.change_orientation(0)
  end
  if args.inputs.keyboard.down && !args.inputs.keyboard.left && !args.inputs.keyboard.right
    player.move_y(-STEP_SIZE)
    player.change_orientation(180)
  end

  if player.position != [0,0]
    player.change_salle(player.position)
    next_salle = 'MAP_' + player.salle_id
    player.teleport([500, 500])
    args.state[:ennemies] = []
    args.state.ennemies_loaded = false
  end

end