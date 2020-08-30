require 'app/lib/map_generator.rb'
require 'app/map.rb'
require 'app/character.rb'
require 'app/player.rb'

STEP_SIZE = 10
WIDTH_MAP = 10
HEIGHT_MAP = 10
NBR_FRAGMENTS = (WIDTH_MAP*HEIGHT_MAP)/12
def tick args

  args.state.game_started ||= false
  args.state.map_loaded ||= false

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
  end

end