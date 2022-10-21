curx = 6;
cury = 6;

blockDistance = 10;

test1 = true;
test2 = true;

pickedup = false;
droppedoff = false;

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
    end
    methods
        
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
    if (!getNorth):
        cury = cury + 1;
        while (!getRed && counter <= blockDistance):
            counter = counter + 1;
            % move forward a tiny bit
            
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