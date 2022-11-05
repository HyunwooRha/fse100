brick = ConnectBrick('EVAL');
brick.SetColorMode(3,2);
%%
global key;
InitKeyboard();
pause(1);

while true
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
        otherwise
            % change Coast to 'Brake' for a break effect
            brick.StopAllMotors('Coast');
            
    end
    
end
