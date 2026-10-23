# builds the zip that gets uploaded to mod.io. only the files players need go in, docs,
# tests, tools and AGENTS.md stay out. run from anywhere:
#   powershell -File tools/package.ps1
#
# entries are added one by one with / separators. Compress-Archive in windows powershell 5.1
# writes \ instead, which other unzip tools read as part of the file name

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Split-Path -Parent $PSScriptRoot
$manifest = Get-Content (Join-Path $root "plugin.json") -Raw | ConvertFrom-Json
$version = $manifest.version

# the local testing switch must be off in anything players get
$development = Get-Content (Join-Path $root "src/development.lua") -Raw
if ($development -notmatch "ENABLED\s*=\s*false") {
    throw "src/development.lua has ENABLED switched on, set it to false before packaging"
}

$shipped = @("main.lua", "plugin.json", "README.md", "CHANGELOG.md", "THIRD_PARTY_NOTICES.txt")
$files = @()

foreach ($name in $shipped) {
    $files += Get-Item (Join-Path $root $name)
}
$files += Get-ChildItem -Recurse -File (Join-Path $root "src")

$dist = Join-Path $root "dist"
New-Item -ItemType Directory -Force $dist | Out-Null
$zip = Join-Path $dist ("skilling-coach-" + $version + ".zip")

if (Test-Path $zip) {
    Remove-Item -Force $zip
}

$archive = [System.IO.Compression.ZipFile]::Open($zip, "Create")

try {
    foreach ($file in $files) {
        $entry = $file.FullName.Substring($root.Length + 1).Replace("\", "/")
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $file.FullName, $entry) | Out-Null
    }
}
finally {
    $archive.Dispose()
}

Write-Output ("built " + $zip + " (" + $files.Count + " files)")
