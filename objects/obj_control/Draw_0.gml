
/// @description Boids simulator draw 
var number_of_boids=ds_list_size(boids) // checks the size of the boid list
										// we dont need to store this, but i did it in the step event
										// so to keep the code cleaner, im storing it here as well.

for(var i=0; i<number_of_boids; i++){//loop through all boids in our list
	var b=ds_list_find_value(boids,i)//find the boids map
	var bx=ds_map_find_value(b,"x")//pull position data for boid
	var by=ds_map_find_value(b,"y")
	var bdirection=ds_map_find_value(b,"direction")
	var bcolor=ds_map_find_value(b,"color")//find color
	
	draw_sprite_ext(spr_boid,0,bx,by,1,1,bdirection,bcolor,1)//finally, draw the boid
}

