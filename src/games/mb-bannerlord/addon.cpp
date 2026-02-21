/*
 * Copyright (C) 2024 Carlos Lopez
 * SPDX-License-Identifier: MIT
 */

#define ImTextureID ImU64

#define DEBUG_LEVEL_0

#include <deps/imgui/imgui.h>
#include <include/reshade.hpp>

#include <embed/shaders.h>

#include "../../mods/shader.hpp"
#include "../../mods/swapchain.hpp"
#include "../../utils/settings.hpp"
#include "./shared.h"
#include "../../utils/random.hpp"
#include "../../utils/date.hpp"
#include <dxgiformat.h>
#include <include/reshade_api_format.hpp>

namespace {

renodx::mods::shader::CustomShaders custom_shaders = {__ALL_CUSTOM_SHADERS};

ShaderInjectData shader_injection;

float current_settings_mode = 2.f;

renodx::utils::settings::Settings settings = {
    new renodx::utils::settings::Setting{
        .key = "SettingsMode",
        .binding = &current_settings_mode,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 2.f,
        .can_reset = false,
        .label = "Settings Mode",
        .labels = {"Simple", "Intermediate", "Advanced"},
        .is_global = true,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapType",
        .binding = &shader_injection.tone_map_type,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .can_reset = true,
        .label = "Tone Mapper",
        .section = "Tone Mapping",
        .tooltip = "Sets the tone mapper type",
        .labels = {"Vanilla", "RenoDRT"},
        .parse = [](float value) {
            // Map UI index to engine enum: 0 = Vanilla, 1 = RenoDRT (enum value 3)
            return (value >= 1.f) ? 3.f : 0.f;
        },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapPeakNits",
        .binding = &shader_injection.peak_white_nits,
        .default_value = 1000.f,
        .can_reset = true,
        .label = "Peak Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of peak white in nits",
        .min = 48.f,
        .max = 4000.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapGameNits",
        .binding = &shader_injection.diffuse_white_nits,
        .default_value = 203.f,
        .label = "Game Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the value of 100% white in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "ToneMapUINits",
        .binding = &shader_injection.graphics_white_nits,
        .default_value = 203.f,
        .label = "UI Brightness",
        .section = "Tone Mapping",
        .tooltip = "Sets the brightness of UI and HUD elements in nits",
        .min = 48.f,
        .max = 500.f,
    },
    new renodx::utils::settings::Setting{
        .key = "GammaCorrection",
        .binding = &shader_injection.gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "Gamma Correction",
        .section = "Tone Mapping",
        .tooltip = "Emulates a display EOTF.",
        .labels = {"Off", "2.2", "BT.1886"},
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "SwapChainGammaCorrection",
        .binding = &shader_injection.swap_chain_gamma_correction,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 1.f,
        .label = "UI Gamma Correction",
        .section = "Tone Mapping",
        .labels = {"None", "2.2", "2.4"},
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .is_visible = []() { return current_settings_mode >= 2; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeExposure",
        .binding = &shader_injection.tone_map_exposure,
        .default_value = 1.f,
        .label = "Exposure",
        .section = "Color Grading",
        .max = 2.f,
        .format = "%.2f",
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlights",
        .binding = &shader_injection.tone_map_highlights,
        .default_value = 50.f,
        .label = "Highlights",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeShadows",
        .binding = &shader_injection.tone_map_shadows,
        .default_value = 50.f,
        .label = "Shadows",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeContrast",
        .binding = &shader_injection.tone_map_contrast,
        .default_value = 50.f,
        .label = "Contrast",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeSaturation",
        .binding = &shader_injection.tone_map_saturation,
        .default_value = 50.f,
        .label = "Saturation",
        .section = "Color Grading",
        .max = 100.f,
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeHighlightSaturation",
        .binding = &shader_injection.tone_map_highlight_saturation,
        .default_value = 50.f,
        .label = "Highlight Saturation",
        .section = "Color Grading",
        .tooltip = "Adds or removes highlight color.",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type >= 1; },
        .parse = [](float value) { return value * 0.02f; },
        .is_visible = []() { return current_settings_mode >= 1; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeBlowout",
        .binding = &shader_injection.tone_map_dechroma,
        .default_value = 0.f,
        .label = "Blowout",
        .section = "Color Grading",
        .tooltip = "Controls highlight desaturation due to overexposure.",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeFlare",
        .binding = &shader_injection.tone_map_flare,
        .default_value = 0.f,
        .label = "Flare",
        .section = "Color Grading",
        .tooltip = "Flare/Glare Compensation",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type == 3; },
        .parse = [](float value) { return value * 0.02f; },
    },
    new renodx::utils::settings::Setting{
        .key = "ColorGradeScene",
        .binding = &shader_injection.color_grade_strength,
        .default_value = 100.f,
        .label = "LUT Strength",
        .section = "Color Grading",
        .tooltip = "LUT strength as applied by the game",
        .max = 100.f,
        .is_enabled = []() { return shader_injection.tone_map_type > 0; },
        .parse = [](float value) { return value * 0.01f; },
    },
    new renodx::utils::settings::Setting({
        .key = "FxGrainStrength",
        .binding = &shader_injection.custom_grain_strength,
        .default_value = 0.f,
        .label = "Perceptual Grain Strength",
        .section = "Effects",
        .parse = [](float value) { return value * 0.01f; },
        }),

    new renodx::utils::settings::Setting({
        .key = "FxBloomStrength",
        .binding = &shader_injection.custom_bloom_strength,
        .default_value = 100.f,
        .label = "Bloom Strength",
        .section = "Effects",
        .min = 0.f,
        .max = 100.f,
        .format = "%.0f",
        .parse = [](float value) { return value * 0.01f; },
        }),

    new renodx::utils::settings::Setting({
        .key = "FxAutoExposure",
        .binding = &shader_injection.custom_auto_exposure,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Highlight-Aware Exposure",
        .section = "Effects",
        .tooltip = "Reduces auto-exposure strength on highlights to preserve bright detail",
        }),

    new renodx::utils::settings::Setting({
        .key = "FxSunIntensity",
        .binding = &shader_injection.custom_sun_intensity,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "HDR Sun",
        .section = "Effects",
        .tooltip = "Enables brighter and smaller sun disk for HDR",
        }),
    new renodx::utils::settings::Setting({
        .key = "FxAoDebug",
        .binding = &shader_injection.custom_ao_debug,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "AO Debug View",
        .section = "Effects",
        .tooltip = "Visualizes the ambient occlusion buffer",
        .is_visible = []() { return current_settings_mode >= 2; },
        }),

    new renodx::utils::settings::Setting({
        .key = "FxAoBypass",
        .binding = &shader_injection.custom_ao_bypass,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 0.f,
        .label = "Disable AO",
        .section = "Effects",
        .tooltip = "Bypasses ambient occlusion application entirely",
        .is_visible = []() { return current_settings_mode >= 1; },
        }),

    new renodx::utils::settings::Setting({
        .key = "FxProbeModulation",
        .binding = &shader_injection.custom_probe_modulation,
        .default_value = 50.f,
        .label = "Probe Modulation",
        .section = "Effects",
        .tooltip = "Controls how much specular probe reflections are attenuated in dark ambient areas.\n0 = Off, 100 = Maximum attenuation",
        .max = 100.f,
        .parse = [](float value) { return value * 0.01f; },
        }),

    new renodx::utils::settings::Setting({
        .key = "FxBurleyDiffuse",
        .binding = &shader_injection.custom_burley_diffuse,
        .value_type = renodx::utils::settings::SettingValueType::BOOLEAN,
        .default_value = 1.f,
        .label = "Burley Diffuse",
        .section = "Effects",
        .tooltip = "Replaces the vanilla Lambertian (1/pi) diffuse BRDF with Disney/Burley diffuse for improved roughness-dependent shading",
        }),

    new renodx::utils::settings::Setting{
        .key = "SwapChainCustomColorSpace",
        .binding = &shader_injection.swap_chain_custom_color_space,
        .value_type = renodx::utils::settings::SettingValueType::INTEGER,
        .default_value = 0.f,
        .label = "Custom Color Space",
        .section = "Display Output",
        .tooltip = "Selects output color space"
                   "\nUS Modern for BT.709 D65."
                   "\nJPN Modern for BT.709 D93."
                   "\nUS CRT for BT.601 (NTSC-U)."
                   "\nJPN CRT for BT.601 ARIB-TR-B9 D93 (NTSC-J)."
                   "\nDefault: US CRT",
        .labels = {
            "US Modern",
            "JPN Modern",
            "US CRT",
            "JPN CRT",
        },
        .is_visible = []() { return settings[0]->GetValue() >= 1; },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "Discord",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x5865F2,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://discord.gg/", "5WZXDpmbpP");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::BUTTON,
        .label = "More Mods",
        .section = "Links",
        .group = "button-line-1",
        .tint = 0x2B3137,
        .on_change = []() {
          renodx::utils::platform::LaunchURL("https://github.com/", "clshortfuse/renodx/wiki/Mods");
        },
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("Build: ") + renodx::utils::date::ISO_DATE_TIME,
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Mod maintained by Forge"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Many thanks to ShortFuse for RenoDX"),
        .section = "About",
    },
    new renodx::utils::settings::Setting{
        .value_type = renodx::utils::settings::SettingValueType::TEXT,
        .label = std::string("- Thanks to Musa for helping solve game UI issue"),
        .section = "About",
    },
};

