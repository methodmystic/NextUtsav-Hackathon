// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// This file is transformed during the build process into a single library with
// part files (`dart:_engine`) by performing the following:
//
//  - Replace all exports with part directives.
//  - Rewrite the libraries into `part of` part files without imports.
//  - Add imports to this file sufficient to cover the needs of `dart:_engine`.
//
// The code that performs the transformations lives in:
//
//  - https://github.com/flutter/flutter/blob/main/engine/src/flutter/web_sdk/sdk_rewriter.dart
// ignore: unnecessary_library_directive
@JS()
library dart._engine;

import 'dart:async';
import 'dart:collection';
import 'dart:convert' hide Codec;
import 'dart:developer' as developer;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:_skwasm_impl' if (dart.library.html) 'dart:_skwasm_stub';
import 'dart:ui_web' as ui_web;
import 'dart:_web_test_fonts';
import 'dart:_web_locale_keymap' as locale_keymap;


part 'engine/alarm_clock.dart';
part 'engine/app_bootstrap.dart';
part 'engine/arena.dart';
part 'engine/browser_detection.dart';
part 'engine/canvaskit/canvas.dart';
part 'engine/canvaskit/canvaskit_api.dart';
part 'engine/canvaskit/color_filter.dart';
part 'engine/canvaskit/fonts.dart';
part 'engine/canvaskit/image.dart';
part 'engine/canvaskit/image_filter.dart';
part 'engine/canvaskit/image_wasm_codecs.dart';
part 'engine/canvaskit/image_web_codecs.dart';
part 'engine/canvaskit/mask_filter.dart';
part 'engine/canvaskit/native_memory.dart';
part 'engine/canvaskit/painting.dart';
part 'engine/canvaskit/path.dart';
part 'engine/canvaskit/path_metrics.dart';
part 'engine/canvaskit/picture.dart';
part 'engine/canvaskit/picture_recorder.dart';
part 'engine/canvaskit/renderer.dart';
part 'engine/canvaskit/shader.dart';
part 'engine/canvaskit/surface.dart';
part 'engine/canvaskit/text.dart';
part 'engine/canvaskit/util.dart';
part 'engine/canvaskit/vertices.dart';
part 'engine/clipboard.dart';
part 'engine/color_filter.dart';
part 'engine/compositing/canvas_provider.dart';
part 'engine/compositing/composition.dart';
part 'engine/compositing/display_canvas_factory.dart';
part 'engine/compositing/multi_surface_rasterizer.dart';
part 'engine/compositing/offscreen_canvas_rasterizer.dart';
part 'engine/compositing/rasterizer.dart';
part 'engine/compositing/render_canvas.dart';
part 'engine/compositing/surface.dart';
part 'engine/configuration.dart';
part 'engine/display.dart';
part 'engine/dom.dart';
part 'engine/font_change_util.dart';
part 'engine/font_fallback_data.dart';
part 'engine/font_fallbacks.dart';
part 'engine/fonts.dart';
part 'engine/frame_service.dart';
part 'engine/frame_timing_recorder.dart';
part 'engine/high_contrast.dart';
part 'engine/html_image_element_codec.dart';
part 'engine/image_decoder.dart';
part 'engine/image_format_detector.dart';
part 'engine/initialization.dart';
part 'engine/js_interop/js_app.dart';
part 'engine/js_interop/js_loader.dart';
part 'engine/js_interop/js_promise.dart';
part 'engine/js_interop/js_typed_data.dart';
part 'engine/key_map.g.dart';
part 'engine/keyboard_binding.dart';
part 'engine/layer/layer.dart';
part 'engine/layer/layer_painting.dart';
part 'engine/layer/layer_scene_builder.dart';
part 'engine/layer/layer_tree.dart';
part 'engine/layer/layer_visitor.dart';
part 'engine/layer/n_way_canvas.dart';
part 'engine/lazy_path.dart';
part 'engine/mouse/context_menu.dart';
part 'engine/mouse/cursor.dart';
part 'engine/mouse/prevent_default.dart';
part 'engine/navigation/history.dart';
part 'engine/noto_font.dart';
part 'engine/noto_font_encoding.dart';
part 'engine/occlusion_map.dart';
part 'engine/onscreen_logging.dart';
part 'engine/platform_dispatcher.dart';
part 'engine/platform_dispatcher/app_lifecycle_state.dart';
part 'engine/platform_dispatcher/view_focus_binding.dart';
part 'engine/platform_views/content_manager.dart';
part 'engine/platform_views/embedder.dart';
part 'engine/platform_views/message_handler.dart';
part 'engine/platform_views/slots.dart';
part 'engine/plugins.dart';
part 'engine/pointer_binding.dart';
part 'engine/pointer_binding/event_position_helper.dart';
part 'engine/pointer_converter.dart';
part 'engine/profiler.dart';
part 'engine/raw_keyboard.dart';
part 'engine/renderer.dart';
part 'engine/safe_browser_api.dart';
part 'engine/semantics/accessibility.dart';
part 'engine/semantics/alert.dart';
part 'engine/semantics/checkable.dart';
part 'engine/semantics/disable.dart';
part 'engine/semantics/expandable.dart';
part 'engine/semantics/focusable.dart';
part 'engine/semantics/form.dart';
part 'engine/semantics/header.dart';
part 'engine/semantics/heading.dart';
part 'engine/semantics/image.dart';
part 'engine/semantics/incrementable.dart';
part 'engine/semantics/label_and_value.dart';
part 'engine/semantics/landmarks.dart';
part 'engine/semantics/link.dart';
part 'engine/semantics/list.dart';
part 'engine/semantics/live_region.dart';
part 'engine/semantics/menus.dart';
part 'engine/semantics/platform_view.dart';
part 'engine/semantics/progress_bar.dart';
part 'engine/semantics/requirable.dart';
part 'engine/semantics/route.dart';
part 'engine/semantics/scrollable.dart';
part 'engine/semantics/semantics.dart';
part 'engine/semantics/semantics_helper.dart';
part 'engine/semantics/table.dart';
part 'engine/semantics/tabs.dart';
part 'engine/semantics/tappable.dart';
part 'engine/semantics/text_field.dart';
part 'engine/services/buffers.dart';
part 'engine/services/message_codec.dart';
part 'engine/services/message_codecs.dart';
part 'engine/services/serialization.dart';
part 'engine/shader_data.dart';
part 'engine/shadow.dart';
part 'engine/svg.dart';
part 'engine/test_embedding.dart';
part 'engine/text/line_breaker.dart';
part 'engine/text/paragraph.dart';
part 'engine/text_editing/autofill_hint.dart';
part 'engine/text_editing/composition_aware_mixin.dart';
part 'engine/text_editing/input_action.dart';
part 'engine/text_editing/input_type.dart';
part 'engine/text_editing/text_capitalization.dart';
part 'engine/text_editing/text_editing.dart';
part 'engine/text_fragmenter.dart';
part 'engine/util.dart';
part 'engine/validators.dart';
part 'engine/vector_math.dart';
part 'engine/view_embedder/dimensions_provider/custom_element_dimensions_provider.dart';
part 'engine/view_embedder/dimensions_provider/dimensions_provider.dart';
part 'engine/view_embedder/dimensions_provider/full_page_dimensions_provider.dart';
part 'engine/view_embedder/display_dpr_stream.dart';
part 'engine/view_embedder/dom_manager.dart';
part 'engine/view_embedder/embedding_strategy/custom_element_embedding_strategy.dart';
part 'engine/view_embedder/embedding_strategy/embedding_strategy.dart';
part 'engine/view_embedder/embedding_strategy/full_page_embedding_strategy.dart';
part 'engine/view_embedder/flutter_view_manager.dart';
part 'engine/view_embedder/global_html_attributes.dart';
part 'engine/view_embedder/hot_restart_cache_handler.dart';
part 'engine/view_embedder/style_manager.dart';
part 'engine/web_paragraph/bidi.dart';
part 'engine/web_paragraph/code_unit_flags.dart';
part 'engine/web_paragraph/debug.dart';
part 'engine/web_paragraph/font_collection.dart';
part 'engine/web_paragraph/layout.dart';
part 'engine/web_paragraph/paint.dart';
part 'engine/web_paragraph/painter.dart';
part 'engine/web_paragraph/paragraph.dart';
part 'engine/web_paragraph/wrapper.dart';
part 'engine/window.dart';
