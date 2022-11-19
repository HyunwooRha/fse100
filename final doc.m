brick = ConnectBrick('EVAL');
brick.SetColorMode(3,2);

%%
global key;
InitKeyboard();

defaultSpeed = 100;

spinLength = 2;
spinSpeed = 30;

wallDetectionDistance = 20;

current = 0;
graph  = containers.Map(current, getPath());

green = 0;
blue;
yellow;

test1 = true;
test2 = true;

pickedup = false;
droppedoff = false;

while test1 == true
    checkColors();
    graph(getPath()) = current;
    turn(turnDirection);
    current = current + 1;
    goForward();
    if getColor() == 4
        test1 = false;
    end
end
test1 = false;

function bool = getFront()
    brick.MoveMotor('D', spinSpeed);
    brick.MoveMotor('A', -spinSpeed);
    pause(spinLength);
    bool = getRight();
end

function bool = getLeft()
    distance = brick.UltrasonicDist(3);
    if distance < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end
end
function bool = getRight()
    distance = brick.UltrasonicDist(1);
    if distance < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end    
end
function c = getColor()
    c = brick.ColorCode(4);
end


function list = getPath()
    % return a list of all connections
    % aka spin around to see if there are any connections
    list = [];
    if getLeft()
        list = [list, 'L'];
    end
    if getRight()
        list = [list, 'R'];
    end
    if getFront()
        list = [list, 'F'];
    end
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
    if (getRight == false)
        d = 2;
    elseif (getFront == false)
        d = 1;
    else
        d = 4;
    end
end

function bool = includes(key, list)
    for i = 0:length(list)
        if key == list[]
            bool = true;
        end
    end
    bool = false;
end

function b = find_path(graph, start, finish, paths)
    path = paths + [start];
    if start == finish
        b = path;
    end
    if not graph.has_key(start)
        return;
    end
    for a = 0:length(values(graph, start))
        temp = (graph(start));
        disp(temp(a))
        if includes(temp(a), path) == false
            newpath = find_path(graph, a, finish, path);
            if ifempty(newpath) == false
                b = newpath;
            end
        end
    end
    % original code (doesn't work but kept for the idea)
    % for node in graph[start]
    %     if node not in path
    %         newpath = find_path(graph, node, finish, path);
    %         if newpath
    %             return newpath
    %         end
    %     end
    % end
    return;
end

function goForward()
    if (getNorth == false)
        totalTime = 2;
        for (i = 0:totalTime)
            if (getColor() == 5)
                pause(2);
                brick.MoveMotor('A', defaultSpeed);
                brick.MoveMotor('D', defaultSpeed);
                pause(1);                    
            end
            brick.MoveMotor('A', defaultSpeed);
            brick.MoveMotor('D', defaultSpeed);
            pause(0.1);
        end
        brick.StopAllMotors();
    end
end

function turn(direction)
    if (direction == 1)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
        pause(spinLength);
    elseif (direction == 2)
        brick.MoveMotor('A', spinSpeed);
        brick.MoveMotor('D', -spinSpeed);
        pause(spinLength);
    elseif (direction == 3)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
        pause(spinLength*2);
    elseif (direction == 4)
        brick.MoveMotor('A', spinSpeed);
        brick.MoveMotor('D', -spinSpeed);
        pause(spinLength*2);
    end
end