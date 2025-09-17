//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <is_tv/is_t_v_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) is_tv_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "IsTVPlugin");
  is_t_v_plugin_register_with_registrar(is_tv_registrar);
}
