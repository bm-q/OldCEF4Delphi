// ************************************************************************
// ***************************** OldCEF4Delphi *******************************
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

unit oldCEFResponseFilter;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOnFilterEvent     = procedure(Sender: TObject; data_in: Pointer; data_in_size: NativeUInt; var data_in_read: NativeUInt; data_out: Pointer; data_out_size : NativeUInt; var data_out_written: NativeUInt; var aResult : TOldCefResponseFilterStatus) of object;
  TOnInitFilterEvent = procedure(Sender: TObject; var aResult : boolean) of object;


  TOldCefResponseFilterOwn = class(TOldCefBaseOwn, IOldCefResponseFilter)
    protected
      function InitFilter: Boolean; virtual; abstract;
      function Filter(data_in: Pointer; data_in_size: NativeUInt; var data_in_read: NativeUInt; data_out: Pointer; data_out_size : NativeUInt; var data_out_written: NativeUInt): TOldCefResponseFilterStatus; virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCustomResponseFilter = class(TOldCefResponseFilterOwn)
    protected
      FOnFilter     : TOnFilterEvent;
      FOnInitFilter : TOnInitFilterEvent;

      function InitFilter: Boolean; override;
      function Filter(data_in: Pointer; data_in_size: NativeUInt; var data_in_read: NativeUInt; data_out: Pointer; data_out_size : NativeUInt; var data_out_written: NativeUInt): TOldCefResponseFilterStatus; override;

    public
      constructor Create; override;

      property OnFilter      : TOnFilterEvent      read FOnFilter      write FOnFilter;
      property OnInitFilter  : TOnInitFilterEvent  read FOnInitFilter  write FOnInitFilter;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

// TOldCefResponseFilterOwn

function cef_response_filter_init_filter(self: POldCefResponseFilter): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(True);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResponseFilterOwn) then
    Result := Ord(TOldCefResponseFilterOwn(TempObject).InitFilter());
end;

function cef_response_filter_filter(    self             : POldCefResponseFilter;
                                        data_in          : Pointer;
                                        data_in_size     : NativeUInt;
                                    var data_in_read     : NativeUInt;
                                        data_out         : Pointer;
                                        data_out_size    : NativeUInt;
                                    var data_out_written : NativeUInt): TOldCefResponseFilterStatus; stdcall;
var
  TempObject : TObject;
begin
  Result     := RESPONSE_FILTER_DONE;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResponseFilterOwn) then
    Result := TOldCefResponseFilterOwn(TempObject).Filter(data_in,  data_in_size,  data_in_read,
                                                       data_out, data_out_size, data_out_written);
end;

constructor TOldCefResponseFilterOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefResponseFilter));

  with POldCefResponseFilter(FData)^ do
    begin
      init_filter := cef_response_filter_init_filter;
      filter      := cef_response_filter_filter;
    end;
end;


// TCustomResponseFilter


constructor TOldCustomResponseFilter.Create;
begin
  inherited Create;

  FOnFilter     := nil;
  FOnInitFilter := nil;
end;

function TOldCustomResponseFilter.InitFilter: Boolean;
begin
  Result := True;
  if assigned(FOnInitFilter) then FOnInitFilter(self, Result);
end;

function TOldCustomResponseFilter.Filter(    data_in          : Pointer;
                                          data_in_size     : NativeUInt;
                                      var data_in_read     : NativeUInt;
                                          data_out         : Pointer;
                                          data_out_size    : NativeUInt;
                                      var data_out_written : NativeUInt) : TOldCefResponseFilterStatus;
begin
  Result := RESPONSE_FILTER_DONE;

  if assigned(FOnFilter) then
    FOnFilter(self,
              data_in,  data_in_size,  data_in_read,
              data_out, data_out_size, data_out_written,
              Result);
end;


end.
