shader_type canvas_item;

uniform bool outline_enabled = true;
uniform vec4 outline_color : source_color = vec4(1.0);
// เพิ่ม Threshold สำหรับแยกแยะระหว่าง "เนื้อ Sprite" กับ "พื้นที่ว่าง"
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.1;

void fragment()
{
    vec2 pixel_size = TEXTURE_PIXEL_SIZE;
    vec4 current_color = texture(TEXTURE, UV);
    
    // แปลง Alpha ให้อยู่ในรูป 0.0 หรือ 1.0 ตามค่า Threshold
    float is_solid = step(alpha_threshold, current_color.a);

    // ดึงค่า Alpha จาก 4 ทิศทางรอบข้าง แล้วนำมาแปลงด้วย Threshold เดียวกัน
    float right_alpha  = step(alpha_threshold, texture(TEXTURE, UV + vec2(pixel_size.x, 0.0)).a);
    float left_alpha   = step(alpha_threshold, texture(TEXTURE, UV - vec2(pixel_size.x, 0.0)).a);
    float top_alpha    = step(alpha_threshold, texture(TEXTURE, UV - vec2(0.0, pixel_size.y)).a);
    float bottom_alpha = step(alpha_threshold, texture(TEXTURE, UV + vec2(0.0, pixel_size.y)).a);

    // เช็กว่าพิกเซลรอบข้างมีส่วนที่เป็นเนื้อ Sprite หรือไม่
    float neighbor_alpha = max(max(left_alpha, right_alpha), max(top_alpha, bottom_alpha));
    
    // สร้างเส้นขอบเฉพาะพื้นที่ที่พิกเซลปัจจุบัน "ไม่ใช่เนื้อ Sprite" (is_solid == 0) 
    // แต่มีพิกเซลข้างๆ เป็นเนื้อ Sprite (neighbor_alpha == 1)
    float outline_mask = 0.0;
    if (outline_enabled) {
        outline_mask = neighbor_alpha * (1.0 - is_solid);
    }

    // วาดสีเส้นขอบ หรือ สีเดิมของ Sprite
    if (outline_mask > 0.0) {
        COLOR = outline_color;
    } else {
        COLOR = current_color;
    }
}