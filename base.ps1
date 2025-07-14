# PowerShell 7 スクリプト
# idea フォルダ構造を安全に作成します

# スクリプトの場所を基準にする
$base = $PSScriptRoot

# フォルダ一覧
$folders = @(
    "idea/object_oriented",
    "idea/variables",
    "idea/control_flow",
    "idea/functions",
    "idea/collections",
    "idea/operators",
    "idea/philosophy",
    "idea/errors"
)

# ファイル一覧
$files = @(
    "idea/object_oriented/class.md",
    "idea/object_oriented/interface.md",
    "idea/object_oriented/module.md",
    "idea/object_oriented/with.md",
    "idea/object_oriented/disposing.md",
    "idea/object_oriented/access_modifiers.md",
    "idea/variables/variables.md",
    "idea/variables/ownership.md",
    "idea/variables/borrowing.md",
    "idea/variables/immutable.md",
    "idea/variables/default_field.md",
    "idea/control_flow/if.md",
    "idea/control_flow/match.md",
    "idea/control_flow/for.md",
    "idea/control_flow/while.md",
    "idea/control_flow/break_continue.md",
    "idea/control_flow/return.md",
    "idea/functions/functions.md",
    "idea/functions/closures.md",
    "idea/functions/defer.md",
    "idea/collections/arrays.md",
    "idea/collections/strings.md",
    "idea/collections/maps.md",
    "idea/collections/sets.md",
    "idea/operators/operators.md",
    "idea/operators/is_operator.md",
    "idea/philosophy/design_philosophy.md",
    "idea/philosophy/memory_management.md",
    "idea/errors/error_handling.md",
    "idea/errors/exceptions.md"
)

# フォルダ作成
foreach ($folder in $folders) {
    $path = Join-Path $base $folder
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

# ファイル作成
foreach ($file in $files) {
    $path = Join-Path $base $file
    if (-not (Test-Path $path)) {
        New-Item -ItemType File -Path $path | Out-Null
    }
}

Write-Host "✅ フォルダとファイルを作成しました！（基準: $base）"
