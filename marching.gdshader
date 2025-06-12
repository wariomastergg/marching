shader_type canvas_item;

float cube(vec3 p, vec3 c, vec3 po){
	
    return length(max(abs(p-po)-c,0.)) + min(max(max(abs(p.x-po.x)-c.x,abs(p.y-po.y)-c.y), abs(p.z-po.z)-c.z ),0);
}
float sphere(vec3 p, vec3 c, float r){
    return length(p-c)-r;
}

vec3 rotate_x( vec3 vect, float ang){
	mat4 xr_mtx = mat4(
	vec4(1.0, 0.0, 0.0, 0.0),
	vec4(0.0, cos(ang), -sin(ang), 0.0),
	vec4(0.0, sin(ang), cos(ang), 0.0),
	vec4(0.0, 0.0, 0.0, 1.0)
		);
	vec4 inp = vec4( vect , 1.0);
	
	inp = inp*xr_mtx; 
		
	return vec3(inp[0], inp[1], inp[2]);
}

vec3 rotate_y( vec3 vect , float ang){
	mat4 xr_mtx = mat4(
	vec4(cos(ang), 0.0, sin(ang), 0.0),
	vec4(0.0, 1.0, 0.0, 0.0),
	vec4(-sin(ang), 0.0, cos(ang), 0.0),
	vec4(0.0, 0.0, 0.0, 1.0)
		);
	vec4 inp = vec4(vect, 1.0);
	
	inp = inp*xr_mtx; 
		
	return vec3(inp[0], inp[1], inp[2] );
}

vec3 rotate_z( vec3 vect, float ang){
	mat4 xr_mtx = mat4(
	vec4(cos(ang), -sin(ang), 0.0, 0.0),
	vec4(sin(ang), cos(ang), 0.0, 0.0),
	vec4(0.0, 0.0, 1.0, 0.0),
	vec4(0.0, 0.0, 0.0, 1.0)
		);
	vec4 inp = vec4(vect, 1.0);
	
	inp = inp*xr_mtx; 
		
	return vec3(inp[0], inp[1], inp[2]);
}	

vec3 view(float x, float y, float lx, float ly,   float xa, float ya){
    float a1 = ( ( (((x-0.5)*2.0)*(xa/2.0)) + lx ) /360.0)*2.0*PI ;
    float a2 = (3.0*PI/2.0) +  ( ( (((y-0.5)*2.0)*(ya/2.0)) + ly) /360.0 )*2.0*PI;
    return vec3(cos(a1)*sin(a2), sin(a1), cos(a1)*cos(a2));
}

uniform vec3 pt = vec3(8.568, -0.640, 3.816);

uniform vec2 a = vec2(0.);

uniform vec3 ci = vec3( 0., 0., 0. ); 
uniform float si = 1.65;

uniform vec3 cb = vec3( 0., 0., 0. );
uniform vec3 cbsi = vec3(1.);

uniform vec3 cb2 = vec3( 0., 0., 0. );
uniform vec3 cbsi2 = vec3(1.);

uniform vec3 cb3 = vec3( 0., 0., 0. );
uniform vec3 cbsi3 = vec3(1.); 

uniform vec3 cb4 = vec3( 0., 0., 0. );
uniform vec3 cbsi4 = vec3(1.);

uniform vec3 cb5 = vec3( 0., 0., 0. );
uniform vec3 cbsi5 = vec3(1.); 


const float pi = 3.14159265359;


void vertex() {
	
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	
	vec3 d = pt;
    
    //d.z += sin(u_time)/3.0;
    //d.y += -c(m.x);
    vec3 color = vec3(0.);
	
    for (int i = 0; i< 50; i++){
        //float f = sdTorus(pt, vec2(0.0));
        //float f = sphere(d, ci, si);
	
        float f =min(max(max(max(cube(d, cbsi, cb), -cube(d, cbsi2, cb2)), -cube(d, cbsi3, cb3)), -cube(d, cbsi4, cb4)), sphere(d, ci, si));
        
        float b = 1152./648.;
        d = d + ( f * rotate_x( rotate_y( view(UV.x, UV.y, 0, -90, 45.0*b, 45.0) , (a.y/360.)*2.*PI ) , (a.x/360.)*2.*PI) );
        
        if (f<0.014){
			//COLOR.r = sphere( vec3(d.x+1.0, d.y, d.z) , ci, si);
            //COLOR.g = sphere( vec3(d.x, d.y+1.0, d.z) , ci, si);
            //COLOR.b = sphere( vec3(d.x, d.y, d.z+1.0) , ci, si);
			
            COLOR.r = cube( vec3(d.x+1.0, d.y, d.z) , cbsi, cb);
            COLOR.g = cube( vec3(d.x, d.y+1.0, d.z) , cbsi, cb);
            COLOR.b = cube( vec3(d.x, d.y, d.z+1.0) , cbsi, cb);
            //color.r = 1.0;
            break;
        }
        
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
