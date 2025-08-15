shader_type canvas_item;

uniform vec4 from : source_color;
uniform vec4 to : source_color;
uniform float threshold;
uniform float intensity;

void fragment() {
    vec4 color = texture(TEXTURE,UV);

	float distance = length(from - color);

	if (distance < threshold)
	{
		COLOR = color * (to + intensity * abs(distance - threshold));
	}
	else
	{
		COLOR = color;
	}


}