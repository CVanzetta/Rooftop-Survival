🔧 Prompt MCP — Visuals Pack 0 (Godot 4)
Contexte

Repo: <REPO_URL>

Branche: feat/visuals-pack-0 → PR vers main : Visuals Pack 0 (sky, fog, wetness, props)

But: ciel, fog, post‑process, props simples, shader “wetness” piloté par la pluie.

Tâches
1) WorldEnvironment (ciel + fog + postprocess)
Éditer scenes/Main.tscn → WorldEnvironment :

Activer Sky avec ProceduralSkyMaterial :

sky_energy = 0.9, sky_top_color = #263340 (bleu nuit), sky_horizon_color = #3a4552

Fog activé :

volumetric_fog_enabled = true

fog_density = 0.02, fog_height = 10, fog_sky_affect = 0.6

Tonemap: ACES, exposure = 0.8

SSAO: enabled = true (radius 0.5, intensity 1.0)

Bloom: enabled = true (threshold 1.0, intensity 0.05)

2) Parapets + props low‑poly sur le toit
Dans scenes/world/Roof.tscn, sous RoofRoot :

Parapets (quatre MeshInstance3D BoxMesh hauteur 1, épaisseur 0.2, autour du plateau).

HVAC_Unit (deux BoxMesh empilés 1.2×0.8×0.8 + 0.9×0.5×0.5).

Water_Tank (CylinderMesh 0.6×1.2).

Matériaux StandardMaterial3D :

Sol: gris #2b2f33 (roughness 0.95).

Parapets: #3a3f44.

HVAC: #6f7a84, metalness 0.1.

Tank: #5a6a7a, metalness 0.05.

3) Shader “Wetness” (sol qui se mouille)
Nouveau fichier shaders/wet_floor.tres (ShaderMaterial) avec shader :

glsl
Copier le code
shader_type spatial;
render_mode cull_back;

uniform float wetness : hint_range(0.0, 1.0) = 0.0;
uniform vec3 base_color : source_color = vec3(0.17, 0.18, 0.20);

void fragment() {
    float w = clamp(wetness, 0.0, 1.0);
    ALBEDO = mix(base_color, base_color * 0.75, w); // plus sombre mouillé
    ROUGHNESS = mix(0.95, 0.25, w);
    METALLIC = 0.0;
}
Assigner ce ShaderMaterial au Floor (MeshInstance3D) de Roof.tscn.

4) Contrôleur de pluie → wetness
Nouveau scripts/WetnessController.gd :

gdscript
Copier le code
extends Node
class_name WetnessController

@onready var weather: Weather = $"../Weather"
@onready var roof: Node3D = $"../World/RoofRoot/Floor"
var wetness: float = 0.0

func _process(delta: float) -> void:
    var rain: float = float(weather.profile.get("rain", 0.0))
    var target: float = clamp(rain, 0.0, 1.0)
    # séchage lent, mouillage un peu plus rapide
    var rate: float = (3.0 if target > wetness else 0.5)
    wetness = clamp(lerp(wetness, target, rate * delta), 0.0, 1.0)
    if roof and roof.get_surface_override_material_count() > 0:
        var mat := roof.get_surface_override_material(0)
        if mat and mat.has_method("set_shader_parameter"):
            mat.set_shader_parameter("wetness", wetness)
Ajouter WetnessController sous Main et vérifier le chemin vers Floor.

5) Vignette discrète (HUD overlay)
Nouvelle scène scenes/ui/Vignette.tscn (CanvasLayer > ColorRect “Vignette”) :

Plein écran, Material Shader :

glsl
Copier le code
shader_type canvas_item;
uniform float strength = 0.35;
void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float v = smoothstep(0.6, 1.0, length(uv));
    COLOR = vec4(0.0, 0.0, 0.0, v * strength);
}
Instancier Vignette sous Main (au‑dessus du HUD).

6) Pluie visible (ajustements rapides)
RainFX (GPUParticles3D) sous Main :

amount = 1200, lifetime = 1.2, speed_scale = 1.0

emission_box_extents = (30, 1, 30), position.y = 12

gravity = (0, -20, 0), direction = (0, -1, 0), scale curve légère si dispo.

Dans RainController.gd, clamp amount : int(1200.0 * clamp(r, 0.15, 1.0)).

7) README
Ajouter section “Visuals Pack 0” (sky, fog, wetness, vignette) + capture rapide.

8) Commits
feat: add procedural sky, fog and postprocess

feat: add roof parapets and simple props

feat: add wetness shader and controller bound to rain

feat: add vignette overlay and tweak rain particles

docs: update README with Visuals Pack 0

9) Critères d’acceptation
Lancement → ciel visible, fog doux, éclairage crédible.

Parapets/props présents, ombres OK.

Quand rain > 0.1 → sol s’assombrit et devient plus brillant; redevient mat quand la pluie cesse.

Vignette visible mais discrète (pas de gêne pour lire le HUD).

