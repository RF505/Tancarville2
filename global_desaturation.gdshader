shader_type canvas_item;

uniform vec2 player_position; 
uniform float radius = 100.0;
uniform float feather = 50.0;

varying vec2 world_pos;

void vertex() {
    // MODEL_MATRIX transforme les points de l'objet vers le monde (World Space)
    // On multiplie par VERTEX pour obtenir la position réelle dans le niveau
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Calcul de la distance entre le pixel (monde) et le joueur (monde)
    float dist = distance(world_pos, player_position);
    
    // On crée le masque de désaturation
    float mask = smoothstep(radius, radius + feather, dist);
    
    float gray = dot(color.rgb, vec3(.299, 0.587, 0.114));
    vec3 grey_version = vec3(gray);
    
    COLOR.rgb = mix(color.rgb, grey_version, mask);
    COLOR.a = color.a;
}