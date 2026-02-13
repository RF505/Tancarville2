shader_type canvas_item;

uniform vec2 player_position; // Reçoit le normalized_pos du script
uniform float mask_radius = 0.15; // Rayon (entre 0.0 et 1.0)
uniform float feather = 0.05;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Calcul de la distance en tenant compte du ratio de l'écran
    float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    vec2 diff = SCREEN_UV - player_position;
    diff.x *= aspect_ratio; 
    float dist = length(diff);
    
    // 0.0 au centre (joueur), 1.0 à l'extérieur
    float mask = smoothstep(mask_radius, mask_radius + feather, dist);
    
    // Exemple d'effet : le shader rend la tilemap rouge
    vec3 effect_color = vec3(1.0, 0.0, 0.0) * color.rgb;
    
    // Mix : si mask = 0 (proche joueur), on garde color.rgb (original)
    COLOR.rgb = mix(color.rgb, effect_color, mask);
    COLOR.a = color.a;
}