void OnPresetOff() {
       renodx::utils::settings::UpdateSetting("ToneMapType", 0.f);
       renodx::utils::settings::UpdateSetting("ToneMapPeakNits", 203.f);
       renodx::utils::settings::UpdateSetting("ToneMapGameNits", 203.f);
       renodx::utils::settings::UpdateSetting("ToneMapUINits", 203.f);
       renodx::utils::settings::UpdateSetting("ToneMapGammaCorrection", 1);
       renodx::utils::settings::UpdateSetting("GammaCorrection", 1);
       renodx::utils::settings::UpdateSetting("FxGrainStrength", 0);
       renodx::utils::settings::UpdateSetting("FxAutoExposure", 0);
       renodx::utils::settings::UpdateSetting("FxSunIntensity", 0);
       renodx::utils::settings::UpdateSetting("FxBurleyDiffuse", 0);
       renodx::utils::settings::UpdateSetting("FxProbeModulation", 0);
  //   renodx::utils::settings::UpdateSetting("colorGradeExposure", 1.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeHighlights", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeShadows", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeContrast", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeSaturation", 50.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTStrength", 100.f);
  //   renodx::utils::settings::UpdateSetting("colorGradeLUTScaling", 0.f);
}

void OnPresent(reshade::api::command_queue* queue,
               reshade::api::swapchain* swapchain,
               const reshade::api::rect* source_rect,
               const reshade::api::rect* dest_rect,
               uint32_t dirty_rect_count,
               const reshade::api::rect* dirty_rects) {
  auto* device = queue->get_device();
  if (device->get_api() == reshade::api::device_api::opengl) {
    shader_injection.custom_flip_uv_y = 1.f;
  }
}

