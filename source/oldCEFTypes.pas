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

unit oldCEFTypes;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF} System.Math;
  {$ELSE}
  Windows, Math;
  {$ENDIF}

type
  POldCefStringWide = ^TOldCefStringWide;
  POldCefDictionaryValue = ^TOldCefDictionaryValue;
  POldCefListValue = ^TOldCefListValue;
  POldCefBrowser = ^TOldCefBrowser;
  POldCefValue = ^TOldCefValue;
  POldCefBinaryValue = ^TOldCefBinaryValue;
  POldCefSchemeRegistrar = ^TOldCefSchemeRegistrar;
  POldCefCommandLine = ^TOldCefCommandLine;
  POldCefBase = ^TOldCefBase;
  POldCefWindowInfo = ^TOldCefWindowInfo;
  POldCefSettings = ^TOldCefSettings;
  POldCefStringUtf8 = ^TOldCefStringUtf8;
  POldCefStringUtf16 = ^TOldCefStringUtf16;
  POldCefStringUserFreeWide = ^TOldCefStringUserFreeWide;
  POldCefStringUserFreeUtf8 = ^TOldCefStringUserFreeUtf8;
  POldCefStringUserFreeUtf16 = ^TOldCefStringUserFreeUtf16;
  POldCefMainArgs = ^TOldCefMainArgs;
  POldCefColor = ^TOldCefColor;
  POldCefBrowserHost = ^TOldCefBrowserHost;
  POldCefClient = ^TOldCefClient;
  POldCefPrintHandler = ^TOldCefPrintHandler;
  POldCefResourceBundleHandler = ^TOldCefResourceBundleHandler;
  POldCefBrowserProcessHandler = ^TOldCefBrowserProcessHandler;
  POldCefContextMenuHandler = ^TOldCefContextMenuHandler;
  POldCefAccessibilityHandler = ^TOldCefAccessibilityHandler;
  POldCefFrame = ^TOldCefFrame;
  POldCefApp = ^TOldCefApp;
  POldCefStringVisitor = ^TOldCefStringVisitor;
  POldCefRequest = ^TOldCefRequest;
  POldCefPostData = ^TOldCefPostData;
  POldCefPostDataElementArray = ^TOldCefPostDataElementArray;
  POldCefPostDataElement = ^TOldCefPostDataElement;
  PPOldCefPostDataElement = ^POldCefPostDataElement;
  POldCefv8Context = ^TOldCefv8Context;
  POldCefTask = ^TOldCefTask;
  POldCefv8Value = ^TOldCefv8Value;
  POldCefTime = ^TOldCefTime;
  POldCefV8Exception = ^TOldCefV8Exception;
  POldCefv8Handler = ^TOldCefv8Handler;
  PPOldCefV8Value = ^POldCefV8ValueArray;
  POldCefDomVisitor = ^TOldCefDomVisitor;
  POldCefDomDocument = ^TOldCefDomDocument;
  POldCefDomNode = ^TOldCefDomNode;
  POldCefContextMenuParams = ^TOldCefContextMenuParams;
  POldCefMenuModel = ^TOldCefMenuModel;
  POldCefRunContextMenuCallback = ^TOldCefRunContextMenuCallback;
  POldCefDialogHandler = ^TOldCefDialogHandler;
  POldCefFileDialogCallback = ^TOldCefFileDialogCallback;
  POldCefDisplayHandler = ^TOldCefDisplayHandler;
  POldCefDownloadHandler = ^TOldCefDownloadHandler;
  POldCefDownloadItem = ^TOldCefDownloadItem;
  POldCefBeforeDownloadCallback = ^TOldCefBeforeDownloadCallback;
  POldCefDownloadItemCallback = ^TOldCefDownloadItemCallback;
  POldCefDragHandler = ^TOldCefDragHandler;
  POldCefDragData = ^TOldCefDragData;
  POldCefDraggableRegionArray = ^TOldCefDraggableRegionArray;
  POldCefDraggableRegion = ^TOldCefDraggableRegion;
  POldCefRect = ^TOldCefRect;
  POldCefPoint = ^TOldCefPoint;
  POldCefSize = ^TOldCefSize;
  POldCefRectArray = ^TOldCefRectArray;
  POldCefStreamWriter = ^TOldCefStreamWriter;
  POldCefFindHandler = ^TOldCefFindHandler;
  POldCefFocusHandler = ^TOldCefFocusHandler;
  POldCefJsDialogHandler = ^TOldCefJsDialogHandler;
  POldCefJsDialogCallback = ^TOldCefJsDialogCallback;
  POldCefKeyboardHandler = ^TOldCefKeyboardHandler;
  POldCefKeyEvent = ^TOldCefKeyEvent;
  POldCefLifeSpanHandler = ^TOldCefLifeSpanHandler;
  POldCefPopupFeatures = ^TOldCefPopupFeatures;
  POldCefBrowserSettings = ^TOldCefBrowserSettings;
  POldCefLoadHandler = ^TOldCefLoadHandler;
  POldCefRenderHandler = ^TOldCefRenderHandler;
  POldCefScreenInfo = ^TOldCefScreenInfo;
  POldCefRenderProcessHandler = ^TOldCefRenderProcessHandler;
  POldCefCursorInfo = ^TOldCefCursorInfo;
  POldCefV8StackTrace = ^TOldCefV8StackTrace;
  POldCefV8StackFrame = ^TOldCefV8StackFrame;
  POldCefProcessMessage = ^TOldCefProcessMessage;
  POldCefRequestHandler = ^TOldCefRequestHandler;
  POldCefRequestCallback = ^TOldCefRequestCallback;
  POldCefResourceHandler = ^TOldCefResourceHandler;
  POldCefResponse = ^TOldCefResponse;
  POldCefResponseFilter = ^TOldCefResponseFilter;
  POldCefAuthCallback = ^TOldCefAuthCallback;
  POldCefSslInfo = ^TOldCefSslInfo;
  POldCefSslCertPrincipal = ^TOldCefSslCertPrincipal;
  POldCefCallback = ^TOldCefCallback;
  POldCefCookie = ^TOldCefCookie;
  POldCefRequestContext = ^TOldCefRequestContext;
  POldCefRequestContextHandler = ^TOldCefRequestContextHandler;
  POldCefCompletionCallback = ^TOldCefCompletionCallback;
  POldCefCookieManager = ^TOldCefCookieManager;
  POldCefSchemeHandlerFactory = ^TOldCefSchemeHandlerFactory;
  POldCefResolveCallback = ^TOldCefResolveCallback;
  POldCefWebPluginInfo = ^TOldCefWebPluginInfo;
  POldCefPluginPolicy = ^TOldCefPluginPolicy;
  POldCefCookieVisitor = ^TOldCefCookieVisitor;
  POldCefSetCookieCallback = ^TOldCefSetCookieCallback;
  POldCefDeleteCookiesCallback = ^TOldCefDeleteCookiesCallback;
  POldCefRunFileDialogCallback = ^TOldCefRunFileDialogCallback;
  POldCefPdfPrintSettings = ^TOldCefPdfPrintSettings;
  POldCefPdfPrintCallback = ^TOldCefPdfPrintCallback;
  POldCefNavigationEntryVisitor = ^TOldCefNavigationEntryVisitor;
  POldCefNavigationEntry = ^TOldCefNavigationEntry;
  POldCefMouseEvent = ^TOldCefMouseEvent;
  POldCefPrintSettings = ^TOldCefPrintSettings;
  POldCefPrintDialogCallback = ^TOldCefPrintDialogCallback;
  POldCefPrintJobCallback = ^TOldCefPrintJobCallback;
  POldCefUrlParts = ^TOldCefUrlParts;
  POldCefJsonParserError = ^TOldCefJsonParserError;
  POldCefStreamReader = ^TOldCefStreamReader;
  POldCefReadHandler = ^TOldCefReadHandler;
  POldCefWriteHandler = ^TOldCefWriteHandler;
  POldCefV8Accessor = ^TOldCefV8Accessor;
  POldCefXmlReader = ^TOldCefXmlReader;
  POldCefZipReader = ^TOldCefZipReader;
  POldCefUrlRequestClient = ^TOldCefUrlRequestClient;
  POldCefUrlRequest = ^TOldCefUrlRequest;
  POldCefWebPluginInfoVisitor = ^TOldCefWebPluginInfoVisitor;
  POldCefWebPluginUnstableCallback = ^TOldCefWebPluginUnstableCallback;
  POldCefTaskRunner = ^TOldCefTaskRunner;
  POldCefEndTracingCallback = ^TOldCefEndTracingCallback;
  POldCefRequestContextSettings = ^TOldCefRequestContextSettings;
  POldCefResourceBundle = ^TOldCefResourceBundle;
  POldCefGetGeolocationCallback = ^TOldCefGetGeolocationCallback;
  POldCefGeoposition = ^TOldCefGeoposition;
  POldCefGeolocationHandler = ^TOldCefGeolocationHandler;
  POldCefGeolocationCallback = ^TOldCefGeolocationCallback;
  POldCefPageRange = ^TOldCefPageRange;


  TOldCefWindowHandle                 = HWND;        // /include/internal/cef_types_win.h (cef_window_handle_t)
  TOldCefCursorHandle                 = HCURSOR;     // /include/internal/cef_types_win.h (cef_cursor_handle_t)
  TOldCefEventHandle                  = PMsg;        // /include/internal/cef_types_win.h (cef_event_handle_t)
  TOldCefTextInputContext             = Pointer;     // /include/internal/cef_types_win.h (cef_text_input_context_t)
  TOldCefPlatformThreadId             = DWORD;       // /include/internal/cef_thread_internal.h (cef_platform_thread_id_t)
  TOldCefPlatformThreadHandle         = DWORD;       // /include/internal/cef_thread_internal.h (cef_platform_thread_handle_t)
  TOldCefTransitionType               = Cardinal;    // /include/internal/cef_types.h (cef_transition_type_t)
  TOldCefColor                        = Cardinal;    // /include/internal/cef_types.h (cef_color_t)
  TOldCefErrorCode                    = Integer;     // /include/internal/cef_types.h (cef_errorcode_t)
  TOldCefCertStatus                   = Integer;     // /include/internal/cef_types.h (cef_cert_status_t)
  TOldCefSSLVersion                   = integer;     // /include/internal/cef_types.h (cef_ssl_version_t)
  TOldCefStringList                   = Pointer;     // /include/internal/cef_string_list.h (cef_string_list_t)
  TOldCefStringMap                    = Pointer;     // /include/internal/cef_string_map.h (cef_string_map_t)
  TOldCefStringMultimap               = Pointer;     // /include/internal/cef_string_multimap.h (cef_string_multimap_t)
  TOldCefUriUnescapeRule              = Integer;     // /include/internal/cef_types.h (cef_uri_unescape_rule_t)
  TOldCefDomEventCategory             = Integer;     // /include/internal/cef_types.h (cef_dom_event_category_t)
  TOldCefEventFlags                   = Cardinal;    // /include/internal/cef_types.h (cef_event_flags_t)
  TOldCefDragOperations               = Cardinal;    // /include/internal/cef_types.h (cef_drag_operations_mask_t)
  TOldCefDragOperation                = Cardinal;    // /include/internal/cef_types.h (cef_drag_operations_mask_t)
  TOldCefV8AccessControls             = Cardinal;    // /include/internal/cef_types.h (cef_v8_accesscontrol_t)
  TOldCefV8PropertyAttributes         = Cardinal;    // /include/internal/cef_types.h (cef_v8_propertyattribute_t)
  TOldCefUrlRequestFlags              = Cardinal;    // /include/internal/cef_types.h (cef_urlrequest_flags_t)
  TOldCefContextMenuTypeFlags         = Cardinal;    // /include/internal/cef_types.h (cef_context_menu_type_flags_t)
  TOldCefContextMenuMediaStateFlags   = Cardinal;    // /include/internal/cef_types.h (cef_context_menu_media_state_flags_t)
  TOldCefContextMenuEditStateFlags    = Cardinal;    // /include/internal/cef_types.h (cef_context_menu_edit_state_flags_t)
  TOldCefJsonWriterOptions            = Cardinal;    // /include/internal/cef_types.h (cef_json_writer_options_t)
  //TOldCefSSLContentStatus             = Cardinal;    // /include/internal/cef_types.h (cef_ssl_content_status_t)
  TOldCefLogSeverity                  = Cardinal;    // /include/internal/cef_types.h (cef_log_severity_t)
  TOldCefFileDialogMode               = Cardinal;    // /include/internal/cef_types.h (cef_file_dialog_mode_t)
  TOldCefDuplexMode                   = Integer;     // /include/internal/cef_types.h (cef_duplex_mode_t)

