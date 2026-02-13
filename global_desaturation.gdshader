shader_type canvas_item;

uniform vec2 player_position;
uniform float color_radius = 0.0;
uniform float desaturation_strength = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    vec2 pixel_pos = FRAGCOORD.xy;
    float distance = length(pixel_pos - player_position);
    
    float desat_factor = smoothstep(0.0, color_radius, distance) * desaturation_strength;
    
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 gray_color = vec3(gray);
    
    COLOR.rgb = mix(color.rgb, gray_color, desat_factor);
    COLOR.a = color.a;
}