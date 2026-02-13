shader_type canvas_item;

uniform vec2 player_position; // Position du joueur en UV normalisées
uniform float radius = 0.15;    
uniform float feather = 0.05;   

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    
    // Calcul de la distance entre le pixel actuel et le joueur
    float dist = distance(SCREEN_UV, player_position);
    
    // INVERSÉ : mask = 0 autour du joueur, mask = 1 loin du joueur
    float mask = smoothstep(radius - feather, radius, dist);
    
    // --- EFFET CALQUE ---
    // Option 1 : Noir et blanc
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 filtered_color = vec3(gray);
    
    // Option 2 : Teinte sépia (décommentez pour tester)
    // vec3 filtered_color = vec3(
    //     dot(color.rgb, vec3(0.393, 0.769, 0.189)),
    //     dot(color.rgb, vec3(0.349, 0.686, 0.168)),
    //     dot(color.rgb, vec3(0.272, 0.534, 0.131))
    // );
    
    // Option 3 : Teinte bleue froide (décommentez pour tester)
    // vec3 filtered_color = color.rgb * vec3(0.7, 0.8, 1.0);
    
    // Option 4 : Assombri (décommentez pour tester)
    // vec3 filtered_color = color.rgb * 0.5;
    
    // Mélange : mask = 0 (près du joueur) = couleur normale
    //           mask = 1 (loin du joueur) = filtre appliqué
    COLOR.rgb = mix(color.rgb, filtered_color, mask);
    COLOR.a = color.a;
}