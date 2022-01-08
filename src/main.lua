local vector = require("vector")
--cobrona😏

cobra = {
	x = 0,
	y = 0,

	xvel = 1,
	yvel = 0,
	direcao = "direita",

	total = 1,
	cauda = {}
}



function dir(x, y)
	cobra.xvel = x
	cobra.yvel = y
end 
--comida
function escolherlocal()
	fileiras = math.floor(600/scl)
	colunas = math.floor(600/scl)
	comida = vector(math.floor(love.math.random(colunas)),math.floor(love.math.random(fileiras)))
	comida = comida * 20
end



--morte

function ded()
	for i = 0, #cobra.cauda, 1 do
		local pos = cobra.cauda[i]
		if cobra.x == pos.x and cobra.y == pos.y then
			print("game over")
			estado = "Game over"
		end
		if cobra.x > 600 or cobra.y > 640 or cobra.x < 0 or cobra.y < 0 then
			print("game over")
			estado = "Game over"
		end
	end
end

--gameloop


function love.load()
	fontPixel = love.graphics.newFont("pressstart2p.ttf", 17)
	pontos = 0
	estado = "jogo"
	scl = 20
	fps = 10
	escolherlocal()
end

function love.update(dt)
	if estado == "jogo" then 
--cap fps
		if dt < 1/fps then
			love.timer.sleep(1/fps - dt)
		end
--crescimento da cobra
		for i = 0, #cobra.cauda - 1 , 1 do
			cobra.cauda[i] = cobra.cauda[i+1]
		end

		if cobra.total >= 1 then 
			cobra.cauda[cobra.total-1] = vector(cobra.x, cobra.y)
		end
--movimento
		cobra.x = cobra.x + cobra.xvel*scl
		cobra.y = cobra.y + cobra.yvel*scl
		comer()
		ded()
		pegardirecao()
	end
end

function love.draw()
	love.graphics.setBackgroundColor(26/255, 23/255, 36/255)
	if estado == "jogo" then 
		for i = 0, #cobra.cauda, 1 do
			love.graphics.setColor(48/255, 115/255, 143/255)
			love.graphics.rectangle("fill", cobra.cauda[i].x, cobra.cauda[i].y, 20, 20)
		end 
		love.graphics.rectangle("fill", cobra.x, cobra.y, scl, scl)
		love.graphics.setColor(235/255, 189/255, 186/255)
		love.graphics.rectangle("fill", comida.x, comida.y, scl, scl)
		love.graphics.setFont(fontPixel)
		love.graphics.setColor(235/255, 112/255, 145/255)
		love.graphics.print("pontuação:"..pontos, 210, 20)
	else
		love.graphics.setColor(224/255, 222/255, 245/255)
		love.graphics.setFont(fontPixel)
		love.graphics.print("	     Game over!\naperte espaço pra recomeçar!",70, 270)
	end
end


--teclas 


function love.keypressed(key)
	if cobra.direcao ~= "baixo" and  estado == "jogo" and key == "up" then
		dir(0, -1)
	end
	
	if cobra.direcao ~= "cima" and estado == "jogo" and key == "down" then
		dir(0, 1)
	end 

	if cobra.direcao ~= "esquerda" and estado == "jogo" and key == "right" then 
		dir(1, 0)
	end

	if cobra.direcao ~= "direita" and estado == "jogo" and key == "left" then
		dir(-1, 0)
	end

	if key == "escape" then
		love.event.quit()
	end

	if estado == "Game over" and key == "space" then
		love.event.quit("restart")
	end
end

--colisão 

function comer()
	if cobra.x == comida.x and cobra.y == comida.y then
		escolherlocal()
		cobra.total = cobra.total + 1
		pontos = pontos + 1
	end
end

function pegardirecao()

	if cobra.xvel == 0 and cobra.yvel == -1 then
		cobra.direcao = "cima"
	end
	
	if cobra.xvel == 0 and cobra.yvel == 1 then
		cobra.direcao = "baixo"
	end 

	if cobra.xvel == 1 and cobra.yvel == 0 then 
		cobra.direcao = "direita"
	end

	if cobra.xvel == -1 and cobra.yvel == 0 then
		cobra.direcao = "esquerda"
	end

end
