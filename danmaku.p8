pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
timer1 = 0
bullets ={}
lasers ={}
end

function _update60()
timer1 += 1
if timer1 >= 30 then
	for i=1,10 do
	b_gen(63,30,0.5,0.1*i,0.0012,nil,1,"sprite")
	b_gen(34+5*i,35,0.15,getdir(34+10*i,35,127,60),0,scripts[1],3,"sprite")
	l_gen(63,30,63+5*sin(0.1*i),30+5*cos(0.1*i),0.5,nil,1,10)
	end
	timer1 =0
end

for b in all(bullets) do
		b_update(b)
end

for l in all(lasers) do
		l_update(l)
end

end

function _draw()
cls(1)
b_drawall()
l_drawall()
color(6)
line(0,63,128,63)
line(63,0,63,128)
print(#bullets)
end
-->8
-- bullet generation --

function 
b_gen(x,y,sp,dir,rot,script,sprite,drawmode)

bullet = {}
bullet.x = x
bullet.y = y
bullet.speed = sp
bullet.dir = dir	--0=down
bullet.rot = rot
bullet.script = script
--behavior
bullet.sprite = sprite
bullet.drawmode = drawmode
bullet.ttl = 0	--frames
bullet.visiable = 1
bullet.state = 0 --custom flag
add(bullets,bullet)
end

function l_gen_alt(x,y,len,sp,dir,script,width,col)
	l_gen(x,y,x+len*sin(dir),y+len*cos(dir),sp,script,width,col)
end

function l_gen(x1,y1,x2,y2,sp,script,width,col)

laser = {}
laser.x1 = x1
laser.y1 = y1
laser.x2 = x2
laser.y2 = y2
laser.speed = sp
laser.script = script
laser.width = width
laser.color = col
laser.dir = getdir(x1,y1,x2,y2)

laser.ttl = 0	--frames
laser.visiable = 1
laser.state = 0 --custom flag
add(lasers,laser)

end

function b_update(b)

if b.script != nil then
	b.script(b)
end

b.x += b.speed*sin(b.dir) 
b.y += b.speed*cos(b.dir)
--clean
if(b.x>148 or b.y >148 or b.x<-20 or b.y<-20) then
	del(bullets,b)
	b = nil
	return 1
end

b.dir += b.rot
b.ttl += 1
return 0
end

function l_update(l)

if l.script != nil then
	l.script(l)
end

l.x1 += l.speed*sin(l.dir)
l.y1 += l.speed*cos(l.dir)
l.x2 += l.speed*sin(l.dir)
l.y2 += l.speed*cos(l.dir)

--clean
if(l.x1>148 or l.y1 >148 or l.x1<-20 or l.y1<-20) then
	del(lasers,l)
	l = nil
	return 1
end

l.ttl += 1
return 0
end

function b_drawall()
	for b in all(bullets) do
		if(b.visiable) then
			if(b.drawmode == "sprite") then
					spr(b.sprite,b.x-4,b.y-4)
			elseif(b.drawmode == "draw") then
					draw[b.sprite](b)
				--draw using functions
			end
		end
	end
end

function l_drawall()
	for l in all(lasers) do
		if(l.visiable) then
			line(l.x1,l.y1,l.x2,l.y2,l.color)
		end
	end
end
-->8
-- script system --
-- game script
-- player script
-- boss script
-- bullet script
scripts = {}
scripts[1] = function(b) 
    if(b.ttl >= 60) then
        b.speed =1
    end
    if(b.x>=128) then
    	b.dir = getdir(b.x,b.y,63+rnd(10),100+rnd(10))
    	b.rot = 0
    	b.speed =0.6
    	b.sprite = 2
    end
end


-->8
-- bullet draw --
draw = {}
draw[1] = function(b) --laser
	line(b.x,b.y,b.x+10*sin(b.dir),b.y+10*cos(b.dir),7)
	line(b.x,b.y,b.x+11*sin(b.dir),b.y+11*cos(b.dir),0)
	line(b.x,b.y,b.x+9*sin(b.dir),b.y+9*cos(b.dir),0)
end
-->8
-- support functions --
function getdir(x1,y1,x2,y2)
	return (-0.25+atan2(x2-x1,y1-y2))
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000aa0000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000a77a000078870000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000a77a000078870000077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000aa0000007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
