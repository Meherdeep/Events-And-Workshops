$(document).ready(function () {
	var canvas = $('#canvas')[0];
	var ctx = canvas.getContext("2d");
	var w = $('#canvas').width();
	var h = $('#canvas').height();

	var d;
	var score;
	var cw = 10;
	var food; 
	var snake_array;


	function init() {
		d = "right";
		create_snake();
		create_food();
		score = 0;

		if (typeof game_loop != "undefined") {
			clearInterval(game_loop)
		}
		game_loop = setInterval(paint, 100);
	}
	init();
	function create_snake() {
		var length = 5;
		snake_array = [];
		for (var i = length - 1; i >= 0; i--) {
			snake_array.push({
				x: i,
				y: 0
			})
		}
	}
	function create_food() {
		food = {
			x: Math.round(Math.random()*(w-cw)/cw),
			y: Math.round(Math.random()*(h-cw)/cw)
		};
	}

	function paint() {
		ctx.fillStyle = "white";
		ctx.fillRect(0,0,w,h);
		ctx.strokeStyle = "black";
		ctx.strokeRect(0,0,w,h);

		var nx = snake_array[0].x;
		var ny = snake_array[0].y;

		if (d == "right") {
			nx++;
		}
		else if(d == "left"){
			nx--;
		}
		else if(d == "up"){
			ny--;
		}
		else if(d == "down"){
			ny++;
		}

		if (check_collision(nx, ny, snake_array) || nx == -1 || ny == -1 || nx == w/cw || ny == h/cw) {
			init();
			return;
		}

		if (nx == food.x && ny == food.y) {
			var tail = {
				x: nx,
				y: ny
			}
			score++;

			create_food();
		} else {
			var tail = snake_array.pop();
			tail.x = nx;
			tail.y = ny;
		}

		for(var i=0; i<snake_array.length; i++){
			var c = snake_array[i];
			paint_cell(c.x, c.y, "blue")
		}

		snake_array.unshift(tail);

		paint_cell(food.x, food.y, "red");
		
		var score_text = "Score: " + score;
		ctx.fillText(score_text,5,h-5);

	}

	function paint_cell(x, y, color) {
		ctx.fillStyle = color;
		ctx.fillRect(x*cw, y*cw, cw, cw);
		ctx.strokeStyle = "white"
		ctx.strokeRect(x*cw, y*cw, cw, cw)
	}

	function check_collision(x, y , array) {
		for(var i =0; i< array.length; i++){
			if (array[i].x == x && array[i].y == y) {
				return true;
			}
			return false;
		}
	}


	$(document).keydown(function (e) { 
		var key = e.which;
		if (key == "37" && d != "right") {
			d = "left";
		}
		else if(key == "38" && d != "down"){
			d = "up";
		}
		else if(key == "39" && d != "left"){
			d = "right";
		}
		else if(key == "40" && d != "up"){
			d = "down";
		}
	});
})