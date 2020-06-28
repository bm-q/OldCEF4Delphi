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

unit oldCEFSslCertPrincipal;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefSslCertPrincipalRef = class(TOldCefBaseRef, IOldCefSslCertPrincipal)
    protected
      function  GetDisplayName: oldustring;
      function  GetCommonName: oldustring;
      function  GetLocalityName: oldustring;
      function  GetStateOrProvinceName: oldustring;
      function  GetCountryName: oldustring;
      procedure GetStreetAddresses(var addresses: TStrings);
      procedure GetOrganizationNames(var names: TStrings);
      procedure GetOrganizationUnitNames(var names: TStrings);
      procedure GetDomainComponents(var components: TStrings);
    public
      class function UnWrap(data: Pointer): IOldCefSslCertPrincipal;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringList;


function TOldCefSslCertPrincipalRef.GetCommonName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefSslCertPrincipal(FData).get_common_name(POldCefSslCertPrincipal(FData)));
end;

function TOldCefSslCertPrincipalRef.GetCountryName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefSslCertPrincipal(FData).get_country_name(POldCefSslCertPrincipal(FData)));
end;

function TOldCefSslCertPrincipalRef.GetDisplayName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefSslCertPrincipal(FData).get_display_name(POldCefSslCertPrincipal(FData)));
end;

procedure TOldCefSslCertPrincipalRef.GetDomainComponents(var components: TStrings);
var
  TempSL : IOldCefStringList;
begin
  if (components <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefSslCertPrincipal(FData).get_domain_components(POldCefSslCertPrincipal(FData), TempSL.Handle);
      TempSL.CopyToStrings(components);
    end;
end;

function TOldCefSslCertPrincipalRef.GetLocalityName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefSslCertPrincipal(FData).get_locality_name(POldCefSslCertPrincipal(FData)));
end;

procedure TOldCefSslCertPrincipalRef.GetOrganizationNames(var names: TStrings);
var
  TempSL : IOldCefStringList;
begin
  if (names <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefSslCertPrincipal(FData).get_organization_names(POldCefSslCertPrincipal(FData), TempSL.Handle);
      TempSL.CopyToStrings(names);
    end;
end;

procedure TOldCefSslCertPrincipalRef.GetOrganizationUnitNames(var names: TStrings);
var
  TempSL : IOldCefStringList;
begin
  if (names <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefSslCertPrincipal(FData).get_organization_unit_names(POldCefSslCertPrincipal(FData), TempSL.Handle);
      TempSL.CopyToStrings(names);
    end;
end;

function TOldCefSslCertPrincipalRef.GetStateOrProvinceName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefSslCertPrincipal(FData).get_state_or_province_name(FData));
end;

procedure TOldCefSslCertPrincipalRef.GetStreetAddresses(var addresses: TStrings);
var
  TempSL : IOldCefStringList;
begin
  if (addresses <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefSslCertPrincipal(FData).get_street_addresses(POldCefSslCertPrincipal(FData), TempSL.Handle);
      TempSL.CopyToStrings(addresses);
    end;
end;

class function TOldCefSslCertPrincipalRef.UnWrap(data: Pointer): IOldCefSslCertPrincipal;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefSslCertPrincipal
   else
    Result := nil;
end;

end.
