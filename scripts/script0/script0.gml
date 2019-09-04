/// @description Boids simulator step 
var number_of_boids=ds_list_size(boids)
var xs
var ys
var directions
var speeds

for(var i=0; i<number_of_boids; i++){ 
	var b=ds_list_find_value(boids,i) // we get and store our boids map, as "b"
	xs[i]=ds_map_find_value(b,"x")//gather position, direction, and speed info from the map
	ys[i]=ds_map_find_value(b,"y")
	directions[i]=ds_map_find_value(b,"direction")
	speedss[i]=ds_map_find_value(b,"speed")
}


if keyboard_check_pressed(vk_backspace){//restart the game if we press backspace
	ds_list_destroy(boids)//clears the list from memory.
	room_restart()
}

var number_of_boids=ds_list_size(boids) // checks the size of the boid list

for(var i=0; i<number_of_boids; i++){ //loop through all boids. 
	var b=ds_list_find_value(boids,i) // we get and store our boids map, as "b"
	var bx=ds_map_find_value(b,"x")//gather position, direction, and speed info from the map
	var by=ds_map_find_value(b,"y")
	var bdirection=ds_map_find_value(b,"direction")
	var bspeed=ds_map_find_value(b,"speed")
	
	var bcount=1//used to average the poisiton of all boids in view
	var bmidx=bx // save our own X positon
	var bmidy=by
	
	for(var j=0; j<number_of_boids; j++){ //loop through all the boids again
		if (i != j){// make sure we dont compare against ourself
			var j=ds_list_find_value(boids,j)//find ds map for boid
			var jx=ds_map_find_value(j,"x")//get choords and direction info
			var jy=ds_map_find_value(j,"y")
			var jdirection=ds_map_find_value(j,"direction")
			var dis=point_distance(bx,by,jx,jy)//distance to other boid
			
			if dis<boid_view_distance{//if we are within our max visibility distance
				var dir=point_direction(bx,by,jx,jy)
				var dif=angle_difference(bdirection,dir)
				if abs(dif)<boid_view_angle{//and also inside our view cone

					bcount+=1//we are going to average these coords later.
					bmidx+=jx//they will give us the "center"
					bmidy+=jy//of all the other neatby boids we can see.
					
					bdirection+=dif/ max(dis/boid_avoid_strength,1)//avoid j boid
					bdirection-=angle_difference(bdirection,jdirection)/max(dis/boid_align_strength,1)//align with j boid
				}
			}
		}
	}
	
	bmidx=(bmidx/bcount)//we average all the coords we added together earlier
	bmidy=(bmidy/bcount)
	var dis=point_distance(bx,by,bmidx,bmidy)//measure the distance to this average point
	
	if dis>1{ //if we are more than one pixel away from our average point
		var dir=point_direction(bx,by,bmidx,bmidy)
		var dif=angle_difference(bdirection,dir)
		bdirection-=dif/max(dis/boid_center_strength,1)//fight for center of swarm
	}

	if mouse_check_button(mb_left){ //this gives the boids a new target, in this case the mouse.
		var dis=point_distance(bx,by,mouse_x,mouse_y)
		var dir=point_direction(bx,by,mouse_x,mouse_y)
		var dif=angle_difference(bdirection,dir)
		bdirection-= (dif/100)*min(5,dis)
	}

				
	var bxhold=bx+lengthdir_x(bspeed,bdirection) 
	var byhold=by+lengthdir_y(bspeed,bdirection) 
	var bdirhold=bdirection
	
	if  (bxhold<0)or(bxhold>room_width)or(byhold<0)or(byhold>room_height){
		var dirchange=5
		do{
			bdirection=bdirhold+(dirchange*choose(-1,1))
			dirchange+=1
			bxhold=bx+lengthdir_x(bspeed,bdirection) 
			byhold=by+lengthdir_y(bspeed,bdirection)
		}until((bxhold>0)and(bxhold<room_width)and(byhold>0)and(byhold<room_height))or(dirchange>180)
		
		if dirchange<180{
			bx=bxhold //actually move the boid
			by=byhold
		}
	}else{
		bx=bxhold //actually move the boid
		by=byhold
	}
	

	
	if bx<-32{bx=room_width+32}// a simple off screen wrap.
	if bx>room_width+32{bx=-32}
	if by<-32{by=room_height+32}
	if by>room_height+32{by=-32}
	
	
	ds_map_set(b,"x",bx)//finally we update the boid's map with our new data.
	ds_map_set(b,"y",by)
	ds_map_set(b,"direction",bdirection)
	ds_map_set(b,"speed",bspeed)
}