{$IFNDEF DELPHI12_UP}
  NativeUInt  = Cardinal;
  PNativeUInt = ^NativeUInt;
  NativeInt   = Integer;
  uint16      = Word;
  oldustring  = type WideString;
  oldrbstring = type AnsiString;
{$ELSE}
  oldustring  = type string;
  oldrbstring = type RawByteString;
  {$IFNDEF DELPHI15_UP}
  NativeUInt  = Cardinal;
  PNativeUInt = ^NativeUInt;
  {$ENDIF}
{$ENDIF}

  OldChar16  = WideChar;
  OldPChar16 = PWideChar;

  // /include/internal/cef_string_types.h (cef_string_wide_t)
  TOldCefStringWide = record
    str    : PWideChar;
    length : NativeUInt;
    dtor   : procedure(str: PWideChar); stdcall;
  end;

  // /include/internal/cef_string_types.h (cef_string_utf8_t)
  TOldCefStringUtf8 = record
    str    : PAnsiChar;
    length : NativeUInt;
    dtor   : procedure(str: PAnsiChar); stdcall;
  end;

  // /include/internal/cef_string_types.h (cef_string_utf16_t)
  TOldCefStringUtf16 = record
    str    : OldPChar16;
    length : NativeUInt;
    dtor   : procedure(str: OldPChar16); stdcall;
  end;

  TOldCefStringUserFreeWide  = type TOldCefStringWide;
  TOldCefStringUserFreeUtf8  = type TOldCefStringUtf8;
  TOldCefStringUserFreeUtf16 = type TOldCefStringUtf16;

  TOldCefChar = OldChar16;
  POldCefChar = OldPChar16;
  TOldCefStringUserFree = TOldCefStringUserFreeUtf16;
  POldCefStringUserFree = POldCefStringUserFreeUtf16;
  TOldCefString = TOldCefStringUtf16;
  POldCefString = POldCefStringUtf16;

  TOldFileVersionInfo = record
    MajorVer : uint16;
    MinorVer : uint16;
    Release  : uint16;
    Build    : uint16;
  end;

  // Used in TChromium.Onclose
  // -------------------------
  // cbaCancel : stop closing the browser
  // cbaClose  : continue closing the browser
  // cbaDelay  : stop closing the browser momentarily. Used when the application
  //             needs to execute some custom processes before closing the
  //             browser. This is usually needed to destroy a TOldCefWindowParent
  //             in the main thread before closing the browser.
  TOldCefCloseBrowserAction = (cbaCancel, cbaDelay, cbaClose);

  TOldCefProcessType = (ptBrowser, ptRenderer, ptZygote, ptGPU, ptOther);

  TOldCefAplicationStatus = (asLoading,
                          asLoaded,
                          asInitialized,
                          asShuttingDown,
                          asUnloaded,
                          asErrorMissingFiles,
                          asErrorDLLVersion,
                          asErrorLoadingLibrary,
                          asErrorInitializingLibrary,
                          asErrorExecutingProcess);

  TOldCefProxyScheme = (psHTTP, psSOCKS4, psSOCKS5);

  TOldCefWebRTCHandlingPolicy = (
    hpDefault,
    hpDefaultPublicAndPrivateInterfaces,
    hpDefaultPublicInterfaceOnly,
    hpDisableNonProxiedUDP
  );

  TOldCefContextSafetyImplementation = (csiDefault, csiManyContexts, csiDisabled);

  // /include/internal/cef_types_win.h (cef_main_args_t)
  TOldCefMainArgs = record
    instance : HINST;
  end;

  // /include/internal/cef_types.h (cef_rect_t)
  TOldCefRect = record
    x      : Integer;
    y      : Integer;
    width  : Integer;
    height : Integer;
  end;
  TOldCefRectArray    = array[0..(High(Integer) div SizeOf(TOldCefRect))-1] of TOldCefRect;
  TOldCefRectDynArray = array of TOldCefRect;

  // /include/internal/cef_types.h (cef_point_t)
  TOldCefPoint = record
    x  : Integer;
    y  : Integer;
  end;

  // /include/internal/cef_types.h (cef_size_t)
  TOldCefSize = record
    width  : Integer;
    height : Integer;
  end;

  // /include/internal/cef_types.h (cef_page_range_t) {new}
  TOldCefPageRange = record
    from  : Integer;
    to_   : Integer;
  end;
  TOldCefPageRangeArray = array of TOldCefPageRange;

  // /include/internal/cef_types.h (cef_cursor_info_t)
  TOldCefCursorInfo = record
    hotspot            : TOldCefPoint;
    image_scale_factor : Single;
    buffer             : Pointer;
    size               : TOldCefSize;
  end;

  // /include/internal/cef_types.h (cef_urlparts_t)
  TOldCefUrlParts = record
    spec      : TOldCefString;
    scheme    : TOldCefString;
    username  : TOldCefString;
    password  : TOldCefString;
    host      : TOldCefString;
    port      : TOldCefString;
    origin    : TOldCefString;
    path      : TOldCefString;
    query     : TOldCefString;
  end;

  TOldUrlParts = record
    spec     : oldustring;
    scheme   : oldustring;
    username : oldustring;
    password : oldustring;
    host     : oldustring;
    port     : oldustring;
    origin   : oldustring;
    path     : oldustring;
    query    : oldustring;
  end;

  // /include/internal/cef_types.h (cef_json_parser_error_t)
  TOldCefJsonParserError = (
    JSON_NO_ERROR = 0,
    JSON_INVALID_ESCAPE,
    JSON_SYNTAX_ERROR,
    JSON_UNEXPECTED_TOKEN,
    JSON_TRAILING_COMMA,
    JSON_TOO_MUCH_NESTING,
    JSON_UNEXPECTED_DATA_AFTER_ROOT,
    JSON_UNSUPPORTED_ENCODING,
    JSON_UNQUOTED_DICTIONARY_KEY,
    JSON_PARSE_ERROR_COUNT
  );

  // /include/internal/cef_types.h (cef_state_t)
  TOldCefState = (
    STATE_DEFAULT = 0,
    STATE_ENABLED,
    STATE_DISABLED
  );

  // /include/internal/cef_types.h (cef_scale_factor_t)
  TOldCefScaleFactor = (
    SCALE_FACTOR_NONE = 0,
    SCALE_FACTOR_100P,
    SCALE_FACTOR_125P,
    SCALE_FACTOR_133P,
    SCALE_FACTOR_140P,
    SCALE_FACTOR_150P,
    SCALE_FACTOR_180P,
    SCALE_FACTOR_200P,
    SCALE_FACTOR_250P,
    SCALE_FACTOR_300P
  );

  // /include/internal/cef_types.h (cef_value_type_t)
  TOldCefValueType = (
    VTYPE_INVALID = 0,
    VTYPE_NULL,
    VTYPE_BOOL,
    VTYPE_INT,
    VTYPE_DOUBLE,
    VTYPE_STRING,
    VTYPE_BINARY,
    VTYPE_DICTIONARY,
    VTYPE_LIST
  );

  // /include/internal/cef_types.h (cef_referrer_policy_t)
  TOldCefReferrerPolicy = (
    REFERRER_POLICY_ALWAYS,
    REFERRER_POLICY_DEFAULT,
    REFERRER_POLICY_NO_REFERRER_WHEN_DOWNGRADE,
    REFERRER_POLICY_NEVER,
    REFERRER_POLICY_ORIGIN,
    REFERRER_POLICY_ORIGIN_WHEN_CROSS_ORIGIN
  );

  // /include/internal/cef_types.h (cef_postdataelement_type_t)
  TOldCefPostDataElementType = (
    PDE_TYPE_EMPTY  = 0,
    PDE_TYPE_BYTES,
    PDE_TYPE_FILE
  );

  // /include/internal/cef_types.h (cef_resource_type_t)
  TOldCefResourceType = (
    RT_MAIN_FRAME,
    RT_SUB_FRAME,
    RT_STYLESHEET,
    RT_SCRIPT,
    RT_IMAGE,
    RT_FONT_RESOURCE,
    RT_SUB_RESOURCE,
    RT_OBJECT,
    RT_MEDIA,
    RT_WORKER,
    RT_SHARED_WORKER,
    RT_PREFETCH,
    RT_FAVICON,
    RT_XHR,
    RT_PING,
    RT_SERVICE_WORKER,
    RT_CSP_REPORT,
    RT_PLUGIN_RESOURCE
  );

  // /include/internal/cef_types.h (cef_dom_document_type_t)
  TOldCefDomDocumentType = (
    DOM_DOCUMENT_TYPE_UNKNOWN = 0,
    DOM_DOCUMENT_TYPE_HTML,
    DOM_DOCUMENT_TYPE_XHTML,
    DOM_DOCUMENT_TYPE_PLUGIN
  );

  // /include/internal/cef_types.h (cef_dom_node_type_t)
  TOldCefDomNodeType = (
    DOM_NODE_TYPE_UNSUPPORTED = 0,
    DOM_NODE_TYPE_ELEMENT,
    DOM_NODE_TYPE_ATTRIBUTE,
    DOM_NODE_TYPE_TEXT,
    DOM_NODE_TYPE_CDATA_SECTION,
    DOM_NODE_TYPE_PROCESSING_INSTRUCTIONS,
    DOM_NODE_TYPE_COMMENT,
    DOM_NODE_TYPE_DOCUMENT,
    DOM_NODE_TYPE_DOCUMENT_TYPE,
    DOM_NODE_TYPE_DOCUMENT_FRAGMENT
  );

  // /include/internal/cef_types.h (cef_context_menu_media_type_t)
  TOldCefContextMenuMediaType = (
    CM_MEDIATYPE_NONE,
    CM_MEDIATYPE_IMAGE,
    CM_MEDIATYPE_VIDEO,
    CM_MEDIATYPE_AUDIO,
    CM_MEDIATYPE_FILE,
    CM_MEDIATYPE_PLUGIN
  );

  // /include/internal/cef_types.h (cef_menu_item_type_t)
  TOldCefMenuItemType = (
    MENUITEMTYPE_NONE,
    MENUITEMTYPE_COMMAND,
    MENUITEMTYPE_CHECK,
    MENUITEMTYPE_RADIO,
    MENUITEMTYPE_SEPARATOR,
    MENUITEMTYPE_SUBMENU
  );

  // /include/internal/cef_types.h (cef_focus_source_t)
  TOldCefFocusSource = (
    FOCUS_SOURCE_NAVIGATION = 0,
    FOCUS_SOURCE_SYSTEM
  );

  // /include/internal/cef_types.h (cef_jsdialog_type_t)
  TOldCefJsDialogType = (
    JSDIALOGTYPE_ALERT = 0,
    JSDIALOGTYPE_CONFIRM,
    JSDIALOGTYPE_PROMPT
  );

  // /include/internal/cef_types.h (cef_key_event_type_t)
  TOldCefKeyEventType = (
    KEYEVENT_RAWKEYDOWN = 0,
    KEYEVENT_KEYDOWN,
    KEYEVENT_KEYUP,
    KEYEVENT_CHAR
  );

  // /include/internal/cef_types.h (cef_window_open_disposition_t)
  TOldCefWindowOpenDisposition = (
    WOD_UNKNOWN,
    WOD_SUPPRESS_OPEN, {new}
    WOD_CURRENT_TAB,
    WOD_SINGLETON_TAB,
    WOD_NEW_FOREGROUND_TAB,
    WOD_NEW_BACKGROUND_TAB,
    WOD_NEW_POPUP,
    WOD_NEW_WINDOW,
    WOD_SAVE_TO_DISK,
    WOD_OFF_THE_RECORD,
    WOD_IGNORE_ACTION
  );

  // /include/internal/cef_types.h (cef_paint_element_type_t)
  TOldCefPaintElementType = (
    PET_VIEW,
    PET_POPUP
  );

  // /include/internal/cef_types.h (cef_cursor_type_t)
  TOldCefCursorType = (
    CT_POINTER = 0,
    CT_CROSS,
    CT_HAND,
    CT_IBEAM,
    CT_WAIT,
    CT_HELP,
    CT_EASTRESIZE,
    CT_NORTHRESIZE,
    CT_NORTHEASTRESIZE,
    CT_NORTHWESTRESIZE,
    CT_SOUTHRESIZE,
    CT_SOUTHEASTRESIZE,
    CT_SOUTHWESTRESIZE,
    CT_WESTRESIZE,
    CT_NORTHSOUTHRESIZE,
    CT_EASTWESTRESIZE,
    CT_NORTHEASTSOUTHWESTRESIZE,
    CT_NORTHWESTSOUTHEASTRESIZE,
    CT_COLUMNRESIZE,
    CT_ROWRESIZE,
    CT_MIDDLEPANNING,
    CT_EASTPANNING,
    CT_NORTHPANNING,
    CT_NORTHEASTPANNING,
    CT_NORTHWESTPANNING,
    CT_SOUTHPANNING,
    CT_SOUTHEASTPANNING,
    CT_SOUTHWESTPANNING,
    CT_WESTPANNING,
    CT_MOVE,
    CT_VERTICALTEXT,
    CT_CELL,
    CT_CONTEXTMENU,
    CT_ALIAS,
    CT_PROGRESS,
    CT_NODROP,
    CT_COPY,
    CT_NONE,
    CT_NOTALLOWED,
    CT_ZOOMIN,
    CT_ZOOMOUT,
    CT_GRAB,
    CT_GRABBING,
    CT_CUSTOM
  );

  // /include/internal/cef_types.h (cef_navigation_type_t)
  TOldCefNavigationType = (
    NAVIGATION_LINK_CLICKED,
    NAVIGATION_FORM_SUBMITTED,
    NAVIGATION_BACK_FORWARD,
    NAVIGATION_RELOAD,
    NAVIGATION_FORM_RESUBMITTED,
    NAVIGATION_OTHER
  );

  // /include/internal/cef_types.h (cef_process_id_t)
  TOldCefProcessId = (
    PID_BROWSER,
    PID_RENDERER
  );

  // /include/internal/cef_types.h (cef_thread_id_t)
  TOldCefThreadId = (
    TID_UI,
    TID_DB,
    TID_FILE,
    TID_FILE_USER_BLOCKING,
    TID_PROCESS_LAUNCHER,
    TID_CACHE,
    TID_IO,
    TID_RENDERER
  );

  // /include/internal/cef_types.h (cef_mouse_button_type_t)
  TOldCefMouseButtonType = (
    MBT_LEFT,
    MBT_MIDDLE,
    MBT_RIGHT
  );

  // /include/internal/cef_types.h (cef_return_value_t)
  TOldCefReturnValue = (
    RV_CANCEL = 0,
    RV_CONTINUE,
    RV_CONTINUE_ASYNC
  );

  // /include/internal/cef_types.h (cef_urlrequest_status_t)
  TOldCefUrlRequestStatus = (
    UR_UNKNOWN = 0,
    UR_SUCCESS,
    UR_IO_PENDING,
    UR_CANCELED,
    UR_FAILED
  );

  // /include/internal/cef_types.h (cef_termination_status_t)
  TOldCefTerminationStatus = (
    TS_ABNORMAL_TERMINATION,
    TS_PROCESS_WAS_KILLED,
    TS_PROCESS_CRASHED
  );

  // /include/internal/cef_types.h (cef_path_key_t)
  TOldCefPathKey = (
    PK_DIR_CURRENT,
    PK_DIR_EXE,
    PK_DIR_MODULE,
    PK_DIR_TEMP,
    PK_FILE_EXE,
    PK_FILE_MODULE,
    PK_LOCAL_APP_DATA,
    PK_USER_DATA
  );

  // /include/internal/cef_types.h (cef_storage_type_t)
  TOldCefStorageType = (
    ST_LOCALSTORAGE = 0,
    ST_SESSIONSTORAGE
  );

  // /include/internal/cef_types.h (cef_response_filter_status_t)
  TOldCefResponseFilterStatus = (
    RESPONSE_FILTER_NEED_MORE_DATA,
    RESPONSE_FILTER_DONE,
    RESPONSE_FILTER_ERROR
  );

  // /include/internal/cef_types.h (cef_plugin_policy_t)
  TOldCefPluginPolicy = (
    PLUGIN_POLICY_ALLOW,
    PLUGIN_POLICY_DETECT_IMPORTANT,
    PLUGIN_POLICY_BLOCK,
    PLUGIN_POLICY_DISABLE
  );

  // /include/internal/cef_types.h (cef_pdf_print_margin_type_t)
  TOldCefPdfPrintMarginType = (
    PDF_PRINT_MARGIN_DEFAULT,
    PDF_PRINT_MARGIN_NONE,
    PDF_PRINT_MARGIN_MINIMUM,
    PDF_PRINT_MARGIN_CUSTOM
  );

  // /include/internal/cef_types.h (cef_color_model_t)
  TOldCefColorModel = (
    COLOR_MODEL_UNKNOWN,
    COLOR_MODEL_GRAY,
    COLOR_MODEL_COLOR,
    COLOR_MODEL_CMYK,
    COLOR_MODEL_CMY,
    COLOR_MODEL_KCMY,
    COLOR_MODEL_CMY_K,
    COLOR_MODEL_BLACK,
    COLOR_MODEL_GRAYSCALE,
    COLOR_MODEL_RGB,
    COLOR_MODEL_RGB16,
    COLOR_MODEL_RGBA,
    COLOR_MODEL_COLORMODE_COLOR,
    COLOR_MODEL_COLORMODE_MONOCHROME,
    COLOR_MODEL_HP_COLOR_COLOR,
    COLOR_MODEL_HP_COLOR_BLACK,
    COLOR_MODEL_PRINTOUTMODE_NORMAL,
    COLOR_MODEL_PRINTOUTMODE_NORMAL_GRAY,
    COLOR_MODEL_PROCESSCOLORMODEL_CMYK,
    COLOR_MODEL_PROCESSCOLORMODEL_GREYSCALE,
    COLOR_MODEL_PROCESSCOLORMODEL_RGB
  );

  // /include/internal/cef_types.h (cef_json_parser_options_t)
  TOldCefJsonParserOptions = (
    JSON_PARSER_RFC = 0,
    JSON_PARSER_ALLOW_TRAILING_COMMAS = 1 shl 0
  );

  // /include/internal/cef_types.h (cef_xml_encoding_type_t)
  TOldCefXmlEncodingType = (
    XML_ENCODING_NONE = 0,
    XML_ENCODING_UTF8,
    XML_ENCODING_UTF16LE,
    XML_ENCODING_UTF16BE,
    XML_ENCODING_ASCII
  );

  // /include/internal/cef_types.h (cef_xml_node_type_t)
  TOldCefXmlNodeType = (
    XML_NODE_UNSUPPORTED = 0,
    XML_NODE_PROCESSING_INSTRUCTION,
    XML_NODE_DOCUMENT_TYPE,
    XML_NODE_ELEMENT_START,
    XML_NODE_ELEMENT_END,
    XML_NODE_ATTRIBUTE,
    XML_NODE_TEXT,
    XML_NODE_CDATA,
    XML_NODE_ENTITY_REFERENCE,
    XML_NODE_WHITESPACE,
    XML_NODE_COMMENT
  );

  // /include/internal/cef_types.h (cef_dom_event_phase_t)
  TOldCefDomEventPhase = (
    DOM_EVENT_PHASE_UNKNOWN = 0,
    DOM_EVENT_PHASE_CAPTURING,
    DOM_EVENT_PHASE_AT_TARGET,
    DOM_EVENT_PHASE_BUBBLING
  );

  // /include/internal/cef_types.h (cef_geoposition_error_code_t)
  TOldCefGeopositionErrorCode = (
    GEOPOSITON_ERROR_NONE,
    GEOPOSITON_ERROR_PERMISSION_DENIED,
    GEOPOSITON_ERROR_POSITION_UNAVAILABLE,
    GEOPOSITON_ERROR_TIMEOUT
  );

  // /include/internal/cef_time.h (cef_time_t)
  TOldCefTime = record
    year         : Integer;
    month        : Integer;
    day_of_week  : Integer;
    day_of_month : Integer;
    hour         : Integer;
    minute       : Integer;
    second       : Integer;
    millisecond  : Integer;
  end;

  // /include/internal/cef_types.h (cef_settings_t)
  TOldCefSettings = record
    size                           : NativeUInt;
    single_process                 : Integer;
    no_sandbox                     : Integer;
    browser_subprocess_path        : TOldCefString;
    multi_threaded_message_loop    : Integer;
    windowless_rendering_enabled   : Integer;
    command_line_args_disabled     : Integer;
    cache_path                     : TOldCefString;
    user_data_path                 : TOldCefString;
    persist_session_cookies        : Integer;
    persist_user_preferences       : Integer;
    user_agent                     : TOldCefString;
    product_version                : TOldCefString;
    locale                         : TOldCefString;
    log_file                       : TOldCefString;
    log_severity                   : TOldCefLogSeverity;
    javascript_flags               : TOldCefString;
    resources_dir_path             : TOldCefString;
    locales_dir_path               : TOldCefString;
    pack_loading_disabled          : Integer;
    remote_debugging_port          : Integer;
    uncaught_exception_stack_size  : Integer;
    context_safety_implementation  : Integer;
    ignore_certificate_errors      : Integer;
    background_color               : TOldCefColor;
    accept_language_list           : TOldCefString;
  end;

  // /include/internal/cef_types_win.h (cef_window_info_t)
  TOldCefWindowInfo = record
    ex_style                      : DWORD;
    window_name                   : TOldCefString;
    style                         : DWORD;
    x                             : Integer;
    y                             : Integer;
    width                         : Integer;
    height                        : Integer;
    parent_window                 : TOldCefWindowHandle;
    menu                          : HMENU;
    windowless_rendering_enabled  : Integer;
    transparent_painting_enabled  : Integer;
    window                        : TOldCefWindowHandle;
  end;

  // /include/internal/cef_types.h (cef_draggable_region_t)
  TOldCefDraggableRegion = record
    bounds    : TOldCefRect;
    draggable : Integer;
  end;

  TOldCefDraggableRegionArray = array[0..(High(Integer) div SizeOf(TOldCefDraggableRegion))-1]  of TOldCefDraggableRegion;

  // /include/internal/cef_types.h (cef_key_event_t)
  TOldCefKeyEvent = record
    kind                    : TOldCefKeyEventType;  // called 'type' in the original CEF3 source code
    modifiers               : TOldCefEventFlags;
    windows_key_code        : Integer;
    native_key_code         : Integer;
    is_system_key           : Integer;
    character               : WideChar;
    unmodified_character    : WideChar;
    focus_on_editable_field : Integer;
  end;

  // /include/internal/cef_types.h (cef_popup_features_t)
  TOldCefPopupFeatures = record
    x                  : Integer;
    xSet               : Integer;
    y                  : Integer;
    ySet               : Integer;
    width              : Integer;
    widthSet           : Integer;
    height             : Integer;
    heightSet          : Integer;
    menuBarVisible     : Integer;
    statusBarVisible   : Integer;
    toolBarVisible     : Integer;
    locationBarVisible : Integer;
    scrollbarsVisible  : Integer;
    resizable          : Integer;
    fullscreen         : Integer;
    dialog             : Integer;
    additionalFeatures : TOldCefStringList;
  end;

  // /include/internal/cef_types.h (cef_browser_settings_t)
  TOldCefBrowserSettings = record
    size                            : NativeUInt;
    windowless_frame_rate           : Integer;
    standard_font_family            : TOldCefString;
    fixed_font_family               : TOldCefString;
    serif_font_family               : TOldCefString;
    sans_serif_font_family          : TOldCefString;
    cursive_font_family             : TOldCefString;
    fantasy_font_family             : TOldCefString;
    default_font_size               : Integer;
    default_fixed_font_size         : Integer;
    minimum_font_size               : Integer;
    minimum_logical_font_size       : Integer;
    default_encoding                : TOldCefString;
    remote_fonts                    : TOldCefState;
    javascript                      : TOldCefState;
    javascript_open_windows         : TOldCefState;
    javascript_close_windows        : TOldCefState;
    javascript_access_clipboard     : TOldCefState;
    javascript_dom_paste            : TOldCefState;
    caret_browsing                  : TOldCefState;
    plugins                         : TOldCefState;
    universal_access_from_file_urls : TOldCefState;
    file_access_from_file_urls      : TOldCefState;
    web_security                    : TOldCefState;
    image_loading                   : TOldCefState;
    image_shrink_standalone_to_fit  : TOldCefState;
    text_area_resize                : TOldCefState;
    tab_to_links                    : TOldCefState;
    local_storage                   : TOldCefState;
    databases                       : TOldCefState;
    application_cache               : TOldCefState;
    webgl                           : TOldCefState;
    background_color                : TOldCefColor;
    accept_language_list            : TOldCefString;
  end;

  // /include/internal/cef_types.h (cef_screen_info_t)
  TOldCefScreenInfo = record
    device_scale_factor : Single;
    depth               : Integer;
    depth_per_component : Integer;
    is_monochrome       : Integer;
    rect                : TOldCefRect;
    available_rect      : TOldCefRect;
  end;

  // /include/internal/cef_types.h (cef_request_context_settings_t)
  TOldCefRequestContextSettings = record
    size                           : NativeUInt;
    cache_path                     : TOldCefString;
    persist_session_cookies        : Integer;
    persist_user_preferences       : Integer;
    ignore_certificate_errors      : Integer;
    accept_language_list           : TOldCefString;
  end;

  // /include/internal/cef_types.h (cef_cookie_t)
  TOldCefCookie = record
    name        : TOldCefString;
    value       : TOldCefString;
    domain      : TOldCefString;
    path        : TOldCefString;
    secure      : Integer;
    httponly    : Integer;
    creation    : TOldCefTime;
    last_access : TOldCefTime;
    has_expires : Integer;
    expires     : TOldCefTime;
  end;

  TOldCookie = record
    name        : oldustring;
    value       : oldustring;
    domain      : oldustring;
    path        : oldustring;
    creation    : TDateTime;
    last_access : TDateTime;
    expires     : TDateTime;
    secure      : boolean;
    httponly    : boolean;
    has_expires : boolean;
  end;

  // /include/internal/cef_types.h (cef_pdf_print_settings_t)
  TOldCefPdfPrintSettings = record
    header_footer_title   : TOldCefString;
    header_footer_url     : TOldCefString;
    page_width            : Integer;
    page_height           : Integer;
    margin_top            : double;
    margin_right          : double;
    margin_bottom         : double;
    margin_left           : double;
    margin_type           : TOldCefPdfPrintMarginType;
    header_footer_enabled : Integer;
    selection_only        : Integer;
    landscape             : Integer;
    backgrounds_enabled   : Integer;
  end;

  // /include/internal/cef_types.h (cef_mouse_event_t)
  TOldCefMouseEvent = record
    x         : Integer;
    y         : Integer;
    modifiers : TOldCefEventFlags;
  end;

  // /include/internal/cef_types.h (cef_geoposition_t)
  TOldCefGeoposition = record
    latitude          : Double;
    longitude         : Double;
    altitude          : Double;
    accuracy          : Double;
    altitude_accuracy : Double;
    heading           : Double;
    speed             : Double;
    timestamp         : TOldCefTime;
    error_code        : TOldCefGeopositionErrorCode;
    error_message     : TOldCefString;
  end;

  // /include/capi/cef_base_capi.h (cef_base_t)
  TOldCefBase = record
    size        : NativeUInt;
    add_ref     : procedure(self: POldCefBase); stdcall;
    release     : function(self: POldCefBase): Integer; stdcall;
    has_one_ref : function(self: POldCefBase): Integer; stdcall;
  end;

  // /include/capi/cef_stream_capi.h (cef_stream_writer_t)
  TOldCefStreamWriter = record
    base      : TOldCefBase;
    write     : function(self: POldCefStreamWriter; const ptr: Pointer; size, n: NativeUInt): NativeUInt; stdcall;
    seek      : function(self: POldCefStreamWriter; offset: Int64; whence: Integer): Integer; stdcall;
    tell      : function(self: POldCefStreamWriter): Int64; stdcall;
    flush     : function(self: POldCefStreamWriter): Integer; stdcall;
    may_block : function(self: POldCefStreamWriter): Integer; stdcall;
  end;

  // /include/capi/cef_geolocation_capi.h (cef_get_geolocation_callback_t)
  TOldCefGetGeolocationCallback = record
    base: TOldCefBase;
    on_location_update: procedure(self: POldCefGetGeolocationCallback; const position: POldCefgeoposition); stdcall;
  end;

  // /include/capi/cef_geolocation_handler_capi.h (cef_geolocation_handler_t)
  TOldCefGeolocationHandler = record
    base: TOldCefBase;
    on_request_geolocation_permission: function(self: POldCefGeolocationHandler; browser: POldCefBrowser; const requesting_url: POldCefString; request_id: Integer; callback: POldCefGeolocationCallback): Integer; stdcall;
    on_cancel_geolocation_permission: procedure(self: POldCefGeolocationHandler; browser: POldCefBrowser; request_id: Integer); stdcall;
  end;

  // /include/capi/cef_geolocation_handler_capi.h (cef_geolocation_callback_t)
  TOldCefGeolocationCallback = record
    base: TOldCefBase;
    cont: procedure(self: POldCefGeolocationCallback; allow: Integer); stdcall;
  end;

  // /include/capi/cef_ssl_info_capi.h (cef_sslcert_principal_t)
  TOldCefSslCertPrincipal = record
    base                        : TOldCefBase;
    get_display_name            : function(self: POldCefSslCertPrincipal): POldCefStringUserfree; stdcall;
    get_common_name             : function(self: POldCefSslCertPrincipal): POldCefStringUserfree; stdcall;
    get_locality_name           : function(self: POldCefSslCertPrincipal): POldCefStringUserfree; stdcall;
    get_state_or_province_name  : function(self: POldCefSslCertPrincipal): POldCefStringUserfree; stdcall;
    get_country_name            : function(self: POldCefSslCertPrincipal): POldCefStringUserfree; stdcall;
    get_street_addresses        : procedure(self: POldCefSslCertPrincipal; addresses: TOldCefStringList); stdcall;
    get_organization_names      : procedure(self: POldCefSslCertPrincipal; names: TOldCefStringList); stdcall;
    get_organization_unit_names : procedure(self: POldCefSslCertPrincipal; names: TOldCefStringList); stdcall;
    get_domain_components       : procedure(self: POldCefSslCertPrincipal; components: TOldCefStringList); stdcall;
  end;

  // /include/capi/cef_ssl_info_capi.h (cef_sslinfo_t)
  TOldCefSslInfo = record
    base                        : TOldCefBase;
    get_cert_status             : function(self: POldCefSslInfo): TOldCefCertStatus; stdcall;
    is_cert_status_error        : function(self: POldCefSslInfo): Integer; stdcall;
    is_cert_status_minor_error  : function(self: POldCefSslInfo): Integer; stdcall;
    get_subject                 : function(self: POldCefSslInfo): POldCefSslCertPrincipal; stdcall;
    get_issuer                  : function(self: POldCefSslInfo): POldCefSslCertPrincipal; stdcall;
    get_serial_number           : function(self: POldCefSslInfo): POldCefBinaryValue; stdcall;
    get_valid_start             : function(self: POldCefSslInfo): TOldCefTime; stdcall;
    get_valid_expiry            : function(self: POldCefSslInfo): TOldCefTime; stdcall;
    get_derencoded              : function(self: POldCefSslInfo): POldCefBinaryValue; stdcall;
    get_pemencoded              : function(self: POldCefSslInfo): POldCefBinaryValue; stdcall;
    get_issuer_chain_size       : function(self: POldCefSslInfo): NativeUInt; stdcall;
    get_derencoded_issuer_chain : procedure(self: POldCefSslInfo; var chainCount: NativeUInt; var chain: POldCefBinaryValue); stdcall;
    get_pemencoded_issuer_chain : procedure(self: POldCefSslInfo; var chainCount: NativeUInt; var chain: POldCefBinaryValue); stdcall;
  end;

  // /include/capi/cef_context_menu_handler_capi.h (cef_run_context_menu_callback_t)
  TOldCefRunContextMenuCallback = record
    base   : TOldCefBase;
    cont   : procedure(self: POldCefRunContextMenuCallback; command_id: Integer; event_flags: TOldCefEventFlags); stdcall;
    cancel : procedure(self: POldCefRunContextMenuCallback); stdcall;
  end;

  // /include/capi/cef_dialog_handler_capi.h (cef_file_dialog_callback_t)
  TOldCefFileDialogCallback = record
    base   : TOldCefBase;
    cont   : procedure(self: POldCefFileDialogCallback; selected_accept_filter: Integer; file_paths: TOldCefStringList); stdcall;
    cancel : procedure(self: POldCefFileDialogCallback); stdcall;
  end;

  // /include/capi/cef_dialog_handler_capi.h (cef_dialog_handler_t)
  TOldCefDialogHandler = record
    base           : TOldCefBase;
    on_file_dialog : function(self: POldCefDialogHandler; browser: POldCefBrowser; mode: TOldCefFileDialogMode; const title, default_file_path: POldCefString; accept_filters: TOldCefStringList; selected_accept_filter: Integer; callback: POldCefFileDialogCallback): Integer; stdcall;
  end;

  // /include/capi/cef_display_handler_capi.h (cef_display_handler_t)
  TOldCefDisplayHandler = record
    base                      : TOldCefBase;
    on_address_change         : procedure(self: POldCefDisplayHandler; browser: POldCefBrowser; frame: POldCefFrame; const url: POldCefString); stdcall;
    on_title_change           : procedure(self: POldCefDisplayHandler; browser: POldCefBrowser; const title: POldCefString); stdcall;
    on_favicon_urlchange      : procedure(self: POldCefDisplayHandler; browser: POldCefBrowser; icon_urls: TOldCefStringList); stdcall;
    on_fullscreen_mode_change : procedure(self: POldCefDisplayHandler; browser: POldCefBrowser; fullscreen: Integer); stdcall;
    on_tooltip                : function(self: POldCefDisplayHandler; browser: POldCefBrowser; text: POldCefString): Integer; stdcall;
    on_status_message         : procedure(self: POldCefDisplayHandler; browser: POldCefBrowser; const value: POldCefString); stdcall;
    on_console_message        : function(self: POldCefDisplayHandler; browser: POldCefBrowser; const message_, source: POldCefString; line: Integer): Integer; stdcall;
  end;

  // /include/capi/cef_download_handler_capi.h (cef_download_handler_t)
  TOldCefDownloadHandler = record
    base                : TOldCefBase;
    on_before_download  : procedure(self: POldCefDownloadHandler; browser: POldCefBrowser; download_item: POldCefDownloadItem; const suggested_name: POldCefString; callback: POldCefBeforeDownloadCallback); stdcall;
    on_download_updated : procedure(self: POldCefDownloadHandler; browser: POldCefBrowser; download_item: POldCefDownloadItem; callback: POldCefDownloadItemCallback); stdcall;
  end;

  // /include/capi/cef_drag_handler_capi.h (cef_drag_handler_t)
  TOldCefDragHandler = record
    base                         : TOldCefBase;
    on_drag_enter                : function(self: POldCefDragHandler; browser: POldCefBrowser; dragData: POldCefDragData; mask: TOldCefDragOperations): Integer; stdcall;
    on_draggable_regions_changed : procedure(self: POldCefDragHandler; browser: POldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray); stdcall;
  end;

  // /include/capi/cef_find_handler_capi.h (cef_find_handler_t)
  TOldCefFindHandler = record
    base           : TOldCefBase;
    on_find_result : procedure(self: POldCefFindHandler; browser: POldCefBrowser; identifier, count: Integer; const selection_rect: POldCefRect; active_match_ordinal, final_update: Integer); stdcall;
  end;

  // /include/capi/cef_focus_handler_capi.h (cef_focus_handler_t)
  TOldCefFocusHandler = record
    base          : TOldCefBase;
    on_take_focus : procedure(self: POldCefFocusHandler; browser: POldCefBrowser; next: Integer); stdcall;
    on_set_focus  : function(self: POldCefFocusHandler; browser: POldCefBrowser; source: TOldCefFocusSource): Integer; stdcall;
    on_got_focus  : procedure(self: POldCefFocusHandler; browser: POldCefBrowser); stdcall;
  end;

  // /include/capi/cef_jsdialog_handler_capi.h (cef_jsdialog_handler_t)
  TOldCefJsDialogHandler = record
    base                    : TOldCefBase;
    on_jsdialog             : function(self: POldCefJsDialogHandler; browser: POldCefBrowser; const origin_url, accept_lang: POldCefString; dialog_type: TOldCefJsDialogType; const message_text, default_prompt_text: POldCefString; callback: POldCefJsDialogCallback; suppress_message: PInteger): Integer; stdcall;
    on_before_unload_dialog : function(self: POldCefJsDialogHandler; browser: POldCefBrowser; const message_text: POldCefString; is_reload: Integer; callback: POldCefJsDialogCallback): Integer; stdcall;
    on_reset_dialog_state   : procedure(self: POldCefJsDialogHandler; browser: POldCefBrowser); stdcall;
    on_dialog_closed        : procedure(self: POldCefJsDialogHandler; browser: POldCefBrowser); stdcall;
  end;

  // /include/capi/cef_jsdialog_handler_capi.h (cef_jsdialog_callback_t)
  TOldCefJsDialogCallback = record
    base : TOldCefBase;
    cont : procedure(self: POldCefJsDialogCallback; success: Integer; const user_input: POldCefString); stdcall;
  end;

  // /include/capi/cef_keyboard_handler_capi.h (cef_keyboard_handler_t)
  TOldCefKeyboardHandler = record
    base             : TOldCefBase;
    on_pre_key_event : function(self: POldCefKeyboardHandler; browser: POldCefBrowser; const event: POldCefKeyEvent; os_event: TOldCefEventHandle; is_keyboard_shortcut: PInteger): Integer; stdcall;
    on_key_event     : function(self: POldCefKeyboardHandler; browser: POldCefBrowser; const event: POldCefKeyEvent; os_event: TOldCefEventHandle): Integer; stdcall;
  end;

  // /include/capi/cef_life_span_handler_capi.h (cef_life_span_handler_t)
  TOldCefLifeSpanHandler = record
    base              : TOldCefBase;
    on_before_popup   : function(self: POldCefLifeSpanHandler; browser: POldCefBrowser; frame: POldCefFrame; const target_url, target_frame_name: POldCefString; target_disposition: TOldCefWindowOpenDisposition; user_gesture: Integer; const popupFeatures: POldCefPopupFeatures; windowInfo: POldCefWindowInfo; var client: POldCefClient; settings: POldCefBrowserSettings; no_javascript_access: PInteger): Integer; stdcall;
    on_after_created  : procedure(self: POldCefLifeSpanHandler; browser: POldCefBrowser); stdcall;
    {new} run_modal         : function(self: POldCefLifeSpanHandler; browser: POldCefBrowser): Integer; stdcall;
    do_close          : function(self: POldCefLifeSpanHandler; browser: POldCefBrowser): Integer; stdcall;
    on_before_close   : procedure(self: POldCefLifeSpanHandler; browser: POldCefBrowser); stdcall;
  end;

  // /include/capi/cef_load_handler_capi.h (cef_load_handler_t)
  TOldCefLoadHandler = record
    base                    : TOldCefBase;
    on_loading_state_change : procedure(self: POldCefLoadHandler; browser: POldCefBrowser; isLoading, canGoBack, canGoForward: Integer); stdcall;
    on_load_start           : procedure(self: POldCefLoadHandler; browser: POldCefBrowser; frame: POldCefFrame); stdcall;
    on_load_end             : procedure(self: POldCefLoadHandler; browser: POldCefBrowser; frame: POldCefFrame; httpStatusCode: Integer); stdcall;
    on_load_error           : procedure(self: POldCefLoadHandler; browser: POldCefBrowser; frame: POldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: POldCefString); stdcall;
  end;

  // /include/capi/cef_render_handler_capi.h (cef_render_handler_t)
  TOldCefRenderHandler = record
    base                              : TOldCefBase;
    get_root_screen_rect              : function(self: POldCefRenderHandler; browser: POldCefBrowser; rect: POldCefRect): Integer; stdcall;
    get_view_rect                     : function(self: POldCefRenderHandler; browser: POldCefBrowser; rect: POldCefRect): Integer; stdcall;
    get_screen_point                  : function(self: POldCefRenderHandler; browser: POldCefBrowser; viewX, viewY: Integer; screenX, screenY: PInteger): Integer; stdcall;
    get_screen_info                   : function(self: POldCefRenderHandler; browser: POldCefBrowser; screen_info: POldCefScreenInfo): Integer; stdcall;
    on_popup_show                     : procedure(self: POldCefRenderHandler; browser: POldCefBrowser; show: Integer); stdcall;
    on_popup_size                     : procedure(self: POldCefRenderHandler; browser: POldCefBrowser; const rect: POldCefRect); stdcall;
    on_paint                          : procedure(self: POldCefRenderHandler; browser: POldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer); stdcall;
    on_cursor_change                  : procedure(self: POldCefRenderHandler; browser: POldCefBrowser; cursor: TOldCefCursorHandle; type_: TOldCefCursorType; const custom_cursor_info: POldCefCursorInfo); stdcall;
    start_dragging                    : function(self: POldCefRenderHandler; browser: POldCefBrowser; drag_data: POldCefDragData; allowed_ops: TOldCefDragOperations; x, y: Integer): Integer; stdcall;
    update_drag_cursor                : procedure(self: POldCefRenderHandler; browser: POldCefBrowser; operation: TOldCefDragOperation); stdcall;
    on_scroll_offset_changed          : procedure(self: POldCefRenderHandler; browser: POldCefBrowser; x, y: Double); stdcall;
  end;

  // /include/capi/cef_v8_capi.h (cef_v8stack_trace_t)
  TOldCefV8StackTrace = record
    base            : TOldCefBase;
    is_valid        : function(self: POldCefV8StackTrace): Integer; stdcall;
    get_frame_count : function(self: POldCefV8StackTrace): Integer; stdcall;
    get_frame       : function(self: POldCefV8StackTrace; index: Integer): POldCefV8StackFrame; stdcall;
  end;

  // /include/capi/cef_v8_capi.h (cef_v8stack_frame_t)
  TOldCefV8StackFrame = record
    base                          : TOldCefBase;
    is_valid                      : function(self: POldCefV8StackFrame): Integer; stdcall;
    get_script_name               : function(self: POldCefV8StackFrame): POldCefStringUserFree; stdcall;
    get_script_name_or_source_url : function(self: POldCefV8StackFrame): POldCefStringUserFree; stdcall;
    get_function_name             : function(self: POldCefV8StackFrame): POldCefStringUserFree; stdcall;
    get_line_number               : function(self: POldCefV8StackFrame): Integer; stdcall;
    get_column                    : function(self: POldCefV8StackFrame): Integer; stdcall;
    is_eval                       : function(self: POldCefV8StackFrame): Integer; stdcall;
    is_constructor                : function(self: POldCefV8StackFrame): Integer; stdcall;
  end;

  // TOldCefStreamReader is used with ICefStreamReader and ICefCustomStreamReader !!!!
  // /include/capi/cef_stream_capi.h (cef_stream_reader_t)
  TOldCefStreamReader = record
    base      : TOldCefBase;
    read      : function(self: POldCefStreamReader; ptr: Pointer; size, n: NativeUInt): NativeUInt; stdcall;
    seek      : function(self: POldCefStreamReader; offset: Int64; whence: Integer): Integer; stdcall;
    tell      : function(self: POldCefStreamReader): Int64; stdcall;
    eof       : function(self: POldCefStreamReader): Integer; stdcall;
    may_block : function(self: POldCefStreamReader): Integer; stdcall;
  end;

  // /include/capi/cef_stream_capi.h (cef_read_handler_t)
  TOldCefReadHandler = record
    base      : TOldCefBase;
    read      : function(self: POldCefReadHandler; ptr: Pointer; size, n: NativeUInt): NativeUInt; stdcall;
    seek      : function(self: POldCefReadHandler; offset: Int64; whence: Integer): Integer; stdcall;
    tell      : function(self: POldCefReadHandler): Int64; stdcall;
    eof       : function(self: POldCefReadHandler): Integer; stdcall;
    may_block : function(self: POldCefReadHandler): Integer; stdcall;
  end;

  // /include/capi/cef_stream_capi.h (cef_write_handler_t)
  TOldCefWriteHandler = record
    base      : TOldCefBase;
    write     : function(self: POldCefWriteHandler; const ptr: Pointer; size, n: NativeUInt): NativeUInt; stdcall;
    seek      : function(self: POldCefWriteHandler; offset: Int64; whence: Integer): Integer; stdcall;
    tell      : function(self: POldCefWriteHandler): Int64; stdcall;
    flush     : function(self: POldCefWriteHandler): Integer; stdcall;
    may_block : function(self: POldCefWriteHandler): Integer; stdcall;
  end;

  // /include/capi/cef_xml_reader_capi.h (cef_xml_reader_t)
  TOldCefXmlReader = record
    base                      : TOldCefBase;
    move_to_next_node         : function(self: POldCefXmlReader): Integer; stdcall;
    close                     : function(self: POldCefXmlReader): Integer; stdcall;
    has_error                 : function(self: POldCefXmlReader): Integer; stdcall;
    get_error                 : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_type                  : function(self: POldCefXmlReader): TOldCefXmlNodeType; stdcall;
    get_depth                 : function(self: POldCefXmlReader): Integer; stdcall;
    get_local_name            : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_prefix                : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_qualified_name        : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_namespace_uri         : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_base_uri              : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_xml_lang              : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    is_empty_element          : function(self: POldCefXmlReader): Integer; stdcall;
    has_value                 : function(self: POldCefXmlReader): Integer; stdcall;
    get_value                 : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    has_attributes            : function(self: POldCefXmlReader): Integer; stdcall;
    get_attribute_count       : function(self: POldCefXmlReader): NativeUInt; stdcall;
    get_attribute_byindex     : function(self: POldCefXmlReader; index: Integer): POldCefStringUserFree; stdcall;
    get_attribute_byqname     : function(self: POldCefXmlReader; const qualifiedName: POldCefString): POldCefStringUserFree; stdcall;
    get_attribute_bylname     : function(self: POldCefXmlReader; const localName, namespaceURI: POldCefString): POldCefStringUserFree; stdcall;
    get_inner_xml             : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_outer_xml             : function(self: POldCefXmlReader): POldCefStringUserFree; stdcall;
    get_line_number           : function(self: POldCefXmlReader): Integer; stdcall;
    move_to_attribute_byindex : function(self: POldCefXmlReader; index: Integer): Integer; stdcall;
    move_to_attribute_byqname : function(self: POldCefXmlReader; const qualifiedName: POldCefString): Integer; stdcall;
    move_to_attribute_bylname : function(self: POldCefXmlReader; const localName, namespaceURI: POldCefString): Integer; stdcall;
    move_to_first_attribute   : function(self: POldCefXmlReader): Integer; stdcall;
    move_to_next_attribute    : function(self: POldCefXmlReader): Integer; stdcall;
    move_to_carrying_element  : function(self: POldCefXmlReader): Integer; stdcall;
  end;

  // /include/capi/cef_zip_reader_capi.h (cef_zip_reader_t)
  TOldCefZipReader = record
    base                    : TOldCefBase;
    move_to_first_file      : function(self: POldCefZipReader): Integer; stdcall;
    move_to_next_file       : function(self: POldCefZipReader): Integer; stdcall;
    move_to_file            : function(self: POldCefZipReader; const fileName: POldCefString; caseSensitive: Integer): Integer; stdcall;
    close                   : function(Self: POldCefZipReader): Integer; stdcall;
    get_file_name           : function(Self: POldCefZipReader): POldCefStringUserFree; stdcall;
    get_file_size           : function(Self: POldCefZipReader): Int64; stdcall;
    get_file_last_modified  : function(Self: POldCefZipReader): TOldCefTime; stdcall;
    open_file               : function(Self: POldCefZipReader; const password: POldCefString): Integer; stdcall;
    close_file              : function(Self: POldCefZipReader): Integer; stdcall;
    read_file               : function(Self: POldCefZipReader; buffer: Pointer; bufferSize: NativeUInt): Integer; stdcall;
    tell                    : function(Self: POldCefZipReader): Int64; stdcall;
    eof                     : function(Self: POldCefZipReader): Integer; stdcall;
  end;

  // /include/capi/cef_urlrequest_capi.h (cef_urlrequest_client_t)
  TOldCefUrlrequestClient = record
    base                  : TOldCefBase;
    on_request_complete   : procedure(self: POldCefUrlRequestClient; request: POldCefUrlRequest); stdcall;
    on_upload_progress    : procedure(self: POldCefUrlRequestClient; request: POldCefUrlRequest; current, total: Int64); stdcall;
    on_download_progress  : procedure(self: POldCefUrlRequestClient; request: POldCefUrlRequest; current, total: Int64); stdcall;
    on_download_data      : procedure(self: POldCefUrlRequestClient; request: POldCefUrlRequest; const data: Pointer; data_length: NativeUInt); stdcall;
    get_auth_credentials  : function(self: POldCefUrlRequestClient; isProxy: Integer; const host: POldCefString; port: Integer; const realm, scheme: POldCefString; callback: POldCefAuthCallback): Integer; stdcall;
  end;

  // /include/capi/cef_urlrequest_capi.h (cef_urlrequest_t)
  TOldCefUrlRequest = record
    base                : TOldCefBase;
    get_request         : function(self: POldCefUrlRequest): POldCefRequest; stdcall;
    get_client          : function(self: POldCefUrlRequest): POldCefUrlRequestClient; stdcall;
    get_request_status  : function(self: POldCefUrlRequest): TOldCefUrlRequestStatus; stdcall;
    get_request_error   : function(self: POldCefUrlRequest): TOldCefErrorcode; stdcall;
    get_response        : function(self: POldCefUrlRequest): POldCefResponse; stdcall;
    cancel              : procedure(self: POldCefUrlRequest); stdcall;
  end;

  // /include/capi/cef_web_plugin_capi.h (cef_web_plugin_info_visitor_t)
  TOldCefWebPluginInfoVisitor = record
    base  : TOldCefBase;
    visit : function(self: POldCefWebPluginInfoVisitor; info: POldCefWebPluginInfo; count, total: Integer): Integer; stdcall;
  end;

  // /include/capi/cef_web_plugin_capi.h (cef_web_plugin_unstable_callback_t)
  TOldCefWebPluginUnstableCallback = record
    base        : TOldCefBase;
    is_unstable : procedure(self: POldCefWebPluginUnstableCallback; const path: POldCefString; unstable: Integer); stdcall;
  end;

  // /include/capi/cef_task_capi.h (cef_task_runner_t)
  TOldCefTaskRunner = record
    base                      : TOldCefBase;
    is_same                   : function(self, that: POldCefTaskRunner): Integer; stdcall;
    belongs_to_current_thread : function(self: POldCefTaskRunner): Integer; stdcall;
    belongs_to_thread         : function(self: POldCefTaskRunner; threadId: TOldCefThreadId): Integer; stdcall;
    post_task                 : function(self: POldCefTaskRunner; task: POldCefTask): Integer; stdcall;
    post_delayed_task         : function(self: POldCefTaskRunner; task: POldCefTask; delay_ms: Int64): Integer; stdcall;
  end;

  // /include/capi/cef_trace_capi.h (cef_end_tracing_callback_t)
  TOldCefEndTracingCallback = record
    base                    : TOldCefBase;
    on_end_tracing_complete : procedure(self: POldCefEndTracingCallback; const tracing_file: POldCefString); stdcall;
  end;

  // /include/capi/cef_resource_bundle_capi.h (cef_resource_bundle_t)
  TOldCefResourceBundle = record
    base                        : TOldCefBase;
    get_localized_string        : function(self: POldCefResourceBundle; string_id: Integer): POldCefStringUserFree; stdcall;
    get_data_resource           : function(self: POldCefResourceBundle; resource_id: Integer; var data: Pointer; var data_size: NativeUInt): Integer; stdcall;
    get_data_resource_for_scale : function(self: POldCefResourceBundle; resource_id: Integer; scale_factor: TOldCefScaleFactor; var data: Pointer; var data_size: NativeUInt): Integer; stdcall;
  end;

  // /include/capi/cef_process_message_capi.h (cef_process_message_t)
  TOldCefProcessMessage = record
    base              : TOldCefBase;
    is_valid          : function(self: POldCefProcessMessage): Integer; stdcall;
    is_read_only      : function(self: POldCefProcessMessage): Integer; stdcall;
    copy              : function(self: POldCefProcessMessage): POldCefProcessMessage; stdcall;
    get_name          : function(self: POldCefProcessMessage): POldCefStringUserFree; stdcall;
    get_argument_list : function(self: POldCefProcessMessage): POldCefListValue; stdcall;
  end;

  // /include/capi/cef_render_process_handler_capi.h (cef_render_process_handler_t)
  TOldCefRenderProcessHandler = record
    base                        : TOldCefBase;
    on_render_thread_created    : procedure(self: POldCefRenderProcessHandler; extra_info: POldCefListValue); stdcall;
    on_web_kit_initialized      : procedure(self: POldCefRenderProcessHandler); stdcall;
    on_browser_created          : procedure(self: POldCefRenderProcessHandler; browser: POldCefBrowser); stdcall;
    on_browser_destroyed        : procedure(self: POldCefRenderProcessHandler; browser: POldCefBrowser); stdcall;
    get_load_handler            : function(self: POldCefRenderProcessHandler): POldCefLoadHandler; stdcall;
    on_before_navigation        : function(self: POldCefRenderProcessHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; navigation_type: TOldCefNavigationType; is_redirect: Integer): Integer; stdcall;
    on_context_created          : procedure(self: POldCefRenderProcessHandler; browser: POldCefBrowser; frame: POldCefFrame; context: POldCefv8Context); stdcall;
    on_context_released         : procedure(self: POldCefRenderProcessHandler; browser: POldCefBrowser; frame: POldCefFrame; context: POldCefv8Context); stdcall;
    on_uncaught_exception       : procedure(self: POldCefRenderProcessHandler; browser: POldCefBrowser; frame: POldCefFrame; context: POldCefv8Context; exception: POldCefV8Exception; stackTrace: POldCefV8StackTrace); stdcall;
    on_focused_node_changed     : procedure(self: POldCefRenderProcessHandler; browser: POldCefBrowser; frame: POldCefFrame; node: POldCefDomNode); stdcall;
    on_process_message_received : function(self: POldCefRenderProcessHandler; browser: POldCefBrowser; source_process: TOldCefProcessId; message_: POldCefProcessMessage): Integer; stdcall;
  end;

  // /include/capi/cef_request_handler_capi.h (cef_request_handler_t)
  TOldCefRequestHandler = record
    base                          : TOldCefBase;
    on_before_browse              : function(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; isRedirect: Integer): Integer; stdcall;
    on_open_urlfrom_tab           : function(self: POldCefRequestHandler; browser:POldCefBrowser; frame: POldCefFrame; const target_url: POldCefString; target_disposition: TOldCefWindowOpenDisposition; user_gesture: Integer): Integer; stdcall;
    on_before_resource_load       : function(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; callback: POldCefRequestCallback): TOldCefReturnValue; stdcall;
    get_resource_handler          : function(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest): POldCefResourceHandler; stdcall;
    on_resource_redirect          : procedure(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; new_url: POldCefString); stdcall;
    on_resource_response          : function(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; response: POldCefResponse): Integer; stdcall;
    get_resource_response_filter  : function(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; response: POldCefResponse): POldCefResponseFilter; stdcall;
    on_resource_load_complete     : procedure(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; request: POldCefRequest; response: POldCefResponse; status: TOldCefUrlRequestStatus; received_content_length: Int64); stdcall;
    get_auth_credentials          : function(self: POldCefRequestHandler; browser: POldCefBrowser; frame: POldCefFrame; isProxy: Integer; const host: POldCefString; port: Integer; const realm, scheme: POldCefString; callback: POldCefAuthCallback): Integer; stdcall;
    on_quota_request              : function(self: POldCefRequestHandler; browser: POldCefBrowser; const origin_url: POldCefString; new_size: Int64; callback: POldCefRequestCallback): Integer; stdcall;
    on_protocol_execution         : procedure(self: POldCefRequestHandler; browser: POldCefBrowser; const url: POldCefString; allow_os_execution: PInteger); stdcall;
    on_certificate_error          : function(self: POldCefRequestHandler; browser: POldCefBrowser; cert_error: TOldCefErrorcode; const request_url: POldCefString; ssl_info: POldCefSslInfo; callback: POldCefRequestCallback): Integer; stdcall;
    on_plugin_crashed             : procedure(self: POldCefRequestHandler; browser: POldCefBrowser; const plugin_path: POldCefString); stdcall;
    on_render_view_ready          : procedure(self: POldCefRequestHandler; browser: POldCefBrowser); stdcall;
    on_render_process_terminated  : procedure(self: POldCefRequestHandler; browser: POldCefBrowser; status: TOldCefTerminationStatus); stdcall;
  end;

  // /include/capi/cef_request_handler_capi.h (cef_request_callback_t)
  TOldCefRequestCallback = record
    base   : TOldCefBase;
    cont   : procedure(self: POldCefRequestCallback; allow: Integer); stdcall;
    cancel : procedure(self: POldCefRequestCallback); stdcall;
  end;

  // /include/capi/cef_resource_handler_capi.h (cef_resource_handler_t)
  TOldCefResourceHandler = record
    base                  : TOldCefBase;
    process_request       : function(self: POldCefResourceHandler; request: POldCefRequest; callback: POldCefCallback): Integer; stdcall;
    get_response_headers  : procedure(self: POldCefResourceHandler; response: POldCefResponse; response_length: PInt64; redirectUrl: POldCefString); stdcall;
    read_response         : function(self: POldCefResourceHandler; data_out: Pointer; bytes_to_read: Integer; bytes_read: PInteger; callback: POldCefCallback): Integer; stdcall;
    can_get_cookie        : function(self: POldCefResourceHandler; const cookie: POldCefCookie): Integer; stdcall;
    can_set_cookie        : function(self: POldCefResourceHandler; const cookie: POldCefCookie): Integer; stdcall;
    cancel                : procedure(self: POldCefResourceHandler); stdcall;
  end;

  // /include/capi/cef_response_capi.h (cef_response_t)
  TOldCefResponse = record
    base            : TOldCefBase;
    is_read_only    : function(self: POldCefResponse): Integer; stdcall;
    get_status      : function(self: POldCefResponse): Integer; stdcall;
    set_status      : procedure(self: POldCefResponse; status: Integer); stdcall;
    get_status_text : function(self: POldCefResponse): POldCefStringUserFree; stdcall;
    set_status_text : procedure(self: POldCefResponse; const statusText: POldCefString); stdcall;
    get_mime_type   : function(self: POldCefResponse): POldCefStringUserFree; stdcall;
    set_mime_type   : procedure(self: POldCefResponse; const mimeType: POldCefString); stdcall;
    get_header      : function(self: POldCefResponse; const name: POldCefString): POldCefStringUserFree; stdcall;
    get_header_map  : procedure(self: POldCefResponse; headerMap: TOldCefStringMultimap); stdcall;
    set_header_map  : procedure(self: POldCefResponse; headerMap: TOldCefStringMultimap); stdcall;
  end;

  // /include/capi/cef_response_filter_capi.h (cef_response_filter_t)
  TOldCefResponseFilter = record
    base        : TOldCefBase;
    init_filter : function(self: POldCefResponseFilter): Integer; stdcall;
    filter      : function(self: POldCefResponseFilter; data_in: Pointer; data_in_size: NativeUInt; var data_in_read: NativeUInt; data_out: Pointer; data_out_size : NativeUInt; var data_out_written: NativeUInt): TOldCefResponseFilterStatus; stdcall;
  end;

  // /include/capi/cef_auth_callback_capi.h (cef_auth_callback_t)
  TOldCefAuthCallback = record
    base   : TOldCefBase;
    cont   : procedure(self: POldCefAuthCallback; const username, password: POldCefString); stdcall;
    cancel : procedure(self: POldCefAuthCallback); stdcall;
  end;

  // /include/capi/cef_callback_capi.h (cef_callback_t)
  TOldCefCallback = record
    base   : TOldCefBase;
    cont   : procedure(self: POldCefCallback); stdcall;
    cancel : procedure(self: POldCefCallback); stdcall;
  end;

  // /include/capi/cef_request_context_capi.h (cef_request_context_t)
  TOldCefRequestContext = record
    base                            : TOldCefBase;
    is_same                         : function(self, other: POldCefRequestContext): Integer; stdcall;
    is_sharing_with                 : function(self, other: POldCefRequestContext): Integer; stdcall;
    is_global                       : function(self: POldCefRequestContext): Integer; stdcall;
    get_handler                     : function(self: POldCefRequestContext): POldCefRequestContextHandler; stdcall;
    get_cache_path                  : function(self: POldCefRequestContext): POldCefStringUserFree; stdcall;
    get_default_cookie_manager      : function(self: POldCefRequestContext; callback: POldCefCompletionCallback): POldCefCookieManager; stdcall;
    register_scheme_handler_factory : function(self: POldCefRequestContext; const scheme_name, domain_name: POldCefString; factory: POldCefSchemeHandlerFactory): Integer; stdcall;
    clear_scheme_handler_factories  : function(self: POldCefRequestContext): Integer; stdcall;
    purge_plugin_list_cache         : procedure(self: POldCefRequestContext; reload_pages: Integer); stdcall;
    has_preference                  : function(self: POldCefRequestContext; const name: POldCefString): Integer; stdcall;
    get_preference                  : function(self: POldCefRequestContext; const name: POldCefString): POldCefValue; stdcall;
    get_all_preferences             : function(self: POldCefRequestContext; include_defaults: Integer): POldCefDictionaryValue; stdcall;
    can_set_preference              : function(self: POldCefRequestContext; const name: POldCefString): Integer; stdcall;
    set_preference                  : function(self: POldCefRequestContext; const name: POldCefString; value: POldCefValue; error: POldCefString): Integer; stdcall;
    clear_certificate_exceptions    : procedure(self: POldCefRequestContext; callback: POldCefCompletionCallback); stdcall;
    close_all_connections           : procedure(self: POldCefRequestContext; callback: POldCefCompletionCallback); stdcall;
    resolve_host                    : procedure(self: POldCefRequestContext; const origin: POldCefString; callback: POldCefResolveCallback); stdcall;
    resolve_host_cached             : function(self: POldCefRequestContext; const origin: POldCefString; resolved_ips: TOldCefStringList): TOldCefErrorCode; stdcall;
  end;

  // /include/capi/cef_request_context_handler_capi.h (cef_request_context_handler_t)
  TOldCefRequestContextHandler = record
    base                            : TOldCefBase;
    get_cookie_manager              : function(self: POldCefRequestContextHandler): POldCefCookieManager; stdcall;
    on_before_plugin_load           : function(self: POldCefRequestContextHandler; const mime_type, plugin_url : POldCefString; const top_origin_url: POldCefString; plugin_info: POldCefWebPluginInfo; plugin_policy: POldCefPluginPolicy): Integer; stdcall;
  end;

  // /include/capi/cef_callback_capi.h (cef_completion_callback_t)
  TOldCefCompletionCallback = record
    base        : TOldCefBase;
    on_complete : procedure(self: POldCefCompletionCallback); stdcall;
  end;

  // /include/capi/cef_cookie_capi.h (cef_cookie_manager_t)
  TOldCefCookieManager = record
    base                  : TOldCefBase;
    set_supported_schemes : procedure(self: POldCefCookieManager; schemes: TOldCefStringList; callback: POldCefCompletionCallback); stdcall;
    visit_all_cookies     : function(self: POldCefCookieManager; visitor: POldCefCookieVisitor): Integer; stdcall;
    visit_url_cookies     : function(self: POldCefCookieManager; const url: POldCefString; includeHttpOnly: Integer; visitor: POldCefCookieVisitor): Integer; stdcall;
    set_cookie            : function(self: POldCefCookieManager; const url: POldCefString; const cookie: POldCefCookie; callback: POldCefSetCookieCallback): Integer; stdcall;
    delete_cookies        : function(self: POldCefCookieManager; const url, cookie_name: POldCefString; callback: POldCefDeleteCookiesCallback): Integer; stdcall;
    set_storage_path      : function(self: POldCefCookieManager; const path: POldCefString; persist_session_cookies: Integer; callback: POldCefCompletionCallback): Integer; stdcall;
    flush_store           : function(self: POldCefCookieManager; handler: POldCefCompletionCallback): Integer; stdcall;
  end;

  // /include/capi/cef_scheme_capi.h (cef_scheme_handler_factory_t)
  TOldCefSchemeHandlerFactory = record
    base   : TOldCefBase;
    create : function(self: POldCefSchemeHandlerFactory; browser: POldCefBrowser; frame: POldCefFrame; const scheme_name: POldCefString; request: POldCefRequest): POldCefResourceHandler; stdcall;
  end;

  // /include/capi/cef_request_context_capi.h (cef_resolve_callback_t)
  TOldCefResolveCallback = record
    base                 : TOldCefBase;
    on_resolve_completed : procedure(self: POldCefResolveCallback; result: TOldCefErrorCode; resolved_ips: TOldCefStringList); stdcall;
  end;

  // /include/capi/cef_web_plugin_capi.h (cef_web_plugin_info_t)
  TOldCefWebPluginInfo = record
    base            : TOldCefBase;
    get_name        : function(self: POldCefWebPluginInfo): POldCefStringUserFree; stdcall;
    get_path        : function(self: POldCefWebPluginInfo): POldCefStringUserFree; stdcall;
    get_version     : function(self: POldCefWebPluginInfo): POldCefStringUserFree; stdcall;
    get_description : function(self: POldCefWebPluginInfo): POldCefStringUserFree; stdcall;
  end;

  // /include/capi/cef_cookie_capi.h (cef_cookie_visitor_t)
  TOldCefCookieVisitor = record
    base  : TOldCefBase;
    visit : function(self: POldCefCookieVisitor; const cookie: POldCefCookie; count, total: Integer; deleteCookie: PInteger): Integer; stdcall;
  end;

  // /include/capi/cef_cookie_capi.h (cef_set_cookie_callback_t)
  TOldCefSetCookieCallback = record
    base        : TOldCefBase;
    on_complete : procedure(self: POldCefSetCookieCallback; success: Integer); stdcall;
  end;

  // /include/capi/cef_cookie_capi.h (cef_delete_cookies_callback_t)
  TOldCefDeleteCookiesCallback = record
    base        : TOldCefBase;
    on_complete : procedure(self: POldCefDeleteCookiesCallback; num_deleted: Integer); stdcall;
  end;

  // /include/capi/cef_browser_capi.h (cef_run_file_dialog_callback_t)
  TOldCefRunFileDialogCallback = record
    base                     : TOldCefBase;
    on_file_dialog_dismissed : procedure(self: POldCefRunFileDialogCallback; selected_accept_filter: Integer; file_paths: TOldCefStringList); stdcall;
  end;

  // /include/capi/cef_browser_capi.h (cef_pdf_print_callback_t)
  TOldCefPdfPrintCallback = record
    base                  : TOldCefBase;
    on_pdf_print_finished : procedure(self: POldCefPdfPrintCallback; const path: POldCefString; ok: Integer); stdcall;
  end;

  // /include/capi/cef_browser_capi.h (cef_navigation_entry_visitor_t)
  TOldCefNavigationEntryVisitor = record
    base  : TOldCefBase;
    visit : function(self: POldCefNavigationEntryVisitor; entry: POldCefNavigationEntry; current, index, total: Integer): Integer; stdcall;
  end;

  // /include/capi/cef_navigation_entry_capi.h (cef_navigation_entry_t)
  TOldCefNavigationEntry = record
    base                  : TOldCefBase;
    is_valid              : function(self: POldCefNavigationEntry): Integer; stdcall;
    get_url               : function(self: POldCefNavigationEntry): POldCefStringUserFree; stdcall;
    get_display_url       : function(self: POldCefNavigationEntry): POldCefStringUserFree; stdcall;
    get_original_url      : function(self: POldCefNavigationEntry): POldCefStringUserFree; stdcall;
    get_title             : function(self: POldCefNavigationEntry): POldCefStringUserFree; stdcall;
    get_transition_type   : function(self: POldCefNavigationEntry): TOldCefTransitionType; stdcall;
    has_post_data         : function(self: POldCefNavigationEntry): Integer; stdcall;
    get_completion_time   : function(self: POldCefNavigationEntry): TOldCefTime; stdcall;
    get_http_status_code  : function(self: POldCefNavigationEntry): Integer; stdcall;
  end;

  // /include/capi/cef_print_settings_capi.h (cef_print_settings_t)
  TOldCefPrintSettings = record
    base                        : TOldCefBase;
    is_valid                    : function(self: POldCefPrintSettings): Integer; stdcall;
    is_read_only                : function(self: POldCefPrintSettings): Integer; stdcall;
    copy                        : function(self: POldCefPrintSettings): POldCefPrintSettings; stdcall;
    set_orientation             : procedure(self: POldCefPrintSettings; landscape: Integer); stdcall;
    is_landscape                : function(self: POldCefPrintSettings): Integer; stdcall;
    set_printer_printable_area  : procedure(self: POldCefPrintSettings; const physical_size_device_units: POldCefSize; const printable_area_device_units: POldCefRect; landscape_needs_flip: Integer); stdcall;
    set_device_name             : procedure(self: POldCefPrintSettings; const name: POldCefString); stdcall;
    get_device_name             : function(self: POldCefPrintSettings): POldCefStringUserFree; stdcall;
    set_dpi                     : procedure(self: POldCefPrintSettings; dpi: Integer); stdcall;
    get_dpi                     : function(self: POldCefPrintSettings): Integer; stdcall;
    set_page_ranges             : procedure(self: POldCefPrintSettings; rangesCount: NativeUInt; ranges: POldCefPageRange); stdcall;
    get_page_ranges_count       : function(self: POldCefPrintSettings): NativeUInt; stdcall;
    get_page_ranges             : procedure(self: POldCefPrintSettings; rangesCount: PNativeUInt; ranges: POldCefPageRange); stdcall;
    set_selection_only          : procedure(self: POldCefPrintSettings; selection_only: Integer); stdcall;
    is_selection_only           : function(self: POldCefPrintSettings): Integer; stdcall;
    set_collate                 : procedure(self: POldCefPrintSettings; collate: Integer); stdcall;
    will_collate                : function(self: POldCefPrintSettings): Integer; stdcall;
    set_color_model             : procedure(self: POldCefPrintSettings; model: TOldCefColorModel); stdcall;
    get_color_model             : function(self: POldCefPrintSettings): TOldCefColorModel; stdcall;
    set_copies                  : procedure(self: POldCefPrintSettings; copies: Integer); stdcall;
    get_copies                  : function(self: POldCefPrintSettings): Integer; stdcall;
    set_duplex_mode             : procedure(self: POldCefPrintSettings; mode: TOldCefDuplexMode); stdcall;
    get_duplex_mode             : function(self: POldCefPrintSettings): TOldCefDuplexMode; stdcall;
  end;

  // /include/capi/cef_print_handler_capi.h (cef_print_dialog_callback_t)
  TOldCefPrintDialogCallback = record
    base   : TOldCefBase;
    cont   : procedure(self: POldCefPrintDialogCallback; settings: POldCefPrintSettings); stdcall;
    cancel : procedure(self: POldCefPrintDialogCallback); stdcall;
  end;

  // /include/capi/cef_print_handler_capi.h (cef_print_job_callback_t)
  TOldCefPrintJobCallback = record
    base : TOldCefBase;
    cont : procedure(self: POldCefPrintJobCallback); stdcall;
  end;

  // /include/capi/cef_print_handler_capi.h (cef_print_handler_t)
  TOldCefPrintHandler = record
    base                : TOldCefBase;
    on_print_start      : procedure(self: POldCefPrintHandler; browser: POldCefBrowser); stdcall;
    on_print_settings   : procedure(self: POldCefPrintHandler; settings: POldCefPrintSettings; get_defaults: Integer); stdcall;
    on_print_dialog     : function(self: POldCefPrintHandler; has_selection: Integer; callback: POldCefPrintDialogCallback): Integer; stdcall;
    on_print_job        : function(self: POldCefPrintHandler; const document_name, pdf_file_path: POldCefString; callback: POldCefPrintJobCallback): Integer; stdcall;
    on_print_reset      : procedure(self: POldCefPrintHandler); stdcall;
    get_pdf_paper_size  : function(self: POldCefPrintHandler; device_units_per_inch: Integer): TOldCefSize; stdcall;
  end;

  // /include/capi/cef_drag_data_capi.h (cef_drag_data_t)
  TOldCefDragData = record
    base                  : TOldCefBase;
    clone                 : function(self: POldCefDragData): POldCefDragData; stdcall;
    is_read_only          : function(self: POldCefDragData): Integer; stdcall;
    is_link               : function(self: POldCefDragData): Integer; stdcall;
    is_fragment           : function(self: POldCefDragData): Integer; stdcall;
    is_file               : function(self: POldCefDragData): Integer; stdcall;
    get_link_url          : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_link_title        : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_link_metadata     : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_fragment_text     : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_fragment_html     : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_fragment_base_url : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_file_name         : function(self: POldCefDragData): POldCefStringUserFree; stdcall;
    get_file_contents     : function(self: POldCefDragData; writer: POldCefStreamWriter): NativeUInt; stdcall;
    get_file_names        : function(self: POldCefDragData; names: TOldCefStringList): Integer; stdcall;
    set_link_url          : procedure(self: POldCefDragData; const url: POldCefString); stdcall;
    set_link_title        : procedure(self: POldCefDragData; const title: POldCefString); stdcall;
    set_link_metadata     : procedure(self: POldCefDragData; const data: POldCefString); stdcall;
    set_fragment_text     : procedure(self: POldCefDragData; const text: POldCefString); stdcall;
    set_fragment_html     : procedure(self: POldCefDragData; const html: POldCefString); stdcall;
    set_fragment_base_url : procedure(self: POldCefDragData; const base_url: POldCefString); stdcall;
    reset_file_contents   : procedure(self: POldCefDragData); stdcall;
    add_file              : procedure(self: POldCefDragData; const path, display_name: POldCefString); stdcall;
  end;

  // /include/capi/cef_command_line_capi.h (cef_command_line_t)
  TOldCefCommandLine = record
    base                      : TOldCefBase;
    is_valid                  : function(self: POldCefCommandLine): Integer; stdcall;
    is_read_only              : function(self: POldCefCommandLine): Integer; stdcall;
    copy                      : function(self: POldCefCommandLine): POldCefCommandLine; stdcall;
    init_from_argv            : procedure(self: POldCefCommandLine; argc: Integer; const argv: PPAnsiChar); stdcall;
    init_from_string          : procedure(self: POldCefCommandLine; const command_line: POldCefString); stdcall;
    reset                     : procedure(self: POldCefCommandLine); stdcall;
    get_argv                  : procedure(self: POldCefCommandLine; argv: TOldCefStringList); stdcall;
    get_command_line_string   : function(self: POldCefCommandLine): POldCefStringUserFree; stdcall;
    get_program               : function(self: POldCefCommandLine): POldCefStringUserFree; stdcall;
    set_program               : procedure(self: POldCefCommandLine; const program_: POldCefString); stdcall;
    has_switches              : function(self: POldCefCommandLine): Integer; stdcall;
    has_switch                : function(self: POldCefCommandLine; const name: POldCefString): Integer; stdcall;
    get_switch_value          : function(self: POldCefCommandLine; const name: POldCefString): POldCefStringUserFree; stdcall;
    get_switches              : procedure(self: POldCefCommandLine; switches: TOldCefStringMap); stdcall;
    append_switch             : procedure(self: POldCefCommandLine; const name: POldCefString); stdcall;
    append_switch_with_value  : procedure(self: POldCefCommandLine; const name, value: POldCefString); stdcall;
    has_arguments             : function(self: POldCefCommandLine): Integer; stdcall;
    get_arguments             : procedure(self: POldCefCommandLine; arguments: TOldCefStringList); stdcall;
    append_argument           : procedure(self: POldCefCommandLine; const argument: POldCefString); stdcall;
    prepend_wrapper           : procedure(self: POldCefCommandLine; const wrapper: POldCefString); stdcall;
  end;

  // /include/capi/cef_scheme_capi.h (cef_scheme_registrar_t)
  TOldCefSchemeRegistrar = record
    base              : TOldCefBase;
    add_custom_scheme : function(self: POldCefSchemeRegistrar; const scheme_name: POldCefString; is_standard, is_local, is_display_isolated : Integer): Integer; stdcall;
  end;

  // /include/capi/cef_values_capi.h (cef_binary_value_t)
  TOldCefBinaryValue = record
    base      : TOldCefBase;
    is_valid  : function(self: POldCefBinaryValue): Integer; stdcall;
    is_owned  : function(self: POldCefBinaryValue): Integer; stdcall;
    is_same   : function(self, that: POldCefBinaryValue):Integer; stdcall;
    is_equal  : function(self, that: POldCefBinaryValue): Integer; stdcall;
    copy      : function(self: POldCefBinaryValue): POldCefBinaryValue; stdcall;
    get_size  : function(self: POldCefBinaryValue): NativeUInt; stdcall;
    get_data  : function(self: POldCefBinaryValue; buffer: Pointer; buffer_size, data_offset: NativeUInt): NativeUInt; stdcall;
  end;

  // /include/capi/cef_values_capi.h (cef_value_t)
  TOldCefValue = record
    base            : TOldCefBase;
    is_valid        : function(self: POldCefValue): Integer; stdcall;
    is_owned        : function(self: POldCefValue): Integer; stdcall;
    is_read_only    : function(self: POldCefValue): Integer; stdcall;
    is_same         : function(self, that: POldCefValue): Integer; stdcall;
    is_equal        : function(self, that: POldCefValue): Integer; stdcall;
    copy            : function(self: POldCefValue): POldCefValue; stdcall;
    get_type        : function(self: POldCefValue): TOldCefValueType; stdcall;
    get_bool        : function(self: POldCefValue): Integer; stdcall;
    get_int         : function(self: POldCefValue): Integer; stdcall;
    get_double      : function(self: POldCefValue): Double; stdcall;
    get_string      : function(self: POldCefValue): POldCefStringUserFree; stdcall;
    get_binary      : function(self: POldCefValue): POldCefBinaryValue; stdcall;
    get_dictionary  : function(self: POldCefValue): POldCefDictionaryValue; stdcall;
    get_list        : function(self: POldCefValue): POldCefListValue; stdcall;
    set_null        : function(self: POldCefValue): Integer; stdcall;
    set_bool        : function(self: POldCefValue; value: Integer): Integer; stdcall;
    set_int         : function(self: POldCefValue; value: Integer): Integer; stdcall;
    set_double      : function(self: POldCefValue; value: Double): Integer; stdcall;
    set_string      : function(self: POldCefValue; const value: POldCefString): Integer; stdcall;
    set_binary      : function(self: POldCefValue; value: POldCefBinaryValue): Integer; stdcall;
    set_dictionary  : function(self: POldCefValue; value: POldCefDictionaryValue): Integer; stdcall;
    set_list        : function(self: POldCefValue; value: POldCefListValue): Integer; stdcall;
  end;

  // /include/capi/cef_values_capi.h (cef_dictionary_value_t)
  TOldCefDictionaryValue = record
    base            : TOldCefBase;
    is_valid        : function(self: POldCefDictionaryValue): Integer; stdcall;
    is_owned        : function(self: POldCefDictionaryValue): Integer; stdcall;
    is_read_only    : function(self: POldCefDictionaryValue): Integer; stdcall;
    is_same         : function(self, that: POldCefDictionaryValue): Integer; stdcall;
    is_equal        : function(self, that: POldCefDictionaryValue): Integer; stdcall;
    copy            : function(self: POldCefDictionaryValue; exclude_empty_children: Integer): POldCefDictionaryValue; stdcall;
    get_size        : function(self: POldCefDictionaryValue): NativeUInt; stdcall;
    clear           : function(self: POldCefDictionaryValue): Integer; stdcall;
    has_key         : function(self: POldCefDictionaryValue; const key: POldCefString): Integer; stdcall;
    get_keys        : function(self: POldCefDictionaryValue; const keys: TOldCefStringList): Integer; stdcall;
    remove          : function(self: POldCefDictionaryValue; const key: POldCefString): Integer; stdcall;
    get_type        : function(self: POldCefDictionaryValue; const key: POldCefString): TOldCefValueType; stdcall;
    get_value       : function(self: POldCefDictionaryValue; const key: POldCefString): POldCefValue; stdcall;
    get_bool        : function(self: POldCefDictionaryValue; const key: POldCefString): Integer; stdcall;
    get_int         : function(self: POldCefDictionaryValue; const key: POldCefString): Integer; stdcall;
    get_double      : function(self: POldCefDictionaryValue; const key: POldCefString): Double; stdcall;
    get_string      : function(self: POldCefDictionaryValue; const key: POldCefString): POldCefStringUserFree; stdcall;
    get_binary      : function(self: POldCefDictionaryValue; const key: POldCefString): POldCefBinaryValue; stdcall;
    get_dictionary  : function(self: POldCefDictionaryValue; const key: POldCefString): POldCefDictionaryValue; stdcall;
    get_list        : function(self: POldCefDictionaryValue; const key: POldCefString): POldCefListValue; stdcall;
    set_value       : function(self: POldCefDictionaryValue; const key: POldCefString; value: POldCefValue): Integer; stdcall;
    set_null        : function(self: POldCefDictionaryValue; const key: POldCefString): Integer; stdcall;
    set_bool        : function(self: POldCefDictionaryValue; const key: POldCefString; value: Integer): Integer; stdcall;
    set_int         : function(self: POldCefDictionaryValue; const key: POldCefString; value: Integer): Integer; stdcall;
    set_double      : function(self: POldCefDictionaryValue; const key: POldCefString; value: Double): Integer; stdcall;
    set_string      : function(self: POldCefDictionaryValue; const key: POldCefString; value: POldCefString): Integer; stdcall;
    set_binary      : function(self: POldCefDictionaryValue; const key: POldCefString; value: POldCefBinaryValue): Integer; stdcall;
    set_dictionary  : function(self: POldCefDictionaryValue; const key: POldCefString; value: POldCefDictionaryValue): Integer; stdcall;
    set_list        : function(self: POldCefDictionaryValue; const key: POldCefString; value: POldCefListValue): Integer; stdcall;
  end;

  // /include/capi/cef_values_capi.h (cef_list_value_t)
  TOldCefListValue = record
    base            : TOldCefBase;
    is_valid        : function(self: POldCefListValue): Integer; stdcall;
    is_owned        : function(self: POldCefListValue): Integer; stdcall;
    is_read_only    : function(self: POldCefListValue): Integer; stdcall;
    is_same         : function(self, that: POldCefListValue): Integer; stdcall;
    is_equal        : function(self, that: POldCefListValue): Integer; stdcall;
    copy            : function(self: POldCefListValue): POldCefListValue; stdcall;
    set_size        : function(self: POldCefListValue; size: NativeUInt): Integer; stdcall;
    get_size        : function(self: POldCefListValue): NativeUInt; stdcall;
    clear           : function(self: POldCefListValue): Integer; stdcall;
    remove          : function(self: POldCefListValue; index: Integer): Integer; stdcall;
    get_type        : function(self: POldCefListValue; index: Integer): TOldCefValueType; stdcall;
    get_value       : function(self: POldCefListValue; index: Integer): POldCefValue; stdcall;
    get_bool        : function(self: POldCefListValue; index: Integer): Integer; stdcall;
    get_int         : function(self: POldCefListValue; index: Integer): Integer; stdcall;
    get_double      : function(self: POldCefListValue; index: Integer): Double; stdcall;
    get_string      : function(self: POldCefListValue; index: Integer): POldCefStringUserFree; stdcall;
    get_binary      : function(self: POldCefListValue; index: Integer): POldCefBinaryValue; stdcall;
    get_dictionary  : function(self: POldCefListValue; index: Integer): POldCefDictionaryValue; stdcall;
    get_list        : function(self: POldCefListValue; index: Integer): POldCefListValue; stdcall;
    set_value       : function(self: POldCefListValue; index: Integer; value: POldCefValue): Integer; stdcall;
    set_null        : function(self: POldCefListValue; index: Integer): Integer; stdcall;
    set_bool        : function(self: POldCefListValue; index: Integer; value: Integer): Integer; stdcall;
    set_int         : function(self: POldCefListValue; index: Integer; value: Integer): Integer; stdcall;
    set_double      : function(self: POldCefListValue; index: Integer; value: Double): Integer; stdcall;
    set_string      : function(self: POldCefListValue; index: Integer; value: POldCefString): Integer; stdcall;
    set_binary      : function(self: POldCefListValue; index: Integer; value: POldCefBinaryValue): Integer; stdcall;
    set_dictionary  : function(self: POldCefListValue; index: Integer; value: POldCefDictionaryValue): Integer; stdcall;
    set_list        : function(self: POldCefListValue; index: Integer; value: POldCefListValue): Integer; stdcall;
  end;

  // /include/capi/cef_string_visitor_capi.h (cef_string_visitor_t)
  TOldCefStringVisitor = record
    base  : TOldCefBase;
    visit : procedure(self: POldCefStringVisitor; const str: POldCefString); stdcall;
  end;

  TOldCefPostDataElementArray = array[0..(High(Integer) div SizeOf(POldCefPostDataElement)) - 1] of POldCefPostDataElement;

  // /include/capi/cef_request_capi.h (cef_post_data_element_t)
  TOldCefPostDataElement = record
    base            : TOldCefBase;
    is_read_only    : function(self: POldCefPostDataElement): Integer; stdcall;
    set_to_empty    : procedure(self: POldCefPostDataElement); stdcall;
    set_to_file     : procedure(self: POldCefPostDataElement; const fileName: POldCefString); stdcall;
    set_to_bytes    : procedure(self: POldCefPostDataElement; size: NativeUInt; const bytes: Pointer); stdcall;
    get_type        : function(self: POldCefPostDataElement): TOldCefPostDataElementType; stdcall;
    get_file        : function(self: POldCefPostDataElement): POldCefStringUserFree; stdcall;
    get_bytes_count : function(self: POldCefPostDataElement): NativeUInt; stdcall;
    get_bytes       : function(self: POldCefPostDataElement; size: NativeUInt; bytes: Pointer): NativeUInt; stdcall;
  end;

  // /include/capi/cef_request_capi.h (cef_post_data_t)
  TOldCefPostData = record
    base                  : TOldCefBase;
    is_read_only          : function(self: POldCefPostData):Integer; stdcall;
    has_excluded_elements : function(self: POldCefPostData): Integer; stdcall;
    get_element_count     : function(self: POldCefPostData): NativeUInt; stdcall;
    get_elements          : procedure(self: POldCefPostData; elementsCount: PNativeUInt; elements: POldCefPostDataElementArray); stdcall;
    remove_element        : function(self: POldCefPostData; element: POldCefPostDataElement): Integer; stdcall;
    add_element           : function(self: POldCefPostData; element: POldCefPostDataElement): Integer; stdcall;
    remove_elements       : procedure(self: POldCefPostData); stdcall;
  end;

  // /include/capi/cef_request_capi.h (cef_request_t)
  TOldCefRequest = record
    base                        : TOldCefBase;
    is_read_only                : function(self: POldCefRequest): Integer; stdcall;
    get_url                     : function(self: POldCefRequest): POldCefStringUserFree; stdcall;
    set_url                     : procedure(self: POldCefRequest; const url: POldCefString); stdcall;
    get_method                  : function(self: POldCefRequest): POldCefStringUserFree; stdcall;
    set_method                  : procedure(self: POldCefRequest; const method: POldCefString); stdcall;
    set_referrer                : procedure(self: POldCefRequest; const referrer_url: POldCefString; policy: TOldCefReferrerPolicy); stdcall;
    get_referrer_url            : function(self: POldCefRequest): POldCefStringUserFree; stdcall;
    get_referrer_policy         : function(self: POldCefRequest): TOldCefReferrerPolicy; stdcall;
    get_post_data               : function(self: POldCefRequest): POldCefPostData; stdcall;
    set_post_data               : procedure(self: POldCefRequest; postData: POldCefPostData); stdcall;
    get_header_map              : procedure(self: POldCefRequest; headerMap: TOldCefStringMultimap); stdcall;
    set_header_map              : procedure(self: POldCefRequest; headerMap: TOldCefStringMultimap); stdcall;
    set_                        : procedure(self: POldCefRequest; const url, method: POldCefString; postData: POldCefPostData; headerMap: TOldCefStringMultimap); stdcall;
    get_flags                   : function(self: POldCefRequest): Integer; stdcall;
    set_flags                   : procedure(self: POldCefRequest; flags: Integer); stdcall;
    get_first_party_for_cookies : function(self: POldCefRequest): POldCefStringUserFree; stdcall;
    set_first_party_for_cookies : procedure(self: POldCefRequest; const url: POldCefString); stdcall;
    get_resource_type           : function(self: POldCefRequest): TOldCefResourceType; stdcall;
    get_transition_type         : function(self: POldCefRequest): TOldCefTransitionType; stdcall;
    get_identifier              : function(self: POldCefRequest): UInt64; stdcall;
  end;

  // /include/capi/cef_task_capi.h (cef_task_t)
  TOldCefTask = record
    base    : TOldCefBase;
    execute : procedure(self: POldCefTask); stdcall;
  end;

  // /include/capi/cef_dom_capi.h (cef_domvisitor_t)
  TOldCefDomVisitor = record
    base  : TOldCefBase;
    visit : procedure(self: POldCefDomVisitor; document: POldCefDomDocument); stdcall;
  end;

  // /include/capi/cef_menu_model_capi.h (cef_menu_model_t)
  TOldCefMenuModel = record
    base                  : TOldCefBase;
    clear                 : function(self: POldCefMenuModel): Integer; stdcall;
    get_count             : function(self: POldCefMenuModel): Integer; stdcall;
    add_separator         : function(self: POldCefMenuModel): Integer; stdcall;
    add_item              : function(self: POldCefMenuModel; command_id: Integer; const text: POldCefString): Integer; stdcall;
    add_check_item        : function(self: POldCefMenuModel; command_id: Integer; const text: POldCefString): Integer; stdcall;
    add_radio_item        : function(self: POldCefMenuModel; command_id: Integer; const text: POldCefString; group_id: Integer): Integer; stdcall;
    add_sub_menu          : function(self: POldCefMenuModel; command_id: Integer; const text: POldCefString): POldCefMenuModel; stdcall;
    insert_separator_at   : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    insert_item_at        : function(self: POldCefMenuModel; index, command_id: Integer; const text: POldCefString): Integer; stdcall;
    insert_check_item_at  : function(self: POldCefMenuModel; index, command_id: Integer; const text: POldCefString): Integer; stdcall;
    insert_radio_item_at  : function(self: POldCefMenuModel; index, command_id: Integer; const text: POldCefString; group_id: Integer): Integer; stdcall;
    insert_sub_menu_at    : function(self: POldCefMenuModel; index, command_id: Integer; const text: POldCefString): POldCefMenuModel; stdcall;
    remove                : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    remove_at             : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    get_index_of          : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    get_command_id_at     : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    set_command_id_at     : function(self: POldCefMenuModel; index, command_id: Integer): Integer; stdcall;
    get_label             : function(self: POldCefMenuModel; command_id: Integer): POldCefStringUserFree; stdcall;
    get_label_at          : function(self: POldCefMenuModel; index: Integer): POldCefStringUserFree; stdcall;
    set_label             : function(self: POldCefMenuModel; command_id: Integer; const text: POldCefString): Integer; stdcall;
    set_label_at          : function(self: POldCefMenuModel; index: Integer; const text: POldCefString): Integer; stdcall;
    get_type              : function(self: POldCefMenuModel; command_id: Integer): TOldCefMenuItemType; stdcall;
    get_type_at           : function(self: POldCefMenuModel; index: Integer): TOldCefMenuItemType; stdcall;
    get_group_id          : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    get_group_id_at       : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    set_group_id          : function(self: POldCefMenuModel; command_id, group_id: Integer): Integer; stdcall;
    set_group_id_at       : function(self: POldCefMenuModel; index, group_id: Integer): Integer; stdcall;
    get_sub_menu          : function(self: POldCefMenuModel; command_id: Integer): POldCefMenuModel; stdcall;
    get_sub_menu_at       : function(self: POldCefMenuModel; index: Integer): POldCefMenuModel; stdcall;
    is_visible            : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    is_visible_at         : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    set_visible           : function(self: POldCefMenuModel; command_id, visible: Integer): Integer; stdcall;
    set_visible_at        : function(self: POldCefMenuModel; index, visible: Integer): Integer; stdcall;
    is_enabled            : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    is_enabled_at         : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    set_enabled           : function(self: POldCefMenuModel; command_id, enabled: Integer): Integer; stdcall;
    set_enabled_at        : function(self: POldCefMenuModel; index, enabled: Integer): Integer; stdcall;
    is_checked            : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    is_checked_at         : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    set_checked           : function(self: POldCefMenuModel; command_id, checked: Integer): Integer; stdcall;
    set_checked_at        : function(self: POldCefMenuModel; index, checked: Integer): Integer; stdcall;
    has_accelerator       : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    has_accelerator_at    : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    set_accelerator       : function(self: POldCefMenuModel; command_id, key_code, shift_pressed, ctrl_pressed, alt_pressed: Integer): Integer; stdcall;
    set_accelerator_at    : function(self: POldCefMenuModel; index, key_code, shift_pressed, ctrl_pressed, alt_pressed: Integer): Integer; stdcall;
    remove_accelerator    : function(self: POldCefMenuModel; command_id: Integer): Integer; stdcall;
    remove_accelerator_at : function(self: POldCefMenuModel; index: Integer): Integer; stdcall;
    get_accelerator       : function(self: POldCefMenuModel; command_id: Integer; key_code, shift_pressed, ctrl_pressed, alt_pressed: PInteger): Integer; stdcall;
    get_accelerator_at    : function(self: POldCefMenuModel; index: Integer; key_code, shift_pressed, ctrl_pressed, alt_pressed: PInteger): Integer; stdcall;
  end;

  // /include/capi/cef_context_menu_handler_capi.h (cef_context_menu_params_t)
  TOldCefContextMenuParams = record
    base                        : TOldCefBase;
    get_xcoord                  : function(self: POldCefContextMenuParams): Integer; stdcall;
    get_ycoord                  : function(self: POldCefContextMenuParams): Integer; stdcall;
    get_type_flags              : function(self: POldCefContextMenuParams): TOldCefContextMenuTypeFlags; stdcall;
    get_link_url                : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_unfiltered_link_url     : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_source_url              : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    has_image_contents          : function(self: POldCefContextMenuParams): Integer; stdcall;
    get_page_url                : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_frame_url               : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_frame_charset           : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_media_type              : function(self: POldCefContextMenuParams): TOldCefContextMenuMediaType; stdcall;
    get_media_state_flags       : function(self: POldCefContextMenuParams): TOldCefContextMenuMediaStateFlags; stdcall;
    get_selection_text          : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_misspelled_word         : function(self: POldCefContextMenuParams): POldCefStringUserFree; stdcall;
    get_dictionary_suggestions  : function(self: POldCefContextMenuParams; suggestions: TOldCefStringList): Integer; stdcall;
    is_editable                 : function(self: POldCefContextMenuParams): Integer; stdcall;
    is_spell_check_enabled      : function(self: POldCefContextMenuParams): Integer; stdcall;
    get_edit_state_flags        : function(self: POldCefContextMenuParams): TOldCefContextMenuEditStateFlags; stdcall;
    is_custom_menu              : function(self: POldCefContextMenuParams): Integer; stdcall;
    is_pepper_menu              : function(self: POldCefContextMenuParams): Integer; stdcall;
  end;

  // /include/capi/cef_download_item_capi.h (cef_download_item_t)
  TOldCefDownloadItem = record
    base                    : TOldCefBase;
    is_valid                : function(self: POldCefDownloadItem): Integer; stdcall;
    is_in_progress          : function(self: POldCefDownloadItem): Integer; stdcall;
    is_complete             : function(self: POldCefDownloadItem): Integer; stdcall;
    is_canceled             : function(self: POldCefDownloadItem): Integer; stdcall;
    get_current_speed       : function(self: POldCefDownloadItem): Int64; stdcall;
    get_percent_complete    : function(self: POldCefDownloadItem): Integer; stdcall;
    get_total_bytes         : function(self: POldCefDownloadItem): Int64; stdcall;
    get_received_bytes      : function(self: POldCefDownloadItem): Int64; stdcall;
    get_start_time          : function(self: POldCefDownloadItem): TOldCefTime; stdcall;
    get_end_time            : function(self: POldCefDownloadItem): TOldCefTime; stdcall;
    get_full_path           : function(self: POldCefDownloadItem): POldCefStringUserFree; stdcall;
    get_id                  : function(self: POldCefDownloadItem): Cardinal; stdcall;
    get_url                 : function(self: POldCefDownloadItem): POldCefStringUserFree; stdcall;
    get_original_url        : function(self: POldCefDownloadItem): POldCefStringUserFree; stdcall;
    get_suggested_file_name : function(self: POldCefDownloadItem): POldCefStringUserFree; stdcall;
    get_content_disposition : function(self: POldCefDownloadItem): POldCefStringUserFree; stdcall;
    get_mime_type           : function(self: POldCefDownloadItem): POldCefStringUserFree; stdcall;
  end;

  // /include/capi/cef_download_handler_capi.h (cef_before_download_callback_t)
  TOldCefBeforeDownloadCallback = record
    base : TOldCefBase;
    cont : procedure(self: POldCefBeforeDownloadCallback; const download_path: POldCefString; show_dialog: Integer); stdcall;
  end;

  // /include/capi/cef_download_handler_capi.h (cef_download_item_callback_t)
  TOldCefDownloadItemCallback = record
    base   : TOldCefBase;
    cancel : procedure(self: POldCefDownloadItemCallback); stdcall;
    pause  : procedure(self: POldCefDownloadItemCallback); stdcall;
    resume : procedure(self: POldCefDownloadItemCallback); stdcall;
  end;

  // /include/capi/cef_dom_capi.h (cef_domnode_t)
  TOldCefDomNode = record
    base                          : TOldCefBase;
    get_type                      : function(self: POldCefDomNode): TOldCefDomNodeType; stdcall;
    is_text                       : function(self: POldCefDomNode): Integer; stdcall;
    is_element                    : function(self: POldCefDomNode): Integer; stdcall;
    is_editable                   : function(self: POldCefDomNode): Integer; stdcall;
    is_form_control_element       : function(self: POldCefDomNode): Integer; stdcall;
    get_form_control_element_type : function(self: POldCefDomNode): POldCefStringUserFree; stdcall;
    is_same                       : function(self, that: POldCefDomNode): Integer; stdcall;
    get_name                      : function(self: POldCefDomNode): POldCefStringUserFree; stdcall;
    get_value                     : function(self: POldCefDomNode): POldCefStringUserFree; stdcall;
    set_value                     : function(self: POldCefDomNode; const value: POldCefString): Integer; stdcall;
    get_as_markup                 : function(self: POldCefDomNode): POldCefStringUserFree; stdcall;
    get_document                  : function(self: POldCefDomNode): POldCefDomDocument; stdcall;
    get_parent                    : function(self: POldCefDomNode): POldCefDomNode; stdcall;
    get_previous_sibling          : function(self: POldCefDomNode): POldCefDomNode; stdcall;
    get_next_sibling              : function(self: POldCefDomNode): POldCefDomNode; stdcall;
    has_children                  : function(self: POldCefDomNode): Integer; stdcall;
    get_first_child               : function(self: POldCefDomNode): POldCefDomNode; stdcall;
    get_last_child                : function(self: POldCefDomNode): POldCefDomNode; stdcall;
    get_element_tag_name          : function(self: POldCefDomNode): POldCefStringUserFree; stdcall;
    has_element_attributes        : function(self: POldCefDomNode): Integer; stdcall;
    has_element_attribute         : function(self: POldCefDomNode; const attrName: POldCefString): Integer; stdcall;
    get_element_attribute         : function(self: POldCefDomNode; const attrName: POldCefString): POldCefStringUserFree; stdcall;
    get_element_attributes        : procedure(self: POldCefDomNode; attrMap: TOldCefStringMap); stdcall;
    set_element_attribute         : function(self: POldCefDomNode; const attrName, value: POldCefString): Integer; stdcall;
    get_element_inner_text        : function(self: POldCefDomNode): POldCefStringUserFree; stdcall;
  end;

  // /include/capi/cef_dom_capi.h (cef_domdocument_t)
  TOldCefDomDocument = record
    base                        : TOldCefBase;
    get_type                    : function(self: POldCefDomDocument): TOldCefDomDocumentType; stdcall;
    get_document                : function(self: POldCefDomDocument): POldCefDomNode; stdcall;
    get_body                    : function(self: POldCefDomDocument): POldCefDomNode; stdcall;
    get_head                    : function(self: POldCefDomDocument): POldCefDomNode; stdcall;
    get_title                   : function(self: POldCefDomDocument): POldCefStringUserFree; stdcall;
    get_element_by_id           : function(self: POldCefDomDocument; const id: POldCefString): POldCefDomNode; stdcall;
    get_focused_node            : function(self: POldCefDomDocument): POldCefDomNode; stdcall;
    has_selection               : function(self: POldCefDomDocument): Integer; stdcall;
    get_selection_start_offset  : function(self: POldCefDomDocument): Integer; stdcall;
    get_selection_end_offset    : function(self: POldCefDomDocument): Integer; stdcall;
    get_selection_as_markup     : function(self: POldCefDomDocument): POldCefStringUserFree; stdcall;
    get_selection_as_text       : function(self: POldCefDomDocument): POldCefStringUserFree; stdcall;
    get_base_url                : function(self: POldCefDomDocument): POldCefStringUserFree; stdcall;
    get_complete_url            : function(self: POldCefDomDocument; const partialURL: POldCefString): POldCefStringUserFree; stdcall;
  end;

  POldCefV8ValueArray = array[0..(High(Integer) div SizeOf(Pointer)) - 1] of POldCefV8Value;

  // /include/capi/cef_v8_capi.h (cef_v8handler_t)
  TOldCefv8Handler = record
    base    : TOldCefBase;
    execute : function(self: POldCefv8Handler; const name: POldCefString; obj: POldCefv8Value; argumentsCount: NativeUInt; const arguments: PPOldCefV8Value; var retval: POldCefV8Value; var exception: TOldCefString): Integer; stdcall;
  end;

  // /include/capi/cef_v8_capi.h (cef_v8exception_t)
  TOldCefV8Exception = record
    base                      : TOldCefBase;
    get_message               : function(self: POldCefV8Exception): POldCefStringUserFree; stdcall;
    get_source_line           : function(self: POldCefV8Exception): POldCefStringUserFree; stdcall;
    get_script_resource_name  : function(self: POldCefV8Exception): POldCefStringUserFree; stdcall;
    get_line_number           : function(self: POldCefV8Exception): Integer; stdcall;
    get_start_position        : function(self: POldCefV8Exception): Integer; stdcall;
    get_end_position          : function(self: POldCefV8Exception): Integer; stdcall;
    get_start_column          : function(self: POldCefV8Exception): Integer; stdcall;
    get_end_column            : function(self: POldCefV8Exception): Integer; stdcall;
  end;

  // /include/capi/cef_v8_capi.h (cef_v8value_t)
  TOldCefv8Value = record
    base                                : TOldCefBase;
    is_valid                            : function(self: POldCefv8Value): Integer; stdcall;
    is_undefined                        : function(self: POldCefv8Value): Integer; stdcall;
    is_null                             : function(self: POldCefv8Value): Integer; stdcall;
    is_bool                             : function(self: POldCefv8Value): Integer; stdcall;
    is_int                              : function(self: POldCefv8Value): Integer; stdcall;
    is_uint                             : function(self: POldCefv8Value): Integer; stdcall;
    is_double                           : function(self: POldCefv8Value): Integer; stdcall;
    is_date                             : function(self: POldCefv8Value): Integer; stdcall;
    is_string                           : function(self: POldCefv8Value): Integer; stdcall;
    is_object                           : function(self: POldCefv8Value): Integer; stdcall;
    is_array                            : function(self: POldCefv8Value): Integer; stdcall;
    is_function                         : function(self: POldCefv8Value): Integer; stdcall;
    is_same                             : function(self, that: POldCefv8Value): Integer; stdcall;
    get_bool_value                      : function(self: POldCefv8Value): Integer; stdcall;
    get_int_value                       : function(self: POldCefv8Value): Integer; stdcall;
    get_uint_value                      : function(self: POldCefv8Value): Cardinal; stdcall;
    get_double_value                    : function(self: POldCefv8Value): Double; stdcall;
    get_date_value                      : function(self: POldCefv8Value): TOldCefTime; stdcall;
    get_string_value                    : function(self: POldCefv8Value): POldCefStringUserFree; stdcall;
    is_user_created                     : function(self: POldCefv8Value): Integer; stdcall;
    has_exception                       : function(self: POldCefv8Value): Integer; stdcall;
    get_exception                       : function(self: POldCefv8Value): POldCefV8Exception; stdcall;
    clear_exception                     : function(self: POldCefv8Value): Integer; stdcall;
    will_rethrow_exceptions             : function(self: POldCefv8Value): Integer; stdcall;
    set_rethrow_exceptions              : function(self: POldCefv8Value; rethrow: Integer): Integer; stdcall;
    has_value_bykey                     : function(self: POldCefv8Value; const key: POldCefString): Integer; stdcall;
    has_value_byindex                   : function(self: POldCefv8Value; index: Integer): Integer; stdcall;
    delete_value_bykey                  : function(self: POldCefv8Value; const key: POldCefString): Integer; stdcall;
    delete_value_byindex                : function(self: POldCefv8Value; index: Integer): Integer; stdcall;
    get_value_bykey                     : function(self: POldCefv8Value; const key: POldCefString): POldCefv8Value; stdcall;
    get_value_byindex                   : function(self: POldCefv8Value; index: Integer): POldCefv8Value; stdcall;
    set_value_bykey                     : function(self: POldCefv8Value; const key: POldCefString; value: POldCefv8Value; attribute: TOldCefV8PropertyAttributes): Integer; stdcall;
    set_value_byindex                   : function(self: POldCefv8Value; index: Integer; value: POldCefv8Value): Integer; stdcall;
    set_value_byaccessor                : function(self: POldCefv8Value; const key: POldCefString; settings: Integer; attribute: TOldCefV8PropertyAttributes): Integer; stdcall;
    get_keys                            : function(self: POldCefv8Value; keys: TOldCefStringList): Integer; stdcall;
    set_user_data                       : function(self: POldCefv8Value; user_data: POldCefBase): Integer; stdcall;
    get_user_data                       : function(self: POldCefv8Value): POldCefBase; stdcall;
    get_externally_allocated_memory     : function(self: POldCefv8Value): Integer; stdcall;
    adjust_externally_allocated_memory  : function(self: POldCefv8Value; change_in_bytes: Integer): Integer; stdcall;
    get_array_length                    : function(self: POldCefv8Value): Integer; stdcall;
    get_function_name                   : function(self: POldCefv8Value): POldCefStringUserFree; stdcall;
    get_function_handler                : function(self: POldCefv8Value): POldCefv8Handler; stdcall;
    execute_function                    : function(self: POldCefv8Value; obj: POldCefv8Value; argumentsCount: NativeUInt; const arguments: PPOldCefV8Value): POldCefv8Value; stdcall;
    execute_function_with_context       : function(self: POldCefv8Value; context: POldCefv8Context; obj: POldCefv8Value; argumentsCount: NativeUInt; const arguments: PPOldCefV8Value): POldCefv8Value; stdcall;
  end;

  // /include/capi/cef_v8_capi.h (cef_v8context_t)
  TOldCefV8Context = record
    base            : TOldCefBase;
    get_task_runner : function(self: POldCefv8Context): POldCefTaskRunner; stdcall;
    is_valid        : function(self: POldCefv8Context): Integer; stdcall;
    get_browser     : function(self: POldCefv8Context): POldCefBrowser; stdcall;
    get_frame       : function(self: POldCefv8Context): POldCefFrame; stdcall;
    get_global      : function(self: POldCefv8Context): POldCefv8Value; stdcall;
    enter           : function(self: POldCefv8Context): Integer; stdcall;
    exit            : function(self: POldCefv8Context): Integer; stdcall;
    is_same         : function(self, that: POldCefv8Context): Integer; stdcall;
    eval            : function(self: POldCefv8Context; const code: POldCefString; var retval: POldCefv8Value; var exception: POldCefV8Exception): Integer; stdcall;
  end;

  // /include/capi/cef_v8_capi.h (cef_v8accessor_t)
  TOldCefV8Accessor = record
    base : TOldCefBase;
    get  : function(self: POldCefV8Accessor; const name: POldCefString; obj: POldCefv8Value; out retval: POldCefv8Value; exception: POldCefString): Integer; stdcall;
    put  : function(self: POldCefV8Accessor; const name: POldCefString; obj, value: POldCefv8Value; exception: POldCefString): Integer; stdcall;
  end;

  // /include/capi/cef_frame_capi.h (cef_frame_t)
  TOldCefFrame = record
    base                : TOldCefBase;
    is_valid            : function(self: POldCefFrame): Integer; stdcall;
    undo                : procedure(self: POldCefFrame); stdcall;
    redo                : procedure(self: POldCefFrame); stdcall;
    cut                 : procedure(self: POldCefFrame); stdcall;
    copy                : procedure(self: POldCefFrame); stdcall;
    paste               : procedure(self: POldCefFrame); stdcall;
    del                 : procedure(self: POldCefFrame); stdcall;
    select_all          : procedure(self: POldCefFrame); stdcall;
    view_source         : procedure(self: POldCefFrame); stdcall;
    get_source          : procedure(self: POldCefFrame; visitor: POldCefStringVisitor); stdcall;
    get_text            : procedure(self: POldCefFrame; visitor: POldCefStringVisitor); stdcall;
    load_request        : procedure(self: POldCefFrame; request: POldCefRequest); stdcall;
    load_url            : procedure(self: POldCefFrame; const url: POldCefString); stdcall;
    load_string         : procedure(self: POldCefFrame; const stringVal, url: POldCefString); stdcall;
    execute_java_script : procedure(self: POldCefFrame; const code, script_url: POldCefString; start_line: Integer); stdcall;
    is_main             : function(self: POldCefFrame): Integer; stdcall;
    is_focused          : function(self: POldCefFrame): Integer; stdcall;
    get_name            : function(self: POldCefFrame): POldCefStringUserFree; stdcall;
    get_identifier      : function(self: POldCefFrame): Int64; stdcall;
    get_parent          : function(self: POldCefFrame): POldCefFrame; stdcall;
    get_url             : function(self: POldCefFrame): POldCefStringUserFree; stdcall;
    get_browser         : function(self: POldCefFrame): POldCefBrowser; stdcall;
    get_v8context       : function(self: POldCefFrame): POldCefv8Context; stdcall;
    visit_dom           : procedure(self: POldCefFrame; visitor: POldCefDomVisitor); stdcall;
  end;

  // /include/capi/cef_accessibility_handler_capi.h (cef_accessibility_handler_t)
  TOldCefAccessibilityHandler = record
    base                             : TOldCefBase;
    on_accessibility_tree_change     : procedure(self: POldCefAccessibilityHandler; value: POldCefValue); stdcall;
    on_accessibility_location_change : procedure(self: POldCefAccessibilityHandler; value: POldCefValue); stdcall;
  end;

  // /include/capi/cef_context_menu_handler_capi.h (cef_context_menu_handler_t)
  TOldCefContextMenuHandler = record
    base                      : TOldCefBase;
    on_before_context_menu    : procedure(self: POldCefContextMenuHandler; browser: POldCefBrowser; frame: POldCefFrame; params: POldCefContextMenuParams; model: POldCefMenuModel); stdcall;
    run_context_menu          : function(self: POldCefContextMenuHandler; browser: POldCefBrowser; frame: POldCefFrame; params: POldCefContextMenuParams; model: POldCefMenuModel; callback: POldCefRunContextMenuCallback): Integer; stdcall;
    on_context_menu_command   : function(self: POldCefContextMenuHandler; browser: POldCefBrowser; frame: POldCefFrame; params: POldCefContextMenuParams; command_id: Integer; event_flags: TOldCefEventFlags): Integer; stdcall;
    on_context_menu_dismissed : procedure(self: POldCefContextMenuHandler; browser: POldCefBrowser; frame: POldCefFrame); stdcall;
  end;

  // /include/capi/cef_client_capi.h (cef_client_t)
  TOldCefClient = record
    base                        : TOldCefBase;
    get_context_menu_handler    : function(self: POldCefClient): POldCefContextMenuHandler; stdcall;
    get_dialog_handler          : function(self: POldCefClient): POldCefDialogHandler; stdcall;
    get_display_handler         : function(self: POldCefClient): POldCefDisplayHandler; stdcall;
    get_download_handler        : function(self: POldCefClient): POldCefDownloadHandler; stdcall;
    get_drag_handler            : function(self: POldCefClient): POldCefDragHandler; stdcall;
    get_find_handler            : function(self: POldCefClient): POldCefFindHandler; stdcall;
    get_focus_handler           : function(self: POldCefClient): POldCefFocusHandler; stdcall;
    get_geolocation_handler     : function(self: POldCefClient): POldCefGeolocationHandler; stdcall;
    get_jsdialog_handler        : function(self: POldCefClient): POldCefJsDialogHandler; stdcall;
    get_keyboard_handler        : function(self: POldCefClient): POldCefKeyboardHandler; stdcall;
    get_life_span_handler       : function(self: POldCefClient): POldCefLifeSpanHandler; stdcall;
    get_load_handler            : function(self: POldCefClient): POldCefLoadHandler; stdcall;
    get_render_handler          : function(self: POldCefClient): POldCefRenderHandler; stdcall;
    get_request_handler         : function(self: POldCefClient): POldCefRequestHandler; stdcall;
    on_process_message_received : function(self: POldCefClient; browser: POldCefBrowser; source_process: TOldCefProcessId; message: POldCefProcessMessage): Integer; stdcall;
  end;

  // /include/capi/cef_browser_capi.h (cef_browser_host_t)
  TOldCefBrowserHost = record
    base                              : TOldCefBase;
    get_browser                       : function(self: POldCefBrowserHost): POldCefBrowser; stdcall;
    close_browser                     : procedure(self: POldCefBrowserHost; force_close: Integer); stdcall;
    set_focus                         : procedure(self: POldCefBrowserHost; focus: Integer); stdcall;
    set_window_visibility             : procedure(self: POldCefBrowserHost; visible: Integer); stdcall;
    get_window_handle                 : function(self: POldCefBrowserHost): TOldCefWindowHandle; stdcall;
    get_opener_window_handle          : function(self: POldCefBrowserHost): TOldCefWindowHandle; stdcall;
    get_client                        : function(self: POldCefBrowserHost): POldCefClient; stdcall;
    get_request_context               : function(self: POldCefBrowserHost): POldCefRequestContext; stdcall;
    get_zoom_level                    : function(self: POldCefBrowserHost): Double; stdcall;
    set_zoom_level                    : procedure(self: POldCefBrowserHost; zoomLevel: Double); stdcall;
    run_file_dialog                   : procedure(self: POldCefBrowserHost; mode: TOldCefFileDialogMode; const title, default_file_path: POldCefString; accept_filters: TOldCefStringList; selected_accept_filter: Integer; callback: POldCefRunFileDialogCallback); stdcall;
    start_download                    : procedure(self: POldCefBrowserHost; const url: POldCefString); stdcall;
    print                             : procedure(self: POldCefBrowserHost); stdcall;
    print_to_pdf                      : procedure(self: POldCefBrowserHost; const path: POldCefString; const settings: POldCefPdfPrintSettings; callback: POldCefPdfPrintCallback); stdcall;
    find                              : procedure(self: POldCefBrowserHost; identifier: Integer; const searchText: POldCefString; forward, matchCase, findNext: Integer); stdcall;
    stop_finding                      : procedure(self: POldCefBrowserHost; clearSelection: Integer); stdcall;
    show_dev_tools                    : procedure(self: POldCefBrowserHost; const windowInfo: POldCefWindowInfo; client: POldCefClient; const settings: POldCefBrowserSettings; const inspect_element_at: POldCefPoint); stdcall;
    close_dev_tools                   : procedure(self: POldCefBrowserHost); stdcall;
    get_navigation_entries            : procedure(self: POldCefBrowserHost; visitor: POldCefNavigationEntryVisitor; current_only: Integer); stdcall;
    set_mouse_cursor_change_disabled  : procedure(self: POldCefBrowserHost; disabled: Integer); stdcall;
    is_mouse_cursor_change_disabled   : function(self: POldCefBrowserHost): Integer; stdcall;
    replace_misspelling               : procedure(self: POldCefBrowserHost; const word: POldCefString); stdcall;
    add_word_to_dictionary            : procedure(self: POldCefBrowserHost; const word: POldCefString); stdcall;
    is_window_rendering_disabled      : function(self: POldCefBrowserHost): Integer; stdcall;
    was_resized                       : procedure(self: POldCefBrowserHost); stdcall;
    was_hidden                        : procedure(self: POldCefBrowserHost; hidden: Integer); stdcall;
    notify_screen_info_changed        : procedure(self: POldCefBrowserHost); stdcall;
    invalidate                        : procedure(self: POldCefBrowserHost; kind: TOldCefPaintElementType); stdcall;
    send_key_event                    : procedure(self: POldCefBrowserHost; const event: POldCefKeyEvent); stdcall;
    send_mouse_click_event            : procedure(self: POldCefBrowserHost; const event: POldCefMouseEvent; kind: TOldCefMouseButtonType; mouseUp, clickCount: Integer); stdcall;
    send_mouse_move_event             : procedure(self: POldCefBrowserHost; const event: POldCefMouseEvent; mouseLeave: Integer); stdcall;
    send_mouse_wheel_event            : procedure(self: POldCefBrowserHost; const event: POldCefMouseEvent; deltaX, deltaY: Integer); stdcall;
    send_focus_event                  : procedure(self: POldCefBrowserHost; setFocus: Integer); stdcall;
    send_capture_lost_event           : procedure(self: POldCefBrowserHost); stdcall;
    notify_move_or_resize_started     : procedure(self: POldCefBrowserHost); stdcall;
    get_windowless_frame_rate         : function(self: POldCefBrowserHost): Integer; stdcall;
    set_windowless_frame_rate         : procedure(self: POldCefBrowserHost; frame_rate: Integer); stdcall;
    get_nstext_input_context                  : function(self: POldCefBrowserHost): TOldCefTextInputContext; stdcall;
    handle_key_event_before_text_input_client : procedure(self: POldCefBrowserHost; keyEvent: TOldCefEventHandle); stdcall;
    handle_key_event_after_text_input_client  : procedure(self: POldCefBrowserHost; keyEvent: TOldCefEventHandle); stdcall;
    drag_target_drag_enter            : procedure(self: POldCefBrowserHost; drag_data: POldCefDragData; const event: POldCefMouseEvent; allowed_ops: TOldCefDragOperations); stdcall;
    drag_target_drag_over             : procedure(self: POldCefBrowserHost; const event: POldCefMouseEvent; allowed_ops: TOldCefDragOperations); stdcall;
    drag_target_drag_leave            : procedure(self: POldCefBrowserHost); stdcall;
    drag_target_drop                  : procedure(self: POldCefBrowserHost; event: POldCefMouseEvent); stdcall;
    drag_source_ended_at              : procedure(self: POldCefBrowserHost; x, y: Integer; op: TOldCefDragOperation); stdcall;
    drag_source_system_drag_ended     : procedure(self: POldCefBrowserHost); stdcall;
  end;

  // /include/capi/cef_browser_capi.h (cef_browser_t)
  TOldCefBrowser = record
    base                  : TOldCefBase;
    get_host              : function(self: POldCefBrowser): POldCefBrowserHost; stdcall;
    can_go_back           : function(self: POldCefBrowser): Integer; stdcall;
    go_back               : procedure(self: POldCefBrowser); stdcall;
    can_go_forward        : function(self: POldCefBrowser): Integer; stdcall;
    go_forward            : procedure(self: POldCefBrowser); stdcall;
    is_loading            : function(self: POldCefBrowser): Integer; stdcall;
    reload                : procedure(self: POldCefBrowser); stdcall;
    reload_ignore_cache   : procedure(self: POldCefBrowser); stdcall;
    stop_load             : procedure(self: POldCefBrowser); stdcall;
    get_identifier        : function(self: POldCefBrowser): Integer; stdcall;
    is_same               : function(self, that: POldCefBrowser): Integer; stdcall;
    is_popup              : function(self: POldCefBrowser): Integer; stdcall;
    has_document          : function(self: POldCefBrowser): Integer; stdcall;
    get_main_frame        : function(self: POldCefBrowser): POldCefFrame; stdcall;
    get_focused_frame     : function(self: POldCefBrowser): POldCefFrame; stdcall;
    get_frame_byident     : function(self: POldCefBrowser; identifier: Int64): POldCefFrame; stdcall;
    get_frame             : function(self: POldCefBrowser; const name: POldCefString): POldCefFrame; stdcall;
    get_frame_count       : function(self: POldCefBrowser): NativeUInt; stdcall;
    get_frame_identifiers : procedure(self: POldCefBrowser; var identifiersCount: NativeUInt; var identifiers: Int64); stdcall;
    get_frame_names       : procedure(self: POldCefBrowser; names: TOldCefStringList); stdcall;
    send_process_message  : function(self: POldCefBrowser; target_process: TOldCefProcessId; message: POldCefProcessMessage): Integer; stdcall;
  end;

  // /include/capi/cef_resource_bundle_handler_capi.h (cef_resource_bundle_handler_t)
  TOldCefResourceBundleHandler = record
    base                        : TOldCefBase;
    get_localized_string        : function(self: POldCefResourceBundleHandler; string_id: Integer; string_val: POldCefString): Integer; stdcall;
    get_data_resource           : function(self: POldCefResourceBundleHandler; resource_id: Integer; var data: Pointer; var data_size: NativeUInt): Integer; stdcall;
    get_data_resource_for_scale : function(self: POldCefResourceBundleHandler; resource_id: Integer; scale_factor: TOldCefScaleFactor; var data: Pointer; var data_size: NativeUInt): Integer; stdcall;
  end;

  // /include/capi/cef_browser_process_handler_capi.h (cef_browser_process_handler_t)
  TOldCefBrowserProcessHandler = record
    base                              : TOldCefBase;
    on_context_initialized            : procedure(self: POldCefBrowserProcessHandler); stdcall;
    on_before_child_process_launch    : procedure(self: POldCefBrowserProcessHandler; command_line: POldCefCommandLine); stdcall;
    on_render_process_thread_created  : procedure(self: POldCefBrowserProcessHandler; extra_info: POldCefListValue); stdcall;
    get_print_handler                 : function(self: POldCefBrowserProcessHandler): POldCefPrintHandler; stdcall;
    //on_schedule_message_pump_work     : procedure(self: POldCefBrowserProcessHandler; delay_ms: Int64); stdcall;
  end;

  // /include/capi/cef_app_capi.h (cef_app_t)
  TOldCefApp = record
    base                              : TOldCefBase;
    on_before_command_line_processing : procedure(self: POldCefApp; const process_type: POldCefString; command_line: POldCefCommandLine); stdcall;
    on_register_custom_schemes        : procedure(self: POldCefApp; registrar: POldCefSchemeRegistrar); stdcall;
    get_resource_bundle_handler       : function(self: POldCefApp): POldCefResourceBundleHandler; stdcall;
    get_browser_process_handler       : function(self: POldCefApp): POldCefBrowserProcessHandler; stdcall;
    get_render_process_handler        : function(self: POldCefApp): POldCefRenderProcessHandler; stdcall;
  end;

  {$IFDEF MSWINDOWS}
  TMyOldMemoryStatusEx = record
     dwLength : DWORD;
     dwMemoryLoad : DWORD;
     ullTotalPhys : uint64;
     ullAvailPhys : uint64;
     ullTotalPageFile : uint64;
     ullAvailPageFile : uint64;
     ullTotalVirtual : uint64;
     ullAvailVirtual : uint64;
     ullAvailExtendedVirtual : uint64;
  end;
  {$ENDIF}

implementation

end.
