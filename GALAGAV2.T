var winID : int
winID := Window.Open ("graphics:600;800, position:center;center, nobuttonbar")
% position:center:center places run window in the middle of the screen
% nobuttonbar removes the top bar of buttons in the run window
%------------------------------------------------------------------------------
% Startup screen
var homepage : int
var homepageSprite : int
homepage := Pic.FileNew ("Homepage.jpg")
homepage := Pic.Scale (homepage, 600, 800)
homepageSprite := Sprite.New (homepage)
Sprite.SetPosition (homepageSprite, 0, 0, false)
Sprite.Show (homepageSprite)

% Instruction Page
var instruction : int
var instructionSprite : int
instruction := Pic.FileNew ("Instruction.jpg")
instruction := Pic.Scale (instruction, 600, 800)
instructionSprite := Sprite.New (instruction)

% Play music
process startMusic
    Music.PlayFileLoop ("RMTS.mp3")
end startMusic
fork startMusic
% Check if whether it is at homepage or instruction page
var hometrue : boolean := true

var chars : array char of boolean
var mx, my, mb : int := 0

% Get mouse input
loop
    Input.KeyDown (chars)
    mousewhere (mx, my, mb)
    % If player clicks play
    if mx > 175 and mx < 425 and my > 350 and my < 405 then
	if hometrue = true then
	    drawbox (175, 350, 425, 405, white)
	end if
	if mb = 1 then
	    Music.PlayFileStop
	    Sprite.Hide (homepageSprite)
	    cls
	    exit
	end if
	% If player clicks instructions
    elsif mx > 175 and mx < 425 and my > 255 and my < 315 then
	if hometrue = true then
	    drawbox (175, 255, 425, 315, white)
	end if
	if mb = 1 then
	    hometrue := false % Not at homepage
	    cls
	    Sprite.Hide (homepageSprite)
	    Sprite.SetPosition (instructionSprite, 0, 0, false)
	    Sprite.Show (instructionSprite)
	    loop
		% If player clicks back from instruction page
		Input.KeyDown (chars)
		mousewhere (mx, my, mb)
		if mx > 10 and mx < 100 and my > 740 and my < 780 then
		    drawbox (10, 740, 100, 780, white)
		    if mb = 1 then
			Sprite.Hide (instructionSprite)
			Sprite.Show (homepageSprite)
			exit
		    end if
		end if
	    end loop
	    hometrue := true
	end if
	% If player clicks exit
    elsif mx > 175 and mx < 425 and my > 165 and my < 220 then
	if hometrue = true then
	    drawbox (175, 165, 425, 220, white)
	end if
	if mb = 1 then
	    Music.PlayFileStop
	    Window.Close (winID) % Close program
	end if
    end if
end loop
%------------------------------------------------------------------------------
% Declare variables for main ship
var x : int := 300
var y : int := 100
var dirx, diry : int
var SP : int := 1
var shootx : int := 300
var bulletDraw : boolean := false

% Two extra lives
var lives : int := 3

% Create new pics and sprites for main ship
var ship : array 1 .. 4 of int
var sprite : array 1 .. 4 of int

for i : 1 .. 4
    ship (i) := Pic.FileNew ("ship" + intstr (i) + ".bmp")
    % Make the background transparent
    Pic.SetTransparentColor (ship (i), white)
    sprite (i) := Sprite.New (ship (i))
    Sprite.SetHeight (sprite (i), 5)
end for

