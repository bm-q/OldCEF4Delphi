// ************************************************************************
// **************************** OldCEF4Delphi *****************************
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

unit oldCEFSslInfo;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SysUtils,
  {$ELSE}
  Classes, SysUtils,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefSslInfoRef = class(TOldCefBaseRef, IOldCefSslInfo)
    protected
      function  GetCertStatus: TOldCefCertStatus;
      function  IsCertStatusError: Boolean;
      function  IsCertStatusMinorError: Boolean;
      function  GetSubject: IOldCefSslCertPrincipal;
      function  GetIssuer: IOldCefSslCertPrincipal;
      function  GetSerialNumber: IOldCefBinaryValue;
      function  GetValidStart: TOldCefTime;
      function  GetValidExpiry: TOldCefTime;
      function  GetDerEncoded: IOldCefBinaryValue;
      function  GetPemEncoded: IOldCefBinaryValue;
      function  GetIssuerChainSize: NativeUInt;
      procedure GetDEREncodedIssuerChain(chainCount: NativeUInt; var chain : TOldCefBinaryValueArray);
      procedure GetPEMEncodedIssuerChain(chainCount: NativeUInt; var chain : TOldCefBinaryValueArray);

    public
      class function UnWrap(data: Pointer): IOldCefSslInfo;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBinaryValue, oldCEFSslCertPrincipal;


function TOldCefSslInfoRef.GetCertStatus: TOldCefCertStatus;
begin
  Result := POldCefSslInfo(FData).get_cert_status(FData);
end;

function TOldCefSslInfoRef.GetDerEncoded: IOldCefBinaryValue;
begin
  Result := TOldCefBinaryValueRef.UnWrap(POldCefSslInfo(FData).get_derencoded(FData));
end;

function TOldCefSslInfoRef.GetIssuer: IOldCefSslCertPrincipal;
begin
  Result := TOldCefSslCertPrincipalRef.UnWrap(POldCefSslInfo(FData).get_issuer(FData));
end;

function TOldCefSslInfoRef.GetIssuerChainSize: NativeUInt;
begin
  Result := POldCefSslInfo(FData).get_issuer_chain_size(FData);
end;

function TOldCefSslInfoRef.GetPemEncoded: IOldCefBinaryValue;
begin
  Result := TOldCefBinaryValueRef.UnWrap(POldCefSslInfo(FData).get_pemencoded(FData));
end;

function TOldCefSslInfoRef.GetSerialNumber: IOldCefBinaryValue;
begin
  Result := TOldCefBinaryValueRef.UnWrap(POldCefSslInfo(FData).get_serial_number(FData));
end;

function TOldCefSslInfoRef.GetSubject: IOldCefSslCertPrincipal;
begin
  Result := TOldCefSslCertPrincipalRef.UnWrap(POldCefSslInfo(FData).get_subject(FData));
end;

function TOldCefSslInfoRef.GetValidExpiry: TOldCefTime;
begin
  Result := POldCefSslInfo(FData).get_valid_expiry(FData);
end;

function TOldCefSslInfoRef.GetValidStart: TOldCefTime;
begin
  Result := POldCefSslInfo(FData).get_valid_start(FData);
end;

function TOldCefSslInfoRef.IsCertStatusError: Boolean;
begin
  Result := POldCefSslInfo(FData).is_cert_status_error(FData) <> 0;
end;

function TOldCefSslInfoRef.IsCertStatusMinorError: Boolean;
begin
  Result := POldCefSslInfo(FData).is_cert_status_minor_error(FData) <> 0;
end;

procedure TOldCefSslInfoRef.GetDEREncodedIssuerChain(chainCount: NativeUInt; var chain : TOldCefBinaryValueArray);
var
  TempArray : array of POldCefBinaryValue;
  i : NativeUInt;
begin
  TempArray := nil;

  try
    try
      if (chainCount > 0) then
        begin
          SetLength(TempArray, chainCount);

          i := 0;
          while (i < chainCount) do
            begin
              TempArray[i] := nil;
              inc(i);
            end;

          POldCefSslInfo(FData).get_derencoded_issuer_chain(FData, chainCount, TempArray[0]);

          if (chainCount > 0) then
            begin
              SetLength(chain, chainCount);

              i := 0;
              while (i < chainCount) do
                begin
                  chain[i] := TOldCefBinaryValueRef.UnWrap(TempArray[i]);
                  inc(i);
                end;
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefSslInfoRef.GetDEREncodedIssuerChain', e) then raise;
    end;
  finally
    if (TempArray <> nil) then
      begin
        Finalize(TempArray);
        TempArray := nil;
      end;
  end;
end;

procedure TOldCefSslInfoRef.GetPEMEncodedIssuerChain(chainCount: NativeUInt; var chain : TOldCefBinaryValueArray);
var
  TempArray : array of POldCefBinaryValue;
  i : NativeUInt;
begin
  TempArray := nil;

  try
    try
      if (chainCount > 0) then
        begin
          SetLength(TempArray, chainCount);

          i := 0;
          while (i < chainCount) do
            begin
              TempArray[i] := nil;
              inc(i);
            end;

          POldCefSslInfo(FData).get_pemencoded_issuer_chain(FData, chainCount, TempArray[0]);

          if (chainCount > 0) then
            begin
              SetLength(chain, chainCount);

              i := 0;
              while (i < chainCount) do
                begin
                  chain[i] := TOldCefBinaryValueRef.UnWrap(TempArray[i]);
                  inc(i);
                end;
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefSslInfoRef.GetPEMEncodedIssuerChain', e) then raise;
    end;
  finally
    if (TempArray <> nil) then
      begin
        Finalize(TempArray);
        TempArray := nil;
      end;
  end;
end;

class function TOldCefSslInfoRef.UnWrap(data: Pointer): IOldCefSslInfo;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefSslInfo
   else
    Result := nil;
end;

end.