bool initialized = false;

}  // namespace

extern "C" __declspec(dllexport) constexpr const char* NAME = "RenoDX";
extern "C" __declspec(dllexport) constexpr const char* DESCRIPTION = "RenoDX mod for Mount & Blade II: Bannerlord";

BOOL APIENTRY DllMain(HMODULE h_module, DWORD fdw_reason, LPVOID lpv_reserved) {
  switch (fdw_reason) {
    case DLL_PROCESS_ATTACH:
      if (!reshade::register_addon(h_module)) return FALSE;

      if (!initialized) {
        renodx::mods::shader::force_pipeline_cloning = true;
        renodx::mods::shader::expected_constant_buffer_space = 50;
        renodx::mods::shader::expected_constant_buffer_index = 13;
        renodx::mods::shader::allow_multiple_push_constants = true;

        renodx::mods::swapchain::expected_constant_buffer_index = 13;
        renodx::mods::swapchain::expected_constant_buffer_space = 50;
        renodx::mods::swapchain::use_resource_cloning = true;
        renodx::mods::swapchain::swapchain_proxy_revert_state = true;
        renodx::mods::swapchain::swap_chain_proxy_shaders = {
            {
                reshade::api::device_api::d3d11,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx11,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx11,
                },
            },
            {
                reshade::api::device_api::d3d12,
                {
                    .vertex_shader = __swap_chain_proxy_vertex_shader_dx12,
                    .pixel_shader = __swap_chain_proxy_pixel_shader_dx12,
                },
            },
        };

        renodx::mods::swapchain::force_borderless = true;
        renodx::mods::swapchain::prevent_full_screen = true;
        renodx::mods::swapchain::use_device_proxy = false;
        renodx::mods::swapchain::set_color_space = true;
        renodx::mods::swapchain::device_proxy_wait_idle_source = false;
        renodx::mods::swapchain::device_proxy_wait_idle_destination = false;
        shader_injection.custom_flip_uv_y = 0.f;

        initialized = true;
      }

      break;
    case DLL_PROCESS_DETACH:
      reshade::unregister_event<reshade::addon_event::present>(OnPresent);
      reshade::unregister_addon(h_module);
      break;
  }

  renodx::utils::settings::Use(fdw_reason, &settings, &OnPresetOff);
  renodx::mods::swapchain::Use(fdw_reason, &shader_injection);
  renodx::mods::shader::Use(fdw_reason, custom_shaders, &shader_injection);
  renodx::utils::random::binds.push_back(&shader_injection.custom_random);
  renodx::utils::random::Use(fdw_reason);

  return TRUE;
}
