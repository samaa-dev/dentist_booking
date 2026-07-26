# Single source of truth for Windows installer identity and paths.
# Override any value when dot-sourcing before calling build_release.ps1 if needed.

$script:AppConfig = [ordered]@{
    AppName       = 'Dashboard Clinic El-Wafa'
    AppPublisher  = 'Samaa Dev'
    AppExeName    = 'dentist_booking_admin.exe'
    # Stable AppId — do not change between releases (upgrades/uninstall rely on it).
    AppId         = '{{A1B2C3D4-E5F6-7890-ABCD-1234567890CD}}'
    OutputBaseName = 'Dashboard-Clinic-El-Wafa-Setup'
    RegistryKey   = 'Software\Samaa Dev\Dashboard Clinic El-Wafa'
}

# Paths relative to the Flutter project root (resolved by build_release.ps1).
$script:PathConfig = [ordered]@{
    IssFile            = 'installer\windows\DashboardClinicElWafa.iss'
    RedistDir          = 'installer\windows\redist'
    RedistFileName     = 'VC_redist.x64.exe'
    FlutterReleaseDir  = 'build\windows\x64\runner\Release'
    DefaultOutputDir   = 'output\windows'
    AppIcon            = 'windows\runner\resources\app_icon.ico'
}

# Official Microsoft direct link for the latest supported VC++ x64 redistributable.
$script:VcRedistUrl = 'https://aka.ms/vs/17/release/vc_redist.x64.exe'