% Create new pics and sprites for ship explosion
var boom : array 1 .. 10 of int
var spriteBoom : array 1 .. 10 of int
for i : 1 .. 10
    boom (i) := Pic.FileNew ("boom" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (boom (i), white)
end for
for i : 1 .. 10
    spriteBoom (i) := Sprite.New (boom (i))
    Sprite.SetHeight (spriteBoom (i), 5)
end for
%------------------------------------------------------------------------------
% Ship exploding sound
process shipExplode
    Music.PlayFile ("shipexplode.wav")
end shipExplode

% Bullet sound
process shipShootSound
    Music.PlayFile ("shipshoot.wav")
end shipShootSound

%Colors for bullet
var colour1, colour2, colour3 : int
colour1 := 27 % Grey
colour2 := 12 % Red
% Colour 7 is black
% Shoot bullets when fired
process shoot
    bulletDraw := true
    fork shipShootSound
    % When bullet is off screen reset colours and set to false
    colour1 := 27
    colour2 := 12
    for i : y .. 660
	drawfillbox (shootx - 3, i + 50, shootx + 3, i + 65, colour1)
	drawfillbox (shootx - 3, i + 65, shootx + 3, i + 85, colour2)
	delay (1) % Bullet speed
    end for
    bulletDraw := false
end shoot

% Fire torperdo

% Torpedo sound
process torpedoSound
    Music.PlayFile ("torpedosound.wav")
end torpedoSound
process torpedoExplodeSound
    Music.PlayFile ("torpedoexplode.wav")
end torpedoExplodeSound
% Ttorpedo variables
var torpedo : int := 1
var torpedoy : int
var torpedoPic : int
var torpedoSprite : int
%Torpedo images
torpedoPic := Pic.FileNew ("torpedo.bmp")
Pic.SetTransparentColor (torpedoPic, white)
torpedoSprite := Sprite.New (torpedoPic)

process torpedoFire
    % Fires if user has torpedos
    if torpedo > 0 then
	bulletDraw := true % Makes it so that user can't fire bullets and torpedo at the same time
	fork torpedoSound
	Sprite.Show (torpedoSprite)
	torpedoy := y
	% Torpedo location
	for i : 1 .. (torpedoy + 300)
	    Sprite.SetPosition (torpedoSprite, shootx, torpedoy + i, true)
	    delay (5) % Torpedo Speed
	end for
	Sprite.Hide (torpedoSprite)
	fork torpedoExplodeSound
	torpedo -= 1
	% Torpedo Explosion
	drawfillbox (0, 0, 600, 800, 12)
	delay (100)
	drawfillbox (0, 0, 600, 800, 40)
	delay (100)
	drawfillbox (0, 0, 600, 800, 41)
	delay (100)
	drawfillbox (0, 0, 600, 800, 44)
	delay (100)
	drawfillbox (0, 0, 600, 800, 12)
	delay (100)
	cls
    end if
    bulletDraw := false
end torpedoFire

var torpedoShow : array 1 .. 3 of int
var torSprite : array 1 .. 3 of int
for i : 1 .. 3
    torpedoShow (i) := Pic.FileNew ("torpedo" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (torpedoShow (i), white)
    torSprite (i) := Sprite.New (torpedoShow (i))
end for
Sprite.SetPosition (torSprite (1), 40, 760, true)
Sprite.SetPosition (torSprite (2), 75, 760, true)
Sprite.SetPosition (torSprite (3), 110, 760, true)
process torShow
    loop
	% Show number of torpedos left
	if torpedo = 1 then
	    Sprite.Show (torSprite (1))
	    Sprite.Hide (torSprite (2))
	    Sprite.Hide (torSprite (3))
	elsif torpedo = 2 then
	    Sprite.Show (torSprite (1))
	    Sprite.Show (torSprite (2))
	    Sprite.Hide (torSprite (3))
	elsif torpedo = 3 then
	    Sprite.Show (torSprite (1))
	    Sprite.Show (torSprite (2))
	    Sprite.Show (torSprite (3))
	elsif torpedo = 0 then
	    Sprite.Hide (torSprite (1))
	    Sprite.Hide (torSprite (2))
	    Sprite.Hide (torSprite (3))
	end if
    end loop
end torShow

%------------------------------------------------------------------------------
% Drop enemies
var score : int := 0
% Random bullets
process randBullets
    for i : 1 .. 800
	% Draw bullets
	drawfillbox (147, 775 - i, 153, 800 - i, 42)
	drawfillbox (297, 775 - i, 303, 800 - i, 42)
	drawfillbox (447, 775 - i, 453, 800 - i, 42)
	delay (1)
	drawfillbox (147, 775 - i, 153, 800 - i, black)
	drawfillbox (297, 775 - i, 303, 800 - i, black)
	drawfillbox (447, 775 - i, 453, 800 - i, black)
    end for
end randBullets

process randBullets1
    for i : 1 .. 800
	% Draw bullets
	drawfillbox (i, 150, i + 25, 156, 42)
	drawfillbox (600 - i, 300, 575 - i, 306, 42)
	drawfillbox (i, 450, i + 25, 456, 42)
	drawfillbox (600 - i, 600, 575 - i, 606, 42)
	delay (5)
	drawfillbox (i, 150, i + 25, 156, black)
	drawfillbox (600 - i, 300, 575 - i, 306, black)
	drawfillbox (i, 450, i + 25, 456, black)
	drawfillbox (600 - i, 600, 575 - i, 606, black)
    end for
end randBullets1

process bulletFollows
    var bfx := x
    for decreasing i : 800 .. 1
	drawfillbox (bfx - 50, i - 20, bfx - 47, i, 42)
	drawfillbox (bfx + 50, i - 20, bfx + 47, i, 42)
	drawfillbox (bfx - 2, i - 30, bfx + 2, i - 10, 42)
	drawfillbox (bfx - 100, i - 40, bfx - 97, i - 20, 42)
	drawfillbox (bfx + 100, i - 50, bfx + 97, i - 30, 42)
	delay (3)
	drawfillbox (bfx - 50, i - 20, bfx - 47, i, black)
	drawfillbox (bfx + 50, i - 20, bfx + 47, i, black)
	drawfillbox (bfx - 2, i - 30, bfx + 2, i - 10, black)
	drawfillbox (bfx - 100, i - 40, bfx - 97, i - 20, black)
	drawfillbox (bfx + 100, i - 50, bfx + 97, i - 30, black)
    end for
end bulletFollows

var droptorx : int
var torColour : int
var torpedoLive : boolean := false
process droptor
    % Dropping Star
    torColour := 11 % If player gets the star, the star should "disappear"
    droptorx := 600 - x
    for i : 1 .. 800
	if torpedoLive = false then
	    drawfillstar (droptorx - 5, 790 - i, droptorx + 5, 800 - i, torColour)
	    delay (10)
	    drawfillstar (droptorx - 5, 790 - i, droptorx + 5, 800 - i, black)
	end if
    end for
end droptor

% Enemy 1
var enemy1pic : array 1 .. 4 of int
var enemy1x : array 1 .. 4 of int
var enemy1y : array 1 .. 4 of int
var enemy1sprite : array 1 .. 4 of int
var enemy1live : array 1 .. 4 of boolean

% Set position of enemy1
enemy1x (1) := 120
enemy1x (2) := 240
enemy1x (3) := 360
enemy1x (4) := 480

for i : 1 .. 4
    enemy1pic (i) := Pic.FileNew (intstr (i) + ".bmp")
    Pic.SetTransparentColor (enemy1pic (i), white)
    enemy1sprite (i) := Sprite.New (enemy1pic (i))
end for

% Make path for 4 enemy1s to follow
process enemy1
    for i : 1 .. 4
	enemy1live (i) := false
	Sprite.Show (enemy1sprite (i))
    end for

    for i : 1 .. 725 by 5
	for e : 1 .. 4
	    % Set position of the enemies
	    Sprite.SetPosition (enemy1sprite (e), enemy1x (e), 710 - i, true)
	    if enemy1live (e) = false then
		drawfilloval (enemy1x (e), 710 - i, 10, 10, 42)     % Use whatdotcolor function to check if it collides with ship
		delay (1)
		drawfilloval (enemy1x (e), 710 - i, 10, 10, black)
	    end if
	    for enemyx : (enemy1x (e) - 15) .. (enemy1x (e) + 15)
		for enemyy : (695 - i) .. (725 - i)
		    if whatdotcolor (enemyx, enemyy) = 12 and enemy1live (e) = false then
			Sprite.Hide (enemy1sprite (e))     % If enemy is hit then hide sprite
			score += 5   % Add score if enemy is destroyed
			colour1 := 7 % If bullet hits the enemy then the bullet disappear
			colour2 := 7
			% Hide enemy when they die
			enemy1live (e) := true
			drawfilloval (enemy1x (e), 710 - i, 10, 10, black)
		    end if
		end for
	    end for
	end for
    end for
end enemy1

% Enemy 2
var enemy2pic : array 5 .. 6 of int
var enemy2x : array 5 .. 6 of int
var enemy2y : array 5 .. 6 of int
var enemy2sprite : array 5 .. 6 of int
var enemy2live : array 5 .. 6 of boolean

for i : 5 .. 6
    enemy2pic (i) := Pic.FileNew (intstr (i) + ".bmp")
    Pic.SetTransparentColor (enemy2pic (i), white)
    enemy2sprite (i) := Sprite.New (enemy2pic (i))
end for

process enemy21
    enemy2x (5) := 0
    enemy2y (5) := 600
    enemy2live (5) := false
    Sprite.Show (enemy2sprite (5))
    for i : 1 .. 625 by 5
	Sprite.SetPosition (enemy2sprite (5), enemy2x (5) + i, enemy2y (5) - i, true)
	if enemy2live (5) = false then
	    drawfilloval (enemy2x (5) + i, enemy2y (5) - i, 20, 20, 42)
	    delay (1)
	    drawfilloval (enemy2x (5) + i, enemy2y (5) - i, 20, 20, black)
	end if
	for enemyx : (enemy2x (5) - 50 + i) .. (enemy2x (5) + 50 + i)
	    for enemyy : (enemy2y (5) - 25 - i) .. (enemy2y (5) + 25 - i)
		if whatdotcolor (enemyx, enemyy) = 12 and enemy2live (5) = false then
		    Sprite.Hide (enemy2sprite (5))
		    score += 2
		    colour1 := 7
		    colour2 := 7
		    enemy2live (5) := true
		    drawfilloval (enemy2x (5) + i, enemy2y (5) - i, 20, 20, black)
		end if
	    end for
	end for
    end for
end enemy21

process enemy22
    enemy2x (6) := 600
    enemy2y (6) := 600
    enemy2live (6) := false
    Sprite.Show (enemy2sprite (6))
    for i : 1 .. 625 by 5
	Sprite.SetPosition (enemy2sprite (6), enemy2x (6) - i, enemy2y (6) - i, true)
	if enemy2live (6) = false then
	    drawfilloval (enemy2x (6) - i, enemy2y (6) - i, 20, 20, 42)
	    delay (1)
	    drawfilloval (enemy2x (6) - i, enemy2y (6) - i, 20, 20, black)
	end if
	for enemyx : (enemy2x (6) - 50 - i) .. (enemy2x (6) + 50 - i)
	    for enemyy : (enemy2y (6) - 25 - i) .. (enemy2y (6) + 25 - i)
		if whatdotcolor (enemyx, enemyy) = 12 and enemy2live (6) = false then
		    Sprite.Hide (enemy2sprite (6))
		    score += 2
		    colour1 := 7
		    colour2 := 7
		    enemy2live (6) := true
		    drawfilloval (enemy2x (6) - i, enemy2y (6) - i, 20, 20, black)
		end if
	    end for
	end for
    end for
end enemy22

% Enemy 3
var enemy3pic : int
var enemy3sprite : int
var enemy3x : int
var enemy3live : boolean

enemy3pic := Pic.FileNew ("7.bmp")
Pic.SetTransparentColor (enemy3pic, white)
enemy3sprite := Sprite.New (enemy3pic)

process enemy3
    Sprite.Show (enemy3sprite)
    enemy3x := x
    enemy3live := false
    for i : 1 .. 800 by 10
	Sprite.SetPosition (enemy3sprite, enemy3x, 800 - i, true)
	if enemy3live = false then
	    drawfilloval (enemy3x, 800 - i, 5, 5, 42)
	    delay (1)
	    drawfilloval (enemy3x, 800 - i, 5, 5, black)
	end if
	for enemyx : (enemy3x - 25) .. (enemy3x + 25)
	    for enemyy : (780 - i) .. (820 - i)
		if whatdotcolor (enemyx, enemyy) = 12 and enemy3live = false then
		    Sprite.Hide (enemy3sprite)
		    score += 10
		    colour1 := 7
		    colour2 := 7
		    enemy3live := true
		    drawfilloval (enemy3x, 800 - i, 5, 5, black)
		end if
	    end for
	end for
    end for
end enemy3

% Enemy 4
var enemy4pic : array 8 .. 9 of int
var enemy4x : array 8 .. 9 of int
var enemy4y : array 8 .. 9 of int
var enemy4sprite : array 8 .. 9 of int
var enemy4live : array 8 .. 9 of boolean

for i : 8 .. 9
    enemy4pic (i) := Pic.FileNew (intstr (i) + ".bmp")
    Pic.SetTransparentColor (enemy4pic (i), white)
    enemy4sprite (i) := Sprite.New (enemy4pic (i))
end for

process enemy4
    enemy4x (8) := 0
    enemy4x (9) := 600
    enemy4y (8) := y - 20
    enemy4y (9) := y + 20
    for i : 8 .. 9
	enemy4live (i) := false
	Sprite.Show (enemy4sprite (i))
    end for

    for i : 1 .. 650
	enemy4x (8) += i
	enemy4x (9) -= i
	Sprite.SetPosition (enemy4sprite (8), enemy4x (8), enemy4y (8), true)
	Sprite.SetPosition (enemy4sprite (9), enemy4x (9), enemy4y (9), true)
	if lives > 0 then
	    drawfilloval (enemy4x (8), enemy4y (8), 10, 10, 42)
	    delay (30)
	    drawfilloval (enemy4x (8), enemy4y (8), 10, 10, black)
	    drawfilloval (enemy4x (9), enemy4y (9), 10, 10, 42)
	    delay (30)
	    drawfilloval (enemy4x (9), enemy4y (9), 10, 10, black)
	end if
    end for
end enemy4

% Enemy 5
var enemy5pic : array 10 .. 13 of int
var enemy5x : array 10 .. 13 of int
var enemy5sprite : array 10 .. 13 of int
var enemy5live : array 10 .. 13 of boolean

for i : 10 .. 13
    enemy5pic (i) := Pic.FileNew (intstr (i) + ".bmp")
    Pic.SetTransparentColor (enemy5pic (i), white)
    enemy5sprite (i) := Sprite.New (enemy5pic (i))
end for

process enemy5
    enemy5x (10) := 0
    enemy5x (11) := 70
    enemy5x (12) := 140
    enemy5x (13) := 210
    for i : 10 .. 13
	enemy5live (i) := false
	Sprite.SetPosition (enemy5sprite (i), enemy5x (i), 700, true)
	Sprite.Show (enemy5sprite (i))
    end for
    enemy5x (10) := 0
    enemy5x (11) := 70
    enemy5x (12) := 140
    enemy5x (13) := 210
    for e5x : 1 .. 390 by 5
	for e : 10 .. 13
	    Sprite.SetPosition (enemy5sprite (e), enemy5x (e) + e5x, 700, true)
	    if enemy5live (e) = false then
		drawdot (enemy5x (e) + e5x, 700, 42)
		delay (1)
		drawdot (enemy5x (e) + e5x, 700, black)
	    end if
	    for enemyx : (enemy5x (e) - 15 + e5x) .. (enemy5x (e) + 15 + e5x)
		for enemyy : 685 .. 715
		    if whatdotcolor (enemyx, enemyy) = 12 then
			score += 15
			colour1 := 7
			colour2 := 7
			Sprite.Hide (enemy5sprite (e))
			enemy5live (e) := true
			drawdot (enemy5x (e) + e5x, 700, black)
		    end if
		end for
	    end for
	end for
    end for
    enemy5x (10) := 390
    enemy5x (11) := 460
    enemy5x (12) := 530
    enemy5x (13) := 600
    for e5x : 1 .. 620 by 5
	for e : 10 .. 13
	    Sprite.SetPosition (enemy5sprite (e), enemy5x (e) - e5x, 700, true)
	    delay (1)
	    for enemyx : (enemy5x (e) - 15 - e5x) .. (enemy5x (e) + 15 - e5x)
		for enemyy : 685 .. 715
		    if whatdotcolor (enemyx, enemyy) = 12 then
			Sprite.Hide (enemy5sprite (e))
			score += 15
			colour1 := 7
			colour2 := 7
			enemy5live (e) := true
			drawdot (enemy5x (e) - e5x, 700, black)
		    end if
		end for
	    end for
	end for
    end for
end enemy5

% Final boss
var boss : int
var spriteBoss : int
var hitBoss : int
var hitBossNum : int := 0

boss := Pic.FileNew ("boss.bmp")
Pic.SetTransparentColor (boss, white)
spriteBoss := Sprite.New (boss)
hitBoss := Pic.FileNew ("hitboss.bmp")
Pic.SetTransparentColor (hitBoss, white)
Sprite.SetHeight (spriteBoss, 3)

process bossGo
    Sprite.SetPosition (spriteBoss, 300, 950, true)
    Sprite.Show (spriteBoss)

    for i : 1 .. 1100 by 10
	Sprite.SetPosition (spriteBoss, 300, 950 - i, true)
	for bossx : 200 .. 300
	    for bossy : (900 - i) .. (1050 - i)
		if whatdotcolor (bossx, bossy) = 12 then
		    hitBossNum += 1
		    Sprite.ChangePic (spriteBoss, hitBoss)
		    delay (1)
		    Sprite.ChangePic (spriteBoss, boss)
		    if hitBossNum = 2500 then
			score += 100
			Sprite.Hide (spriteBoss)
		    end if
		end if
	    end for
	end for
	delay (1)
    end for
end bossGo
%------------------------------------------------------------------------------
% Keep track of time
var timer : int := 0
var sec, sec1, sec2 : int
var text : array 0 .. 21 of int
var spriteText : array 0 .. 21 of int
for i : 0 .. 21
    text (i) := Pic.FileNew ("text" + intstr (i) + ".jpg")
    Pic.SetTransparentColor (text (i), black)
    spriteText (i) := Sprite.New (text (i))
end for

var textTime : int
var spriteTextTime : int
textTime := Pic.FileNew ("texttime.jpg")
Pic.SetTransparentColor (textTime, black)
spriteTextTime := Sprite.New (textTime)

Sprite.SetPosition (spriteTextTime, 400, 760, true)
process gameTime
    loop
	Sprite.Show (spriteTextTime)
	timer += 1
	if lives = 0 or timer = 158 then
	    for i : 0 .. 21
		Sprite.Hide (spriteText (i))
	    end for
	    Sprite.Hide (spriteTextTime)
	    return
	end if
	% Run enemies----------------------------------------------------------
	if timer = 5 then
	    fork randBullets1
	end if
	if timer > 0 and timer < 158 and lives > 0 then
	    if timer = 140 then
		fork bossGo
	    elsif timer mod 10 = 0 and timer < 110 then
		fork enemy1
	    elsif timer mod 13 = 0 and timer > 120 then
		fork enemy1
	    elsif timer mod 31 = 0 then
		fork enemy21
	    elsif timer mod 53 = 0 then
		fork enemy22
	    elsif timer mod 17 = 0 and timer < 140 then
		fork randBullets
	    elsif timer mod 5 = 0 and timer > 140 then
		fork randBullets
	    elsif timer mod 41 = 0 then
		fork enemy3
	    elsif timer mod 71 = 0 then
		fork randBullets1
	    elsif timer mod 18 = 0 and timer < 50 and timer < 140 then
		fork bulletFollows
	    elsif timer = 61 or timer = 129 then
		fork droptor
	    elsif timer = 72 then
		fork enemy4
	    elsif timer mod 18 = 0 and timer > 84 then
		fork enemy5
	    end if
	end if
	%----------------------------------------------------------------------
	% Display time on screen
	sec := timer
	if timer >= 0 and timer < 10 then
	    Sprite.Show (spriteText (sec))
	    Sprite.Animate (spriteText (sec), text (sec), 480, 760, true)
	    delay (1000)
	    Sprite.Hide (spriteText (sec))
	elsif timer >= 10 and timer < 100 then
	    sec := floor (timer / 10)
	    sec1 := timer - sec * 10
	    if sec = sec1 then
		sec1 += 10
	    end if
	    Sprite.Show (spriteText (sec))
	    Sprite.Show (spriteText (sec1))
	    Sprite.Animate (spriteText (sec), text (sec), 480, 760, true)
	    Sprite.Animate (spriteText (sec1), text (sec1), 510, 760, true)
	    delay (1000)
	    Sprite.Hide (spriteText (sec))
	    Sprite.Hide (spriteText (sec1))
	elsif timer >= 100 and timer < 158 then
	    sec := floor (timer / 100)
	    sec1 := (timer - sec * 100) mod 10
	    sec2 := (timer - sec * 100 - sec1) div 10
	    sec += 20
	    sec1 += 10
	    Sprite.Show (spriteText (sec))
	    Sprite.Show (spriteText (sec2))
	    Sprite.Show (spriteText (sec1))
	    Sprite.Animate (spriteText (sec), text (sec), 480, 760, true)
	    Sprite.Animate (spriteText (sec2), text (sec2), 510, 760, true)
	    Sprite.Animate (spriteText (sec1), text (sec1), 540, 760, true)
	    delay (1000)
	    Sprite.Hide (spriteText (sec))
	    Sprite.Hide (spriteText (sec2))
	    Sprite.Hide (spriteText (sec1))
	end if
    end loop
end gameTime
%------------------------------------------------------------------------------
% Show number of lives left

var textx : int
var textxSprite : int
var lifePic : array 2 .. 3 of int
var lifeSprite : array 2 .. 3 of int
for i : 2 .. 3
    lifePic (i) := Pic.FileNew ("life" + intstr (i) + ".bmp")
    Pic.SetTransparentColor (lifePic (i), white)
    lifeSprite (i) := Sprite.New (lifePic (i))
end for
textx := Pic.FileNew ("textx.jpg")
Pic.SetTransparentColor (textx, black)
textxSprite := Sprite.New (textx)

process lifeShow
    Sprite.SetPosition (textxSprite, 35, 55, true)
    Sprite.Show (textxSprite)
    loop
	if lives = 3 then
	    Sprite.SetPosition (lifeSprite (2), 80, 50, true)
	    Sprite.Show (lifeSprite (2))
	    Sprite.SetPosition (lifeSprite (3), 130, 50, true)
	    Sprite.Show (lifeSprite (3))
	elsif lives = 2 then
	    Sprite.Hide (lifeSprite (3))
	elsif lives = 1 then
	    Sprite.Hide (lifeSprite (2))
	    Sprite.SetPosition (spriteText (20), 70, 55, true)
	    Sprite.Show (spriteText (20))
	elsif lives = 0 or timer = 158 then
	    Sprite.Hide (lifeSprite (2))
	    Sprite.Hide (lifeSprite (3))
	    Sprite.Hide (textxSprite)
	    return
	end if
    end loop
end lifeShow
%------------------------------------------------------------------------------
% Background
var background : int
var spriteBackground : int
background := Pic.FileNew ("space.jpg")
background := Pic.Scale (background, 600, 1600)
spriteBackground := Sprite.New (background)
Sprite.SetHeight (spriteBackground, 1)
Sprite.Show (spriteBackground)
process space
    loop
	for decreasing i : 800 .. 0
	    Sprite.SetPosition (spriteBackground, 300, i, true)
	    if lives = 0 or timer = 158 then
		delay (500)
		Sprite.Hide (spriteBackground)
		return
	    end if
	    delay (1)
	end for
    end loop
end space

% Song in background
process mainGameMusic
    Music.PlayFile ("Megalovania.mp3")
end mainGameMusic
%------------------------------------------------------------------------------
loop
    % Because if game is played again, the variables outside the loop won't be reset
    Sprite.Show (spriteBackground)
    Sprite.Show (sprite (1))
    Sprite.SetPosition (sprite (1), x, y, true)
    shootx := 300
    torpedo := 1
    SP := 1
    x := 300
    y := 100
    % Ship not moving in any direction
    dirx := 0
    diry := 0
    % Rest lives, score timer
    lives := 3
    score := 0
    timer := 0
    hitBossNum := 0
    % Draw game
    fork space     % Run background
    fork gameTime     % Start timer
    fork mainGameMusic     % Run game music in the background
    fork lifeShow     % Display lives
    fork torShow
    loop
	Input.KeyDown (chars)
	% Move ship up
	if chars (KEY_UP_ARROW) then
	    y += 10
	    % Keep ship within boundaries
	    if y > 670 then
		y := 670
	    end if
	    % Direction of ship changes
	    dirx := 0
	    diry := 1
	    % Sprite number for ship moving up image is...
	    SP := 2
	    % Show sprite
	    Sprite.Show (sprite (2))
	    Sprite.Hide (sprite (1))
	    Sprite.Hide (sprite (3))
	    Sprite.Hide (sprite (4))
	    % Move ship left
	elsif chars (KEY_LEFT_ARROW) then
	    x -= 10
	    if x < 35 then
		x := 35
	    end if
	    dirx := -1
	    diry := 0
	    SP := 3
	    Sprite.Show (sprite (3))
	    Sprite.Hide (sprite (1))
	    Sprite.Hide (sprite (2))
	    Sprite.Hide (sprite (4))
	    % Move ship down
	elsif chars (KEY_DOWN_ARROW) then
	    y -= 10
	    if y < 50 then
		y := 50
	    end if
	    dirx := 0
	    diry := -1
	    SP := 1
	    Sprite.Show (sprite (1))
	    Sprite.Hide (sprite (2))
	    Sprite.Hide (sprite (3))
	    Sprite.Hide (sprite (4))
	    % Move ship right
	elsif chars (KEY_RIGHT_ARROW) then
	    x += 10
	    if x > 565 then
		x := 565
	    end if
	    dirx := 1
	    diry := 0
	    SP := 4
	    Sprite.Show (sprite (4))
	    Sprite.Hide (sprite (1))
	    Sprite.Hide (sprite (2))
	    Sprite.Hide (sprite (3))
	    % If ship is not moving
	elsif dirx = 0 and diry = 0 then
	    SP := 1
	    Sprite.Show (sprite (1))
	    Sprite.Hide (sprite (2))
	    Sprite.Hide (sprite (3))
	    Sprite.Hide (sprite (4))
	end if
	% Move ship
	if diry = 1 then
	    % Sprite.Animate changes pic and location and the same time
	    Sprite.Animate (sprite (SP), ship (SP), x, y - 40, true)     % Centre ship2 = ship1
	    delay (10)     % Different speed when moving up, down or sideways
	elsif diry = -1 then
	    Sprite.Animate (sprite (SP), ship (SP), x, y, true)
	    delay (1)
	else
	    Sprite.Animate (sprite (SP), ship (SP), x, y, true)
	    delay (5)
	end if
	% Make sure bullets can only be fired one at a time
	if bulletDraw = false then
	    shootx := x
	elsif bulletDraw = true then
	    shootx := shootx
	end if
	% Space bar to shoot
	if chars (' ') and bulletDraw = false then
	    fork shoot
	end if
	% Fire torpedoes
	if chars (KEY_ENTER) and bulletDraw = false then
	    fork torpedoFire
	end if
	% Check is the area around ship is hit by a  ship
	for shiphitx : (x - 25) .. (x + 25)
	    for shiphity : (y - 30) .. (y + 30)
		if whatdotcolor (shiphitx, shiphity) = 42 and lives > 0 then    % Collision with enemy and bullet
		    % Lose life
		    lives -= 1
		    Sprite.Hide (sprite (SP))
		    fork shipExplode
		    % Animate explosion
		    for i : 1 .. 10
			Sprite.Show (spriteBoom (i))
			Sprite.Animate (spriteBoom (i), boom (i), x, y, true)
			delay (50)
			Sprite.Hide (spriteBoom (i))
		    end for
		    SP := 1
		    x := 300
		    y := 100
		elsif whatdotcolor (shiphitx, shiphity) = 11 then
		    torColour := 7
		    torpedo += 1
		    if torpedo > 3 then
			torpedo := 3
		    end if
		end if
	    end for
	end for
	% Rest direction of ship
	dirx := 0
	diry := 0
	Sprite.SetPosition (sprite (SP), x, y, true)
	% Game ends
	if lives = 0 or timer = 158 then
	    drawfillbox (0, 0, 600, 800, black)
	    % Hide instead of free incase player wants to play again
	    for i : 1 .. 4
		Sprite.Hide (sprite (i))
		Sprite.Hide (enemy1sprite (i))
		enemy1live (i) := true
	    end for
	    for i : 1 .. 10
		Sprite.Hide (spriteBoom (i))
	    end for
	    for i : 5 .. 6
		Sprite.Hide (enemy2sprite (i))
		enemy2live (i) := true
	    end for
	    Sprite.Hide (enemy3sprite)
	    for i : 8 .. 9
		Sprite.Hide (enemy4sprite (i))
		enemy4live (i) := true
	    end for
	    for i : 10 .. 13
		Sprite.Hide (enemy5sprite (i))
		enemy5live (i) := true
	    end for
	    Sprite.Hide (spriteBoss)
	    torpedoLive := true
	    torpedo := 0
	    cls
	    exit
	end if
    end loop
    if lives = 0 then
	Music.PlayFileStop  % Stop all music from playing
    end if
    %------------------------------------------------------------------------------
    % Gameover screen
    var gameoverScreen : int
    var gameoverSprite : int
    gameoverScreen := Pic.FileNew ("Gameover.jpg")
    gameoverScreen := Pic.Scale (gameoverScreen, 600, 800)
    gameoverSprite := Sprite.New (gameoverScreen)
    Sprite.SetPosition (gameoverSprite, 0, 0, false)
    Sprite.Show (gameoverSprite)

    % Variables for end screen
    var gameLose : int
    var gameWin : int
    var gameLoseSprite : int
    var gameWinSprite : int
    gameLose := Pic.FileNew ("gamelose.jpg")
    gameLose := Pic.Scale (gameLose, 300, 100)
    Pic.SetTransparentColor (gameLose, black)
    gameLoseSprite := Sprite.New (gameLose)

    gameWin := Pic.FileNew ("gamewin.jpg")
    gameWin := Pic.Scale (gameWin, 300, 100)
    Pic.SetTransparentColor (gameWin, black)
    gameWinSprite := Sprite.New (gameWin)

    Sprite.SetPosition (gameLoseSprite, 300, 635, true)
    Sprite.SetPosition (gameWinSprite, 300, 635, true)

    % Winning means that player made it to 158 seconds
    if timer = 158 then
	Sprite.Show (gameWinSprite)
    elsif lives = 0 then
	Sprite.Show (gameLoseSprite)
    end if

    % Variables to display score
    var gameScore1 : array 0 .. 9 of int
    var gameScore2 : array 10 .. 19 of int
    var gameScore3 : array 100 .. 190 of int
    var gameScore4 : array 1100 .. 1900 of int
    var gameScore1sprite : array 0 .. 9 of int
    var gameScore2sprite : array 10 .. 19 of int
    var gameScore3sprite : array 100 .. 190 of int
    var gameScore4sprite : array 1100 .. 1900 of int
    var gs1, gs2, gs3, gs4 : int
    for i : 0 .. 9
	gameScore1 (i) := Pic.FileNew ("score" + intstr (i) + ".jpg")
	gameScore1 (i) := Pic.Scale (gameScore1 (i), 50, 75)
	Pic.SetTransparentColor (gameScore1 (i), black)
	gameScore1sprite (i) := Sprite.New (gameScore1 (i))
    end for
    for i : 10 .. 19
	gameScore2 (i) := Pic.FileNew ("score" + intstr (i) + ".jpg")
	gameScore2 (i) := Pic.Scale (gameScore2 (i), 50, 75)
	Pic.SetTransparentColor (gameScore2 (i), black)
	gameScore2sprite (i) := Sprite.New (gameScore2 (i))
    end for
    for i : 100 .. 190 by 10
	gameScore3 (i) := Pic.FileNew ("score" + intstr (i) + ".jpg")
	gameScore3 (i) := Pic.Scale (gameScore3 (i), 50, 75)
	Pic.SetTransparentColor (gameScore3 (i), black)
	gameScore3sprite (i) := Sprite.New (gameScore3 (i))
    end for
    for i : 1100 .. 1900 by 100
	gameScore4 (i) := Pic.FileNew ("score" + intstr (i) + ".jpg")
	gameScore4 (i) := Pic.Scale (gameScore4 (i), 50, 75)
	Pic.SetTransparentColor (gameScore4 (i), black)
	gameScore4sprite (i) := Sprite.New (gameScore4 (i))
    end for

    % Display score
    if score >= 0 and score < 10 then
	gs1 := score
	Sprite.SetPosition (gameScore1sprite (gs1), 305, 450, true)
	Sprite.Show (gameScore1sprite (gs1))
    elsif score >= 10 and score < 100 then
	gs2 := floor (score / 10)
	gs1 := score - gs2 * 10
	Sprite.SetPosition (gameScore2sprite (gs2 + 10), 280, 450, true)
	Sprite.SetPosition (gameScore1sprite (gs1), 330, 450, true)
	Sprite.Show (gameScore2sprite (gs2 + 10))
	Sprite.Show (gameScore1sprite (gs1))
    elsif score >= 100 and score < 1000 then
	gs3 := floor (score / 100)
	gs1 := (score - gs3 * 100) mod 10
	gs2 := (score - gs3 * 100 - gs1) div 10
	Sprite.SetPosition (gameScore1sprite (gs1), 355, 450, true)
	Sprite.SetPosition (gameScore2sprite (gs2 + 10), 305, 450, true)
	Sprite.SetPosition (gameScore3sprite (gs3 * 10 + 100), 255, 450, true)
	Sprite.Show (gameScore1sprite (gs1))
	Sprite.Show (gameScore2sprite (gs2 + 10))
	Sprite.Show (gameScore3sprite (gs3 * 10 + 100))
    elsif score >= 1000 and score < 10000 then
	gs4 := floor (score / 1000)
	gs3 := floor ((score - gs4 * 1000) / 100)
	gs1 := (score - gs4 * 1000 - gs3 * 100) mod 10
	gs2 := (score - gs4 * 1000 - gs3 * 100 - gs1) div 10
	gs2 += 10
	gs3 := (gs3 + 10) * 10
	gs4 := (gs4 + 10) * 100
	Sprite.SetPosition (gameScore4sprite (gs4), 230, 450, true)
	Sprite.SetPosition (gameScore3sprite (gs3), 280, 450, true)
	Sprite.SetPosition (gameScore2sprite (gs2), 330, 450, true)
	Sprite.SetPosition (gameScore1sprite (gs1), 380, 450, true)
	Sprite.Show (gameScore4sprite (gs4))
	Sprite.Show (gameScore3sprite (gs3))
	Sprite.Show (gameScore1sprite (gs1))
	Sprite.Show (gameScore2sprite (gs2))
    end if

    % Play again?
    loop
	Input.KeyDown (chars)
	mousewhere (mx, my, mb)
	if mx > 155 and mx < 455 and my > 150 and my < 215 then
	    drawbox (155, 150, 455, 215, white)
	    if mb = 1 then
		% Hide all the sprites from gameover screen
		Sprite.Hide (gameoverSprite)
		if timer = 158 then
		    Sprite.Hide (gameWinSprite)
		elsif lives = 0 then
		    Sprite.Hide (gameLoseSprite)
		end if
		if score >= 0 and score < 10 then
		    Sprite.Hide (gameScore1sprite (gs1))
		elsif score >= 10 and score < 100 then
		    Sprite.Hide (gameScore2sprite (gs2 + 10))
		    Sprite.Hide (gameScore1sprite (gs1))
		elsif score >= 100 and score < 1000 then
		    Sprite.Hide (gameScore1sprite (gs1))
		    Sprite.Hide (gameScore2sprite (gs2 + 10))
		    Sprite.Hide (gameScore3sprite (gs3 * 10 + 100))
		elsif score >= 1000 and score < 10000 then
		    Sprite.Hide (gameScore4sprite (gs4))
		    Sprite.Hide (gameScore3sprite (gs3))
		    Sprite.Hide (gameScore1sprite (gs1))
		    Sprite.Hide (gameScore2sprite (gs2))
		end if
		cls
		exit
	    end if
	elsif mx > 155 and mx < 455 and my > 80 and my < 135 then
	    drawbox (155, 80, 455, 135, white)
	    if mb = 1 then
		Window.Close (winID) % Exit program
	    end if
	end if
    end loop
end loop
%------------------------------------------------------------------------------
