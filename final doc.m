% setup
brick = ConnectBrick('EVAL');
brick.SetColorMode(4, 2);
brick.ColorCode(4);
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

% sets up the key inputs
global key;
InitKeyboard();

% default moving speed for moters
defaultSpeed = 100;

% how long the robot will move forward for
% note that this is done with the 0.1 seconds (i think)
forwardTime = 30;

% how long the robot will keep going forward to pass through the red
gapRed = 0.1;

% how long to spin for a 90 degree turn
spinLength = 0.7;
% how fast to spin for a 90 degree turn
spinSpeed = 30;

% cutoff distance when checking for a wall using distance sensors
wallDetectionDistance = 0.2;

% current is used as a counter variable
% used to label a 'block' as a number based on the order it was visited
current = 0;

% sets up a dictionary/hashmap to store the blocks
% this will be updated and filled in at once instead of being filled in proactively
graph  = containers.Map();

% keeps track of where each color is based on block number(block number is kept track by 'current' variabel)
green = current;
blue = "";
yellow = "";

% used for while loops so that the same code will be run multiple times
% NOTE THAT THERE WILL BE MORE 'TEST' VARIABLES BECAUSE NOT EVERYTHING CAN BE DONE IN ONE WHILE LOOP
test1 = true;
test2 = true;
test3 = true;
test4 = true;

% used to keep track of the pickup and dropped off state of the robot
pickedup = false;
droppedoff = false;

% current block position of the robot. this is updated proactively
curx = 6;
cury = 6;
% current direction the robot is facing. this is updated proactively
curDirection = 1;

% creates an 11x11 matrix as a map of the maze
% this is used to update 'graph' variable
map(1:11, 1:11) = cells;


% main loops
while test1 == true
    % we check the color of the current block and update the variables accordingly
    checkColors(brick, green, blue, yellow);
    % saves the current block's info into the map matrix
    saveinfo(map, curx, cury, current, brick, wallDetectionDistance, spinSpeed, spinLength, curDirection);
    % turns the robot to face it so it follows the right wall
    turn(brick, turnDirection(brick, wallDetectionDistance), spinSpeed, spinLength, curDirection);
    % robot moves forward and adds the counter variable 'current' by 1
    goForward(brick, curx, cury, wallDetectionDistance, curDirection);
    current = current + 1;
    % checks if the robot has reached the requirement for this test
    if brick.ColorCode(4) == 2
        test1 = false;
    end
end

while test2
    % adds delay to prevent overdoing sensors.
    pause(.05);
    % makes color sensor and you can call 'color' as keyword returning an
    % int from 0-7
    color = brick.ColorCode(3);
    % displays the int value of the color
    disp(color)
    % keybinds
    switch key
        % arrow keys to move, z and x for clamps
        case 'uparrow'
            disp(key)
            brick.MoveMotor('A', 500)
            brick.MoveMotor('D', 500)
        case 'downarrow'
            disp(key)
            brick.MoveMotor('A', -150);
            brick.MoveMotor('D', -150);
        case 'leftarrow'
            disp(key)
            brick.MoveMotor('D', 500);
            brick.MoveMotor('A', -500);
        case 'rightarrow'
            disp(key)
            brick.MoveMotor('A', 500);
            brick.MoveMotor('D', -500);
        case 'z'
            % closes clamp
            disp(key)
            brick.MoveMotor('B', -50);
        case 'x'
            % opens clamp
            brick.MoveMotor('B', 50);

        case 'q'
            % exits loop
            disp(key)
            test2 = false;
        otherwise
            % change Coast to 'Brake' for a break effect
            brick.StopAllMotors('Coast');
            
    end
    
end


while test3 == true
    % we check the color of the current block and update the variables accordingly
    checkColors(brick, green, blue, yellow);
    % saves the current block's info into the map matrix
    saveinfo(map, curx, cury, current, brick, wallDetectionDistance, spinSpeed, spinLength, curDirection);
    % turns the robot to face it so it follows the right wall
    turn(brick, turnDirection(brick, wallDetectionDistance), spinSpeed, spinLength, curDirection);
    % robot moves forward and adds the counter variable 'current' by 1
    goForward(brick, curx, cury, wallDetectionDistance, curDirection);
    current = current + 1;
    % checks if the robot has reached the requirement for this test
    if brick.ColorCode(4) == 4
        test3 = false;
    end
