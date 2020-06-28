// ************************************************************************
// ***************************** OldCEF4Delphi ****************************
// ************************************************************************
//
// OldCEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to OldCEF4Delphi.
//
// For more information about OldCEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright © 2019 Salvador Díaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit oldCEFLibFunctions;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF} System.Math,
  {$ELSE}
  Windows, Math,
  {$ENDIF}
  oldCEFTypes;

var
  // /include/capi/cef_app_capi.h
  cef_initialize             : function(const args: POldCefMainArgs; const settings: POldCefSettings; application: POldCefApp; windows_sandbox_info: Pointer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_shutdown               : procedure; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_execute_process        : function(const args: POldCefMainArgs; application: POldCefApp; windows_sandbox_info: Pointer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_do_message_loop_work   : procedure; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_run_message_loop       : procedure; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_quit_message_loop      : procedure; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_set_osmodal_loop       : procedure(osModalLoop: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_enable_highdpi_support : procedure; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_browser_capi.h
  cef_browser_host_create_browser      : function(const windowInfo: POldCefWindowInfo; client: POldCefClient; const url: POldCefString; const settings: POldCefBrowserSettings; request_context: POldCefRequestContext): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_browser_host_create_browser_sync : function(const windowInfo: POldCefWindowInfo; client: POldCefClient; const url: POldCefString; const settings: POldCefBrowserSettings; request_context: POldCefRequestContext): POldCefBrowser; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_command_line_capi.h
  cef_command_line_create     : function : POldCefCommandLine; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_command_line_get_global : function : POldCefCommandLine; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_cookie_capi.h
  cef_cookie_manager_get_global_manager   : function(callback: POldCefCompletionCallback): POldCefCookieManager; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_cookie_manager_create_manager       : function(const path: POldCefString; persist_session_cookies: Integer; callback: POldCefCompletionCallback): POldCefCookieManager; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_drag_data_capi.h
  cef_drag_data_create : function : POldCefDragData; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_geolocation_capi.h
  cef_get_geolocation: function(callback: POldCefGetGeolocationCallback): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_origin_whitelist_capi.h
  cef_add_cross_origin_whitelist_entry    : function(const source_origin, target_protocol, target_domain: POldCefString; allow_target_subdomains: Integer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_remove_cross_origin_whitelist_entry : function(const source_origin, target_protocol, target_domain: POldCefString; allow_target_subdomains: Integer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_clear_cross_origin_whitelist        : function : Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_parser_capi.h
  cef_parse_url                       : function(const url: POldCefString; var parts: TOldCefUrlParts): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_create_url                      : function(const parts: POldCefUrlParts; url: POldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_format_url_for_security_display : function(const origin_url, languages: POldCefString): POldCefStringUserFree; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_get_mime_type                   : function(const extension: POldCefString): POldCefStringUserFree; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_get_extensions_for_mime_type    : procedure(const mime_type: POldCefString; extensions: TOldCefStringList); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_base64encode                    : function(const data: Pointer; data_size: NativeUInt): POldCefStringUserFree; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_base64decode                    : function(const data: POldCefString): POldCefBinaryValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_uriencode                       : function(const text: POldCefString; use_plus: Integer): POldCefStringUserFree; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_uridecode                       : function(const text: POldCefString; convert_to_utf8: Integer; unescape_rule: TOldCefUriUnescapeRule): POldCefStringUserFree; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_parse_csscolor                  : function(const str: POldCefString; strict: Integer; color: POldCefColor): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_parse_json                      : function(const json_string: POldCefString; options: TOldCefJsonParserOptions): POldCefValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_parse_jsonand_return_error      : function(const json_string: POldCefString; options: TOldCefJsonParserOptions; error_code_out: POldCefJsonParserError; error_msg_out: POldCefString): POldCefValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_write_json                      : function(node: POldCefValue; options: TOldCefJsonWriterOptions): POldCefStringUserFree; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_path_util_capi.h
  cef_get_path : function(key: TOldCefPathKey; path: POldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_print_settings_capi.h
  cef_print_settings_create : function : POldCefPrintSettings; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_process_message_capi.h
  cef_process_message_create : function(const name: POldCefString): POldCefProcessMessage; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_process_util_capi.h
  cef_launch_process : function(command_line: POldCefCommandLine): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_request_capi.h
  cef_request_create           : function : POldCefRequest; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_post_data_create         : function : POldCefPostData; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_post_data_element_create : function : POldCefPostDataElement; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_request_context_capi.h
  cef_request_context_get_global_context : function : POldCefRequestContext; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_request_context_create_context     : function(const settings: POldCefRequestContextSettings; handler: POldCefRequestContextHandler): POldCefRequestContext; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  create_context_shared                  : function(other: POldCefRequestContext; handler: POldCefRequestContextHandler): POldCefRequestContext; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_resource_bundle_capi.h
  cef_resource_bundle_get_global : function : POldCefResourceBundle; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_response_capi.h
  cef_response_create : function : POldCefResponse; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_scheme_capi.h
  cef_register_scheme_handler_factory : function(const scheme_name, domain_name: POldCefString; factory: POldCefSchemeHandlerFactory): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_clear_scheme_handler_factories  : function : Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_stream_capi.h
  cef_stream_reader_create_for_file    : function(const fileName: POldCefString): POldCefStreamReader; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_stream_reader_create_for_data    : function(data: Pointer; size: NativeUInt): POldCefStreamReader; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_stream_reader_create_for_handler : function(handler: POldCefReadHandler): POldCefStreamReader; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_stream_writer_create_for_file    : function(const fileName: POldCefString): POldCefStreamWriter; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_stream_writer_create_for_handler : function(handler: POldCefWriteHandler): POldCefStreamWriter; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_task_capi.h
  cef_task_runner_get_for_current_thread : function : POldCefTaskRunner; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_task_runner_get_for_thread         : function(threadId: TOldCefThreadId): POldCefTaskRunner; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_currently_on                       : function(threadId: TOldCefThreadId): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_post_task                          : function(threadId: TOldCefThreadId; task: POldCefTask): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_post_delayed_task                  : function(threadId: TOldCefThreadId; task: POldCefTask; delay_ms: Int64): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_trace_capi.h
  cef_begin_tracing              : function(const categories: POldCefString; callback: POldCefCompletionCallback): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_end_tracing                : function(const tracing_file: POldCefString; callback: POldCefEndTracingCallback): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_now_from_system_trace_time : function : int64; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_urlrequest_capi.h
  cef_urlrequest_create : function(request: POldCefRequest; client: POldCefUrlRequestClient; request_context: POldCefRequestContext): POldCefUrlRequest; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_v8_capi.h
  cef_v8context_get_current_context : function : POldCefv8Context; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8context_get_entered_context : function : POldCefv8Context; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8context_in_context          : function : Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_undefined      : function : POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_null           : function : POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_bool           : function(value: Integer): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_int            : function(value: Integer): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_uint           : function(value: Cardinal): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_double         : function(value: Double): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_date           : function(const value: POldCefTime): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_string         : function(const value: POldCefString): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_object         : function(accessor: POldCefV8Accessor): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_array          : function(length: Integer): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8value_create_function       : function(const name: POldCefString; handler: POldCefv8Handler): POldCefv8Value; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_v8stack_trace_get_current     : function(frame_limit: Integer): POldCefV8StackTrace; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_register_extension            : function(const extension_name, javascript_code: POldCefString; handler: POldCefv8Handler): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_values_capi.h
  cef_value_create            : function : POldCefValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_binary_value_create     : function(const data: Pointer; data_size: NativeUInt): POldCefBinaryValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_dictionary_value_create : function : POldCefDictionaryValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_list_value_create       : function : POldCefListValue; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_web_plugin_capi.h
  cef_visit_web_plugin_info          : procedure(visitor: POldCefWebPluginInfoVisitor); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_refresh_web_plugins            : procedure; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_add_web_plugin_path            : procedure(const path: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_add_web_plugin_directory       : procedure(const dir: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_remove_web_plugin_path         : procedure(const path: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_unregister_internal_web_plugin : procedure(const path: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_force_web_plugin_shutdown      : procedure(const path: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_register_web_plugin_crash      : procedure(const path: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_is_web_plugin_unstable         : procedure(const path: POldCefString; callback: POldCefWebPluginUnstableCallback); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  // cef_register_widevine_cdm

  // /include/capi/cef_xml_reader_capi.h
  cef_xml_reader_create : function(stream: POldCefStreamReader; encodingType: TOldCefXmlEncodingType; const URI: POldCefString): POldCefXmlReader; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/capi/cef_zip_reader_capi.h
  cef_zip_reader_create : function(stream: POldCefStreamReader): POldCefZipReader; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_logging_internal.h
  cef_get_min_log_level : function : Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_get_vlog_level    : function(const file_start: PAnsiChar; N: NativeInt): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_log               : procedure(const file_: PAnsiChar; line, severity: Integer; const message: PAnsiChar); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_string_list.h
  cef_string_list_alloc  : function : TOldCefStringList; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_list_size   : function(list: TOldCefStringList): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_list_value  : function(list: TOldCefStringList; index: Integer; value: POldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_list_append : procedure(list: TOldCefStringList; const value: POldCefString); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_list_clear  : procedure(list: TOldCefStringList); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_list_free   : procedure(list: TOldCefStringList); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_list_copy   : function(list: TOldCefStringList): TOldCefStringList; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_string_map.h
  cef_string_map_alloc  : function : TOldCefStringMap; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_size   : function(map: TOldCefStringMap): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_find   : function(map: TOldCefStringMap; const key: POldCefString; var value: TOldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_key    : function(map: TOldCefStringMap; index: Integer; var key: TOldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_value  : function(map: TOldCefStringMap; index: Integer; var value: TOldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_append : function(map: TOldCefStringMap; const key, value: POldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_clear  : procedure(map: TOldCefStringMap); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_map_free   : procedure(map: TOldCefStringMap); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_string_multimap.h
  cef_string_multimap_alloc      : function : TOldCefStringMultimap; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_size       : function(map: TOldCefStringMultimap): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_find_count : function(map: TOldCefStringMultimap; const key: POldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_enumerate  : function(map: TOldCefStringMultimap; const key: POldCefString; value_index: Integer; var value: TOldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_key        : function(map: TOldCefStringMultimap; index: Integer; var key: TOldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_value      : function(map: TOldCefStringMultimap; index: Integer; var value: TOldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_append     : function(map: TOldCefStringMultimap; const key, value: POldCefString): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_clear      : procedure(map: TOldCefStringMultimap); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_multimap_free       : procedure(map: TOldCefStringMultimap); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_string_types.h
  cef_string_wide_set             : function(const src: PWideChar; src_len: NativeUInt; output: POldCefStringWide; copy: Integer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf8_set             : function(const src: PAnsiChar; src_len: NativeUInt; output: POldCefStringUtf8; copy: Integer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf16_set            : function(const src: OldPChar16; src_len: NativeUInt; output: POldCefStringUtf16; copy: Integer): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_wide_clear           : procedure(str: POldCefStringWide); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf8_clear           : procedure(str: POldCefStringUtf8); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf16_clear          : procedure(str: POldCefStringUtf16); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_wide_cmp             : function(const str1, str2: POldCefStringWide): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf8_cmp             : function(const str1, str2: POldCefStringUtf8): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf16_cmp            : function(const str1, str2: POldCefStringUtf16): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_wide_to_utf8         : function(const src: PWideChar; src_len: NativeUInt; output: POldCefStringUtf8): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf8_to_wide         : function(const src: PAnsiChar; src_len: NativeUInt; output: POldCefStringWide): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_wide_to_utf16        : function(const src: PWideChar; src_len: NativeUInt; output: POldCefStringUtf16): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf16_to_wide        : function(const src: OldPChar16; src_len: NativeUInt; output: POldCefStringWide): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf8_to_utf16        : function(const src: PAnsiChar; src_len: NativeUInt; output: POldCefStringUtf16): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_utf16_to_utf8        : function(const src: OldPChar16; src_len: NativeUInt; output: POldCefStringUtf8): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_ascii_to_wide        : function(const src: PAnsiChar; src_len: NativeUInt; output: POldCefStringWide): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_ascii_to_utf16       : function(const src: PAnsiChar; src_len: NativeUInt; output: POldCefStringUtf16): Integer; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_userfree_wide_alloc  : function : POldCefStringUserFreeWide; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_userfree_utf8_alloc  : function : POldCefStringUserFreeUtf8; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_userfree_utf16_alloc : function : POldCefStringUserFreeUtf16; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_userfree_wide_free   : procedure(str: POldCefStringUserFreeWide); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_userfree_utf8_free   : procedure(str: POldCefStringUserFreeUtf8); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_string_userfree_utf16_free  : procedure(str: POldCefStringUserFreeUtf16); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_thread_internal.h
  cef_get_current_platform_thread_id     : function : TOldCefPlatformThreadId; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_get_current_platform_thread_handle : function : TOldCefPlatformThreadHandle; {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};

  // /include/internal/cef_trace_event_internal.h
  cef_trace_event_instant         : procedure(const category, name, arg1_name: PAnsiChar; arg1_val: uint64; const arg2_name: PAnsiChar; arg2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_event_begin           : procedure(const category, name, arg1_name: PAnsiChar; arg1_val: UInt64; const arg2_name: PAnsiChar; arg2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_event_end             : procedure(const category, name, arg1_name: PAnsiChar; arg1_val: UInt64; const arg2_name: PAnsiChar; arg2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_counter               : procedure(const category, name, value1_name: PAnsiChar; value1_val: UInt64; const value2_name: PAnsiChar; value2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_counter_id            : procedure(const category, name: PAnsiChar; id: UInt64; const value1_name: PAnsiChar; value1_val: UInt64; const value2_name: PAnsiChar; value2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_event_async_begin     : procedure(const category, name: PAnsiChar; id: UInt64; const arg1_name: PAnsiChar; arg1_val: UInt64; const arg2_name: PAnsiChar; arg2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_event_async_step_into : procedure(const category, name: PAnsiChar; id, step: UInt64; const arg1_name: PAnsiChar; arg1_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_event_async_step_past : procedure(const category, name: PAnsiChar; id, step: UInt64; const arg1_name: PAnsiChar; arg1_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};
  cef_trace_event_async_end       : procedure(const category, name: PAnsiChar; id: UInt64; const arg1_name: PAnsiChar; arg1_val: UInt64; const arg2_name: PAnsiChar; arg2_val: UInt64; copy: Integer); {$IFDEF CPUX64}stdcall{$ELSE}cdecl{$ENDIF};


implementation

end.
