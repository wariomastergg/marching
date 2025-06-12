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

vec3 view(float x, float y, float lx, float ly,   float xa, float ya, vec3 p){
    float a1 = ( ( (((x-0.5)*2.0)*(xa/2.0)) + lx ) /360.0)*2.0*PI ;
    float a2 = (3.0*PI/2.0) +  ( ( (((y-0.5)*2.0)*(ya/2.0)) + ly) /360.0 )*2.0*PI;
	return vec3(cos(a1)*sin(a2), sin(a1), cos(a1)*cos(a2));
	
}

float bisect(float a, float b){
	return( ceil(a-abs(b-.5)-.5) );
}

uniform vec3 pt = vec3(8.568, -0.640, 3.816);

uniform vec2 a = vec2(0.);

uniform vec3 ci = vec3( 0., 0., 0. ); 
uniform float si = 1.65;

uniform vec3 cb = vec3( 0., 0., 0. );
uniform vec3 cbsi = vec3(1.);


//uniform int[5] voxels;

uniform sampler2D img : filter_nearest ;
uniform sampler2D img2 : filter_nearest ;
uniform sampler2D img3 : filter_nearest ;
uniform sampler2D img4 : filter_nearest ;

uniform float mv = 0.;
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
		
		
        float f = max(cube(d, cbsi, cb), -cube(d, vec3(2.,2.,1.), vec3(0.,mv,0.)) ) ;
        
        float b = 1152./648.;
        d = d + ( f * rotate_x( rotate_y( view(UV.x, UV.y, 0, -90, 45.0*b, 45.0, pt) , (a.y/360.)*2.*PI ) , (a.x/360.)*2.*PI) );
        
        if (f<0.014){
			//COLOR.r = sphere( vec3(d.x+1.0, d.y, d.z) , ci, si);
            //COLOR.g = sphere( vec3(d.x, d.y+1.0, d.z) , ci, si);
            //COLOR.b = sphere( vec3(d.x, d.y, d.z+1.0) , ci, si);
			
			
            float a1 = cube( vec3(d.x+(cbsi.x*2.), d.y, d.z) , cbsi, cb)/2.;
            float a2 = cube( vec3(d.x, d.y+(cbsi.y*2.), d.z) , cbsi, cb)/2.;
            float a3 = cube( vec3(d.x, d.y, d.z+(cbsi.z*2.)) , cbsi, cb)/2.;
			//COLOR.r =
			//COLOR.g =
			//COLOR.b =
			//COLOR = 
			float thresh = 0.9999999;
			float thresh2 = 1.-thresh;
			
			if(false){
			if (a2 > thresh){
				COLOR = texture(img2, vec2(a3,a1));
			}
			if ( a2 < thresh2){
				COLOR = texture(img2, vec2(a3,a1));
			}
			
			if (a3 > thresh){
				COLOR = texture(img3, vec2(a2,1.-a1));
			}
			if (a3 < thresh2){
				COLOR = texture(img3, vec2(a2,1.-a1));
			}
			
			if (a1 > thresh){
				COLOR = texture(img, vec2(a2,a3));
			}
			if (a1 < thresh2){
				COLOR = texture(img4, vec2(a2,a3));
			}
			}
			COLOR = vec4(1.)*bisect(a1,a2)*bisect(a1,a3) ;
			//COLOR += texture(img2, vec2(a3,a1))*(a2);
			//COLOR += texture(img2, vec2(a3,a1))*(1.-a2);
			//COLOR *= texture(img2, vec2(a3,a1))*(a2- ( (abs(mod(a1,1.)-.5)+.5)*(abs(mod(a3,1.)-.5)+.5) ) );
			//COLOR *= texture(img3, vec2(a2,a1))*(a3- ( (abs(mod(a1,1.)-.5)+.5)*(abs(mod(a2,1.)-.5)+.5) ) );
			
			//COLOR += texture(img3, vec2(a2,1.-a1))*a3;
			//COLOR += texture(img3, vec2(a2,1.-a1))*(1.-a3);
			
			//COLOR += texture(img, vec2(a2,a3))*a1;
			//COLOR += texture(img4, vec2(a2,a3))*(1.-a1);
			
			//COLOR = vec4(a1,a2,a3,1.);
            //color.r = 1.0;
            break;
        }
        
    }
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