end

while test4
    % adds delay to prevent overdoing sensors.
    pause(.05);
    % makes color sensor and you can call 'color' as keyword returning an
    % int from 0-7
    color = brick.ColorCode(3);
    % displays the int value of the color
    disp(color)
    % keybinds
    switch key
        % arrow keys to move, z and x for clamps
        case 'uparrow'
            disp(key)
            brick.MoveMotor('A', 500)
            brick.MoveMotor('D', 500)
        case 'downarrow'
            disp(key)
            brick.MoveMotor('A', -150);
            brick.MoveMotor('D', -150);
        case 'leftarrow'
            disp(key)
            brick.MoveMotor('D', 500);
            brick.MoveMotor('A', -500);
        case 'rightarrow'
            disp(key)
            brick.MoveMotor('A', 500);
            brick.MoveMotor('D', -500);
        case 'z'
            % closes clamp
            disp(key)
            brick.MoveMotor('B', -50);
        case 'x'
            % opens clamp
            brick.MoveMotor('B', 50);

        case 'q'
            % exits loop
            disp(key)
            test4 = false;
        otherwise
            % change Coast to 'Brake' for a break effect
            brick.StopAllMotors('Coast');
            
    end
    
end

function checkrepeats(graph, map, i, j, x, y)
    for i = 1:length(graph())
        if includes(map(i, j).block, graph(map(x, y).block)) == false
            graph(map(i, j).block) = [graph(map(i, j).block), graph(map(x, y).block);]
        end
    end
end

% updates the 'graph' variable using the 'map' matrix 
function convert_to_tree(graph, map)
    % the idea is that we go through each layer of the matrix and update each index
    % we repeat this for 11 times because there are 11 layers
    for i = 1:11
        for j = 1:11
            % these if statements check if there is a wall on each side of the current index
            % it then updates the 'graph' variable
            graph(map(i, j).block) = [];
            if map(i,j).n == false
                checkrepeats(i, j, i, j+1)
            end
            if map(i,j).e == false
                checkrepeats(i, j, i+1, j)
            end
            if map(i,j).s == false
                checkrepeats(i, j, i, j-1)
            end
            if map(i,j).w == false
                checkrepeats(i, j, i-1, j)
            end
        end
    end
end

% code to save the current block's info into the map matrix
function saveinfo(map, curx, cury, current, brick, wallDetectionDistance, spinSpeed, spinLength, curDirection)
    global map;
    % the place attribute is equal to current(counter variable) because we need a way to create a key for the dictionary/hashmap
    map(curx, cury).place = current;
    map(curx, cury).n = getFront(brick, wallDetectionDistance);
    % we know that south must be true because the robot can only move forward so back must be open
    map(curx, cury).s = true;
    map(curx, cury).e = getRight(brick, wallDetectionDistance);
    map(curx, cury).w = getLeft(brick, wallDetectionDistance, spinSpeed, spinLength, curDirection);
end

% code to check if there is a wall on a certain side of the robot using 'wallDetectionDistance' variable as the threshold
function bool = getFront(brick, wallDetectionDistance)
    distance = brick.UltrasonicDist(3);
    distance2 = brick.UltrasonicDist(3);
    distance3 = brick.UltrasonicDist(3);
    distance4 = brick.UltrasonicDist(3);
    distance5 = brick.UltrasonicDist(3);
    distance6 = brick.UltrasonicDist(3);
    distance7 = brick.UltrasonicDist(3);
    distance8 = brick.UltrasonicDist(3);
    distance9 = brick.UltrasonicDist(3);
    distance10 = brick.UltrasonicDist(3);
    average = (distance + distance2 + distance3 + distance4 + distance5 + distance6 + distance7 + distance8 + distance9 + distance10)/10;
    if average < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end
end

