# TEMP Spike A build script. Compiles hello.c with NDK Clang into a PIE
# executable named lib*.so and stages it under jniLibs/ so AGP packages it
# into the APK lib dir (extracted on device when extractNativeLibs=true).
# The staged .so is a local artifact, intentionally NOT committed.
param(
    [string]$Ndk = "$env:LOCALAPPDATA\Android\sdk\ndk\28.2.13676358",
    [string]$Api = "24"
)

$ErrorActionPreference = "Stop"
$clang = Join-Path $Ndk "toolchains\llvm\prebuilt\windows-x86_64\bin\clang.exe"
$src = Join-Path $PSScriptRoot "hello.c"
$outDir = Join-Path $PSScriptRoot "..\..\..\android\app\src\main\jniLibs\arm64-v8a"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$out = Join-Path $outDir "libspike_hello.so"
& $clang --target=aarch64-linux-android$Api -O2 -pie -fPIE $src -o $out
Write-Host "staged: $out"
