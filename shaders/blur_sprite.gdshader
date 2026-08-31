shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float max_blur : hint_range(0.0, 15.0) = 8.0;
uniform float max_dispersion : hint_range(0.0, 0.05) = 0.02;

void fragment() {
    float inv_p = 1.0 - progress;
    float current_blur = max_blur * inv_p;
    float current_disp = max_dispersion * inv_p;
    
    vec4 col = vec4(0.0);
    // Radial sampling 8 Directions for dispersion blur
    for(int i = 0; i < 8; i++) {
        float angle = float(i) * 0.785398;
        vec2 dir = vec2(cos(angle), sin(angle));
        vec2 uv_off = UV + dir * current_disp;
        col += textureLod(TEXTURE, uv_off, current_blur);
    }
    COLOR = col / 8.0;
}