function bool = getRight(brick, wallDetectionDistance)
    distance = brick.UltrasonicDist(1);
    distance2 = brick.UltrasonicDist(1);
    distance3 = brick.UltrasonicDist(1);
    distance4 = brick.UltrasonicDist(1);
    distance5 = brick.UltrasonicDist(1);
    distance6 = brick.UltrasonicDist(1);
    distance7 = brick.UltrasonicDist(1);
    distance8 = brick.UltrasonicDist(1);
    distance9 = brick.UltrasonicDist(1);
    distance10 = brick.UltrasonicDist(1);
    average = (distance + distance2 + distance3 + distance4 + distance5 + distance6 + distance7 + distance8 + distance9 + distance10)/10;
    if average < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end    
end

function bool = getLeft(brick, wallDetectionDistance, spinSpeed, spinLength, curDirection)
    turn(brick, 3, spinSpeed, spinLength, curDirection);
    distance = brick.UltrasonicDist(3);
    distance2 = brick.UltrasonicDist(3);
    distance3 = brick.UltrasonicDist(3);
    distance4 = brick.UltrasonicDist(3);
    distance5 = brick.UltrasonicDist(3);
    distance6 = brick.UltrasonicDist(3);
    distance7 = brick.UltrasonicDist(3);
    distance8 = brick.UltrasonicDist(3);
    distance9 = brick.UltrasonicDist(3);
    distance10 = brick.UltrasonicDist(3);
    average = (distance + distance2 + distance3 + distance4 + distance5 + distance6 + distance7 + distance8 + distance9 + distance10)/10;
    turn(brick, 2, spinSpeed, spinLength, curDirection); 
    if average < wallDetectionDistance
        bool = true;
    else
        bool = false;
    end
end


% checks of the current block is a certain color and updates the variables accordingly
% also checks if the current block is red so that it stops right away. we might not need this 
function checkColors(brick, green, blue, yellow)
    % check for colors: red, green, blue
    % need to make sure we can break test1 loop by changing the boolean
    % also need to make sure finish is set to current on 
    if brick.ColorCode(4) == 5
        brick.StopAllMotors();
        pause(2);
        brick.MoveMotor('A', defaultSpeed);
        brick.MoveMotor('D', defaultSpeed);
        pause(1);
        brick.StopAllMotors();
    end
    if brick.ColorCode(4) == 2
        blue = current;
    end
    if brick.ColorCode(4) == 4
        yellow = current;
    end
end

% returns the direction the robot should turn to follow the right wall
% this doesn't actually move the robot in any way
function d = turnDirection(brick, wallDetectionDistance)
    if (getRight(brick, wallDetectionDistance) == false)
        d = 2;
    elseif (getFront(brick, wallDetectionDistance) == false)
        d = 1;
    else
        d = 4;
    end
end

% function to check if a key is in a list
% used for find_path algorithm
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

% function to find the path from the start to the end
% returns b as a list format
function b = find_path(graph, start, finish, path)
    path = [path, start];
    if start == finish
        b = path;
    else
        a = graph(start);
        for i = 1:length(a)
            if includes(a(i), path) == false
                find_path(graph, a(i), finish, path);
            end
        end
    end
end

% makes the robot go forward as long as there isn't red
% also updates the 'curx' and 'cury' variables based on the direction it faced before it moved forward
function goForward(brick, curx, cury, wallDetectionDistance, curDirection)
    defaultSpeed = 100;
    gapRed = 0.1;
    if (getFront(brick, wallDetectionDistance) == false)
        for (i = 0:30)
            if (brick.ColorCode(4) == 5)
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
        global curx;
        global cury;
        % updates 'curx' and 'cury' variables
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

% turns the robot to a certain direction with the parameter 'direction'
% 1 is north, 2 is east, 3 is south, 4 is west
function turn(brick, direction, spinSpeed, spinLength, curDirection)
    global curDirection;
    curDirection = direction;
    if (direction == 1)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
    elseif (direction == 2)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
    elseif (direction == 3)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
    elseif (direction == 4)
        brick.MoveMotor('A', -spinSpeed);
        brick.MoveMotor('D', spinSpeed);
    end
    pause(spinLength)
    brick.StopAllMotors();
end