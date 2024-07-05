uniform vec3 left_leg_lower;
uniform vec3 left_leg_upper;
uniform vec3 left_leg_knee;
uniform vec3 right_leg_lower;
uniform vec3 right_leg_upper;
uniform vec3 right_leg_knee;
uniform vec3 metallic_trim;
uniform vec3 right_trim;
uniform vec3 left_trim;
uniform vec3 left_chest;
uniform vec3 main_colour;
uniform vec3 right_chest;
uniform vec3 left_thorax;
uniform vec3 right_thorax;
uniform vec3 left_pauldron;
uniform vec3 right_pauldron;
uniform vec3 left_head;
uniform vec3 right_head;
uniform vec3 left_muzzle;
uniform vec3 right_muzzle;
uniform vec3 left_arm;
uniform vec3 right_arm;
uniform vec3 left_hand;
uniform vec3 right_hand;
uniform vec3 eye_lense;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
    if (col.rgb == vec3(0.0,0.0, 128.0/255.0).rgb){
        col.rgb = left_head.rgb;
    };
     if (col.rgb == vec3(0.0,0.0, 1.0).rgb){
         col.rgb = right_head.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,64.0/255.0, 1.0).rgb){
         col.rgb = left_muzzle.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,128.0/255.0, 1.0).rgb){
         col.rgb = right_muzzle.rgb;
    };
     if (col.rgb == vec3(0.0,1.0, 0.0).rgb){
        col.rgb = eye_lense.rgb;
    };
     if (col.rgb == vec3(1.0,20.0/255.0, 147.0/255.0).rgb){
        col.rgb = right_chest.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,0.0, 128.0/255.0).rgb){
        col.rgb = left_chest.rgb;
    };
     if (col.rgb == vec3(0.0,128.0/255.0, 128.0/255.0).rgb){
        col.rgb = right_trim.rgb;
    };
     if (col.rgb == vec3(1.0,128.0/255.0, 0.0).rgb){
        col.rgb = left_trim.rgb;
    };
     if (col.rgb == vec3(135.0/255.0,130.0/255.0, 188.0/255.0).rgb){
        col.rgb = metallic_trim.rgb;
    };
     if (col.rgb == vec3(1.0,1.0, 1.0).rgb){
        col.rgb = right_pauldron.rgb;
    };
     if (col.rgb == vec3(1.0,1.0, 0.0).rgb){
        col.rgb = left_pauldron.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,0.0/255.0, 128.0/255.0).rgb){
        col.rgb = right_leg_upper.rgb;
    };
     if (col.rgb == vec3(255.0/255.0,7.0/255.0, 170.0/255.0).rgb){
        col.rgb = left_leg_upper.rgb;
    };
     if (col.rgb == vec3(1.0,0.0, 0.0).rgb){
        col.rgb = left_leg_knee.rgb;
    };
     if (col.rgb == vec3(128.0/255.0,0.0/255.0, 0.0/255.0).rgb){
        col.rgb = left_leg_lower.rgb;
    };
     if (col.rgb == vec3(214.0/255.0,194.0/255.0, 255.0/255.0).rgb){
        col.rgb = right_leg_knee.rgb;
    };
     if (col.rgb == vec3(165.0/255.0,84.0/255.0, 24.0/255.0).rgb){
        col.rgb = right_leg_lower.rgb;
    }
    gl_FragColor = v_vColour * col;

}
