curx = 6;
cury = 6;

blockDistance = 10;
stepDistance  = 1;

test1 = true;
test2 = true;

pickedup = false;
droppedoff = false;

leftwheel = 'A';
rightwheel = 'D';

map(1:11, 1:11) = cells;

while test1
    saveinfo(x, y);
    turn(turnDirection);
    goForward();
end

function saveinfo()
    map(curx, cury).n = getNorth;
    map(curx, cury).s = getSouth;
    map(curx, cury).e = getEast;
    map(curx, cury).w = getWest;
    map(curx, cury).c = getColor;
end

% make a class called cells with 5 parameters in matlab
classdef cells < matlab.System
    properties
        n
        e
        s
        w
        c
        visited = false;
    end
    methods
        
    end
end


graph = [];
function d = dfs(x, y)
    map(x, y).visited = true;
    possiblepaths = [];
    if map(x, y).n == true && map(x, y - 1).visited == false
        possiblepaths = [possiblepaths, [x,y+1]];
    end
    if map(x, y).e == true && map(x + 1, cury).visited == false
        possiblepaths = [possiblepaths, [x+1, cury]];
    end
    if map(x, y).s == true && map(x, y + 1).visited == false
        possiblepaths = [possiblepaths, [x, y-1]];
    end
    if map(x, y).w == true && map(x - 1, y).visited == false
        possiblepaths = [possiblepaths, [x-1, y]];
    end
    if isempty(possiblepaths)
        return
    else
        graph = [graph, [possiblepaths]];
    end
    if isempty(possiblepaths)
        
    end
    graph = [graph, possiblepaths];
    for (i = 1:length(possiblepaths))
        
    end

end

% always follows the right wall
function d = turnDirection()
    if (!getEast):
        d = 2;
    elseif (!getNorth):
        d = 1;
    else:
        d = 4;
    end
end

%turn in a direction, 1 = north, 2 = east, 3 = south, 4 = west
function turn(d)
    if (d == 1):
        % turn north

    elseif (d == 2):
        % turn east
        
    elseif (d == 3):
        % turn south

    else:
        % turn west

    end
end

% move forward one space if possible
function goForward()
    toggleRed = false;
    if (!getNorth):
        cury = cury + 1;
        for (i = 1:stepSize:blockDistance):
            % need to change the 1 to the correct color so condition is for "red"
            if (getColor == 1 || toggleRed == true):
                toggleRed = true;
                % code to break for a certain amount of time

            else
                % move forward 1 stepsize

            end
        end

    end
end

%create 4 methods getting north, east, south, west, and color
function n = getNorth()
    n = 
end
function e = getEast()
    e = 
end
function s = getSouth()
    s = 
end
function w = getWest()
    w = 
end
function c = getColor()
    c = 
end