current = 0;
graph  = containers.Map(current, getPath());

green = 0;
blue;

test1 = true;
test2 = true;

pickedup = false;
droppedoff = false;

function getPath()
    % return a list of all connections
    % aka spin around to see if there are any connections
end

function checkColors()
    % check for colors: red, green, blue
    % need to make sure we can break test1 loop by changing the boolean
    % also need to make sure finish is set to current on 
end

function d = turnDirection()
    if (!getEast):
        d = 2;
    elseif (!getNorth):
        d = 1;
    else:
        d = 4;
    end
    return d;
end

function bool = getNorth()
    
    return(bool);
end
function bool = getEast()
    
    return(bool);
end
function bool = getSouth()
    
    return(bool);
end
function bool = getWest()
    
    return(bool);
end

function c = getColor()
    
    return(c);
end


function path = find_path(graph, start, finish, paths=[])
    path = paths + [start]
    if start == finish
        return path
    end
    if not graph.has_key(start)
        return None
    end
    for node in graph[start]
        if node not in path
            newpath = find_path(graph, node, finish, path)
            if newpath
                return newpath
            end
        end
    end
    return None
end

while test1
    checkColors();
    graph[current] = getPath();
    turn(turnDirection);
    current = current + 1;
    goForward();

end

while test2
    % follow directions given by find_path

end