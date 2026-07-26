; Dashboard Clinic El-Wafa — Inno Setup 6 script
; Identity (MyAppName, MyAppVersion, …) is normally passed via ISCC /D from build_release.ps1.
; Fallbacks below keep the script compilable when opened in the Inno IDE.

#ifndef MyAppName
  #define MyAppName "Dashboard Clinic El-Wafa"
#endif
#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#ifndef MyAppPublisher
  #define MyAppPublisher "Samaa Dev"
#endif
#ifndef MyAppExeName
  #define MyAppExeName "dentist_booking_admin.exe"
#endif
#ifndef MyAppId
  #define MyAppId "{{A1B2C3D4-E5F6-7890-ABCD-1234567890CD}}"
#endif
#ifndef MyAppOutputBase
  #define MyAppOutputBase "Dashboard-Clinic-El-Wafa-Setup"
#endif
#ifndef MyRegistryKey
  #define MyRegistryKey "Software\Samaa Dev\Dashboard Clinic El-Wafa"
#endif
#ifndef ProjectRoot
  #define ProjectRoot "..\.."
#endif

[Setup]
AppId={#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL=https://samaadev.com
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputDir={#ProjectRoot}\output\windows
OutputBaseFilename={#MyAppOutputBase}-{#MyAppVersion}
SetupIconFile={#ProjectRoot}\windows\runner\resources\app_icon.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
PrivilegesRequired=admin
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0
VersionInfoVersion={#MyAppVersion}.0
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Setup
VersionInfoProductName={#MyAppName}
CloseApplications=yes
RestartIfNeededByRun=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Flutter Release build output
Source: "{#ProjectRoot}\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; VC++ Redistributable (staged to temp, installed only when needed)
Source: "redist\VC_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKLM; Subkey: "{#MyRegistryKey}"; ValueType: string; ValueName: "Version"; ValueData: "{#MyAppVersion}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "{#MyRegistryKey}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey

[Run]
; Install VC++ runtime quietly when missing / too old
Filename: "{tmp}\VC_redist.x64.exe"; \
  Parameters: "/install /quiet /norestart"; \
  StatusMsg: "Installing Microsoft Visual C++ Redistributable..."; \
  Check: VCRedistNeedsInstall; \
  Flags: waituntilterminated
; Launch app after install
Filename: "{app}\{#MyAppExeName}"; \
  Description: "{cm:LaunchProgram,{#MyAppName}}"; \
  Flags: nowait postinstall skipifsilent

[Code]
function VCRedistNeedsInstall: Boolean;
var
  Installed: Cardinal;
  Major, Minor, Bld: Cardinal;
begin
  Result := True;

  // VC++ 2015–2022 x64 runtime registry key
  if RegQueryDWordValue(HKEY_LOCAL_MACHINE,
       'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64',
       'Installed', Installed) then
  begin
    if Installed = 1 then
    begin
      if RegQueryDWordValue(HKEY_LOCAL_MACHINE,
           'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64',
           'Major', Major) and
         RegQueryDWordValue(HKEY_LOCAL_MACHINE,
           'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64',
           'Minor', Minor) and
         RegQueryDWordValue(HKEY_LOCAL_MACHINE,
           'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64',
           'Bld', Bld) then
      begin
        // Require roughly VS 2019+ runtime (14.20+) which Flutter Windows typically needs
        if (Major > 14) or
           ((Major = 14) and (Minor > 20)) or
           ((Major = 14) and (Minor = 20) and (Bld >= 0)) then
          Result := False;
      end
      else
        Result := False;
    end;
  end;
end;
