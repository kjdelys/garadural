def collision?(points, collision_inter)
    points.each do |x, y|
        return true if eval(collision_inter)
    end
    return false
end

def collision_intervalles(solid_points)
    statement = ''
    solid_points.each do |sp|
        statement += '((' + sp[0].to_s + '..' + (sp[0]+sp[2]).to_s + ').include?(x) && (' + sp[1].to_s + '..' + (sp[1]+sp[3]).to_s + ').include?(y)) ||' 
    end
    return statement.delete_suffix(' ||')
end
