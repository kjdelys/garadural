require 'app/character.rb'
def tick args

    #initialize screen
    args.state.player = Character.new(50, 50, 50, 50, "sprites/icon.png") if args.state.player.nil?
    player = args.state.player
    args.outputs.sprites << player.image


    #move player
    args.state.player.move_x(-10) if args.inputs.keyboard.left
    args.state.player.move_x(10) if args.inputs.keyboard.right
    args.state.player.move_y(10) if args.inputs.keyboard.up
    args.state.player.move_y(-10) if args.inputs.keyboard.down


  # if args.inputs.keyboard.key_down.left
  #   args.outputs.labels  << [500, 580, "pd", 4, 0, 88, 41, 0, 255, 'manaspc.ttf']
  # end
end