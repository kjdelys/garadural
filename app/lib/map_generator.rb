def generate_map
    File.open("mygame/app/map.rb", "w")
    cases = {}

    position_statue = [(rand(WIDTH_MAP) + 1), (rand(HEIGHT_MAP) + 1)]

    (1..WIDTH_MAP).each do |x|
        (1..HEIGHT_MAP).each do |y|
            mapper = {
                "background" => background,
                "rects" => rectangles,
                "collision" => []
            }

            if position_statue == [x, y]
                mapper["statue"] = create_statue?
            end
            
            
            mapper["borders"] = borders
            (mapper["borders"]+mapper["rects"]).each do |border|
                mapper["collision"] << border
            end
            mapper["collision"] << mapper["statue"][0...-4] if mapper["statue"]

            if fragment? == true
                mapper["fragment"] = [50, 50, 50, 50,"sprites/coffre.png"]
                mapper["collision"] << mapper["fragment"]
            end
            
            mapper["ennemies"] = ennemies(x+y)

            cases["MAP_"+x.to_s+"_"+y.to_s] = mapper
            File.open("mygame/app/map.rb", "a") {|f| f.write('MAP_' + x.to_s + '_' + y.to_s + ' = ' + mapper.to_s) }
            File.open("mygame/app/map.rb", "a") {|f| f.write("\n")}
        end
    end
end


def background
    [0, 0, 1280, 720, "sprites/background.jpeg"]
end

def borders(opts={})
    largeur = 20
    longueur = 20

    directions = ["nord", "sud", "est", "ouest"]
    res = []

    directions.each do |direction|
        if opts[direction]
            opts[direction].each do |dir|
                res << dir 
            end
        end
    end

    #nord
    if opts["nord"].nil?
        pos_x = 560
        largeur_x = 160
        # pos_x = rand(500)
        # largeur_x = rand(200)
        # largeur_x = 80 if largeur_x < 80
        res << [0, 700, pos_x, longueur]
        res << [pos_x+largeur_x, 700, 1280-(pos_x+largeur_x), longueur]
    end

    #sud
    if opts["sud"].nil?
        # pos_x = rand(500)
        # largeur_x = rand(200)
        # largeur_x = 80 if largeur_x < 80
        res << [0, 0, pos_x, longueur]
        res << [pos_x+largeur_x, 0, 1280-(pos_x+largeur_x), longueur]
    end

    #ouest
    if opts["ouest"].nil?
        pos_y = 280
        longueur_y = 160
        # pos_y = rand(500)
        # longueur_y = rand(200)
        # longueur_y = 80 if largeur_x < 80
        res << [0, 0, largeur, longueur_y]
        res << [0, pos_y+longueur_y, largeur, 720-(pos_y+longueur_y)]
    end
    
    #est
    if opts["est"].nil?
        pos_y = 280
        longueur_y = 160
        # pos_y = rand(500)
        # longueur_y = rand(200)
        # longueur_y = 80 if largeur_x < 80
        res << [1280-largeur, 0, largeur, longueur_y]
        res << [1280-largeur, pos_y+longueur_y, largeur, 720-(pos_y+longueur_y)]
    end

    res
end

def fragment?
    rand(NBR_FRAGMENTS) == 0
end

def ennemies(difficulty)
    res = []
    nbr_ennemies = rand(difficulty)/2
    (1..nbr_ennemies).each do |ennemy|
        res << [50, 50, rand(1280), rand(700), "sprites/icon.png"]
    end
    res
end

def rectangles
    res = []
    (1..rand(20)).each do |rect|
        res_element = [rand(1280), rand(720), rand(100), rand(100)]
        if ((560..760).to_a & (res_element[0]..(res_element[0]+res_element[2])).to_a) != []
            if res_element[1] > 620
                res_element[1] = 620
            elsif res_element[1] < 100
                res_element[1] = 100
            end
        elsif ((280..440).to_a & (res_element[1]..(res_element[1]+res_element[3])).to_a) != []
            if res_element[0] > 1180
                res_element[0] = 1180
            elsif res_element[0] < 100
                res_element[0] = 100
            end
        end
        res << res_element
    end
    res
end

def create_statue?
    return [400, 200, 200, 100, 50, 50, 255, 128]
end



