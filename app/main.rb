require 'app/character.rb'
require 'app/player.rb'
STEP_SIZE = 10
def tick args

  args.outputs.labels << [10, 30, args.gtk.current_framerate]
  
  #initialize screen
  #-map
  args.outputs.solids << [0, 0, 500, 500, 0, 0, 255, 128]
  #-player
  args.state.player = Player.new(50, 50, 500, 50, "sprites/icon.png") if args.state.player.nil?
  player = args.state.player
  args.outputs.sprites << player.image
  args.outputs.labels << [500, 30, player.pos_x.to_s + " " + player.pos_y.to_s]

  #move player
  args.state.player.move_x(-STEP_SIZE) if args.inputs.keyboard.left
  args.state.player.move_x(STEP_SIZE) if args.inputs.keyboard.right
  args.state.player.move_y(STEP_SIZE) if args.inputs.keyboard.up
  args.state.player.move_y(-STEP_SIZE) if args.inputs.keyboard.down

  # if args.inputs.keyboard.key_down.left
  #   args.outputs.labels  << [500, 580, "pd", 4, 0, 88, 41, 0, 255, 'manaspc.ttf']
  # end
end