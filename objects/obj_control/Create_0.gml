/// @description Boids simulator
//               WubsGames
//               http://wubsgames.com

randomize()

boid_total_amount=100//total amount of boids in our simulation
boid_view_angle=125//the max "vision cone" angle of a boid
boid_view_distance=96//the max view distance of a boid
boid_avoid_strength=1//how hard a boid will fight to avoid other boids
boid_align_strength=1 // how much a boid will try to allign its direction with nearby boids
boid_center_strength=3 //how much a boid will fight to get to the center of a flock.

boids=ds_list_create()//this list will store our boids.

repeat(boid_total_amount){//making our boids
	var b=ds_map_create()//each boid is a ds map, instead of an object.
	ds_map_add(b,"x",16+random(room_width-32))//random x
	ds_map_add(b,"y",16+random(room_height-32))//and y
	ds_map_add(b,"speed",random(2)+2)// the overall speed of our boids
	ds_map_add(b,"direction",random(360))//direction, also random
	ds_map_add(b,"color",make_color_hsv(random(255),128+random(127),128+random(127)))//random color
	ds_list_add(boids,b)//this adds the map we created to the list of boids
}