brick = ConnectBrick('EVAL');
brick.SetColorMode(3,2);
%%
graph = containers.Map(1, [2, 3]);
graph(2) = [3, 4];
graph(3) = [4];
graph(4) = [3];
graph(5) = [6];
graph(6) = [3];
path=[];
find_path(graph, 1, 4, path)

%%
global key;
InitKeyboard();

defaultSpeed = 100;

% note that this is done with the 0.1 seconds (i think)
forwardTime = 30;
gapRed = 0.1;

spinLength = 2;
spinSpeed = 30;

wallDetectionDistance = 20;

current = 0;
graph  = containers.Map();

green = 0;
blue;
yellow;

test1 = true;
test2 = true;

pickedup = false;
droppedoff = false;

curx = 6;
cury = 6;
curDirection = 1;

map(1:11, 1:11) = cells;

while test1 == true
    checkColors();
    saveinfo();
    % graph(current) = getPath();
    turn(turnDirection);
    current = current + 1;
    goForward();
    if getColor() == 4
        test1 = false;
    end
end
test1 = false;



function convert_to_graph()
    for i = 1:11
        for j = 1:11
            if map(i,j).n == 1
                graph(map(i,j).place) = [i,j+1];
            end
            if map(i,j).e == 1
                graph(map(i,j).place) = [i+1,j];
            end
            if map(i,j).s == 1
                graph(map(i,j).place) = [i,j-1];
            end
            if map(i,j).w == 1
                graph(map(i,j).place) = [i-1,j];
            end
        end
    end
end

function saveinfo()
    map(curx,cury).place = current;
    map(curx, cury).n = getFront();
    map(curx, cury).s = true;
    map(curx, cury).e = getRight();
    map(curx, cury).w = getLeft();
end

function bool = getFront()
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

function bool = getLeft()
    turn(3);
    distance = brick.UltrasonicDist(3);
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
    % returns a list of connected nodes
    temp = [];
    if getFront() == false
        temp = [temp, "front"];
    end
    if getRight() == false
        temp = [temp, "right"];
    end
    if getLeft() == false
        temp = [temp, "left"];
    end
    list = temp;
end


function checkColors()
    % check for colors: red, green, blue
    % need to make sure we can break test1 loop by changing the boolean
    % also need to make sure finish is set to current on 
    if getColor == 5
        brick.StopAllMotors();
        pause(2);
        brick.MoveMotor('A', defaultSpeed);
        brick.MoveMotor('D', defaultSpeed);
        pause(1);
        brick.StopAllMotors();
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
    temp = false;
    for i = 0:length(list)
        if key == list[i]
            temp = true;
        end
    end
    if temp == true
        bool = true;
    else
        bool = false;
    end
end

<<<<<<< HEAD
function b = find_path(graph, start, finish, path)
    path = [path, start];
=======
function b = find_path(graph, start, finish, paths)
    path = paths + [start];
>>>>>>> parent of 3112f4a (comments)
    if start == finish
        b = path;
    else
        for i = 1:length(graph(start))
            a = graph(start)
            if includes(a(i), path) == false
                
                b = find_path(graph, a(i), finish, path);
            end
        end
    end
end

<<<<<<< HEAD

=======
>>>>>>> parent of 3112f4a (comments)
function goForward()
    if (getFront() == false)
        for (i = 0:forwardTime)
            if (getColor() == 5)
                brick.StopAllMotors();
                pause(2);
                brick.MoveMotor('A', defaultSpeed);
                brick.MoveMotor('D', defaultSpeed);
                pause(gapRed);
            end
            brick.MoveMotor('A', defaultSpeed);
            brick.MoveMotor('D', defaultSpeed);
            pause(0.1);
        end
        brick.StopAllMotors();
        if curDirection == 1
            cury = cury + 1;
        elseif curDirection == 2
            curx = curx + 1;
        elseif curDirection == 3
            cury = cury - 1;
        elseif curDirection == 4
            curx = curx - 1;
        end
    end
end

function turn(direction)
    curDirection = direction;
    if (direction == 1)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
    elseif (direction == 2)
        brick.MoveMotor('A', spinSpeed);
        brick.MoveMotor('D', -spinSpeed);
    elseif (direction == 3)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
    elseif (direction == 4)
        brick.MoveMotor('A', spinSpeed);
        brick.MoveMotor('D', -spinSpeed);
    end
    pause(spinLength)
    brick.StopAllMotors();
end