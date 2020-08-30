def generate_map
    File.open("mygame/app/map.rb", "w")
    cases = {}
    (1..WIDTH_MAP).each do |x|
        (1..HEIGHT_MAP).each do |y|
            mapper = {
                "background" => background,
                "rects" => [],
                "collision" => []
            }
            
            map_nord = "MAP_" + x.to_s + "_" + (y-1).to_s
            map_sud = "MAP_" + x.to_s + "_" + (y+1).to_s
            map_ouest = "MAP_" + (x-1).to_s + "_" + y.to_s
            map_est = "MAP_" + (x+1).to_s + "_" + y.to_s
            opts = {}
            
            unless cases[map_nord].nil?
                cases[map_nord]["borders"].first(2).each do |border|
                    if opts["nord"].nil?
                        opts["nord"] = [border]
                    else
                        opts["nord"] << border
                    end
                end
            end

            unless cases[map_sud].nil?
                cases[map_sud]["borders"].first(4).last(2).each do |border|
                    if opts["sud"].nil?
                        opts["sud"] = [border]
                    else
                        opts["sud"] << border
                    end
                end
            end

            unless cases[map_ouest].nil?
                cases[map_ouest]["borders"].last(4).first(2).each do |border|
                    if opts["ouest"].nil?
                        opts["ouest"] = [border]
                    else
                        opts["ouest"] << border
                    end
                end
            end

            unless cases[map_est].nil?
                cases[map_est]["borders"].last(2).each do |border|
                    if opts["est"].nil?
                        opts["est"] = [border]
                    else
                        opts["est"] << border
                    end
                end
            end
            
            mapper["borders"] = borders
            mapper["borders"].each do |border|
                mapper["collision"] << border
            end

            if fragment? == true
                mapper["fragment"] = [50, 50, 50, 50,"sprites/coffre.png"]
                mapper["collision"] << mapper["fragment"]
            end

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
        pos_x = rand(500)
        largeur_x = rand(200)
        largeur_x = 80 if largeur_x < 80
        res << [0, 700, pos_x, longueur]
        res << [pos_x+largeur_x, 700, 1280-(pos_x+largeur_x), longueur]
    end

    #sud
    if opts["sud"].nil?
        pos_x = rand(500)
        largeur_x = rand(200)
        largeur_x = 80 if largeur_x < 80
        res << [0, 0, pos_x, longueur]
        res << [pos_x+largeur_x, 0, 1280-(pos_x+largeur_x), longueur]
    end

    #ouest
    if opts["ouest"].nil?
        pos_y = rand(500)
        longueur_y = rand(200)
        longueur_y = 80 if largeur_x < 80
        res << [0, 0, largeur, longueur_y]
        res << [0, pos_y+longueur_y, largeur, 720-(pos_y+longueur_y)]
    end
    
    #est
    if opts["est"].nil?
        pos_y = rand(500)
        longueur_y = rand(200)
        longueur_y = 80 if largeur_x < 80
        res << [1280-largeur, 0, largeur, longueur_y]
        res << [1280-largeur, pos_y+longueur_y, largeur, 720-(pos_y+longueur_y)]
    end

    res
end

def fragment?
    rand(NBR_FRAGMENTS) == 0
end