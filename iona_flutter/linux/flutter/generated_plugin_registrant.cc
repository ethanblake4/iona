//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <color_panel/color_panel_plugin.h>
#include <file_selector_linux/file_selector_plugin.h>
#include <menubar/menubar_plugin.h>
#include <url_launcher_fde/url_launcher_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>
#include <window_size/window_size_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) color_panel_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ColorPanelPlugin");
  color_panel_plugin_register_with_registrar(color_panel_registrar);
  g_autoptr(FlPluginRegistrar) file_selector_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSelectorPlugin");
  file_selector_plugin_register_with_registrar(file_selector_linux_registrar);
  g_autoptr(FlPluginRegistrar) menubar_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "MenubarPlugin");
  menubar_plugin_register_with_registrar(menubar_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_fde_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_fde_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
  g_autoptr(FlPluginRegistrar) window_size_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowSizePlugin");
  window_size_plugin_register_with_registrar(window_size_registrar);
}
