brick = ConnectBrick('EVAL');
brick.SetColorMode(3,2);

%%

blockDistance = 10;
stepDistance  = 1;
defaultSpeed = 100;

wallDetectionDistance = 20;

spinSpeed = 30;
spinDelay = 0.1;

global key;
InitKeyboard();

current = 0;
graph  = containers.Map(current, getPath());

green = 0;
blue;
yellow;

test1 = true;
test2 = true;

pickedup = false;
droppedoff = false;


function getFront()
    totalSpin = 0;
    while totalSpin > 0
        brick.MoveMotor('D', spinSpeed);
        brick.MoveMotor('A', -spinSpeed);
        totalSpin = totalSpin - spinDelay;
        pause(spinDelay);
    end
    
end

function bool = getLeft()
    distance = brick.UltrasonicDist(3);
    if distance < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end
    return(bool);
end
function bool = getRight()
    distance = brick.UltrasonicDist(1);
    if distance < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end    
    return(bool);
end
function c = getColor()
    c = brick.ColorCode(4);
    return(c);
end


function list = getPath()
    % return a list of all connections
    % aka spin around to see if there are any connections
    if getLeft()
        list = [list, 'L'];
    end
    if getRight()
        list = [list, 'R'];
    end
    if getFront()
        list = [list, 'F'];
    end
    return list;
end


function checkColors()
    % check for colors: red, green, blue
    % need to make sure we can break test1 loop by changing the boolean
    % also need to make sure finish is set to current on 
    if getColor == 5
        pause(1);
        brick.MoveMotor('A', 500)
        brick.MoveMotor('D', 500)
    end
    if test1 == true
        if getColor == 2
            blue = current;
        end
        if getColor == 3
            green = current;
        end
    end
end

function d = turnDirection()
    if (!getRight):
        d = 2;
    elseif (!getFront):
        d = 1;
    else:
        d = 4;
    end
    return d;
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

function goForward()
    toggleRed = false;
    if (!getNorth):
        cury = cury + 1;
        for (i = 1:stepSize:blockDistance):
            % need to change the 1 to the correct color so condition is for "red"
            if (getColor == 5):
                pause(2);
                brick.MoveMotor('A', 500)
                brick.MoveMotor('D', 500)
            end
            brick.MoveMotor('A', defaultSpeed)
            brick.MoveMotor('D', defaultSpeed)
        end

    end
end

while test1
    checkColors();
    graph[current] = getPath();
    turn(turnDirection);
    current = current + 1;
    goForward();
    if getColor == 4
        test1 = false;
    end
end
test1 = false