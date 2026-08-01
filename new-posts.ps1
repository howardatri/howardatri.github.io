# Batch create Hugo post skeletons
# Usage:
#   .\new-posts.ps1 -Titles "Post One","Post Two" -Tags "tech,hugo" -Category "tech"
#   .\new-posts.ps1 -Titles "Test" -Draft
#   .\new-posts.ps1 -List .\titles.txt   (one title per line)

param(
    [string[]]$Titles,
    [string]$Tags = "misc",
    [string]$Category = "misc",
    [switch]$Draft,
    [string]$List
)

$ErrorActionPreference = "Stop"
$contentDir = Join-Path $PSScriptRoot "content\posts"
New-Item -ItemType Directory -Path $contentDir -Force | Out-Null

$allTitles = @()
if ($List) {
    if (-not (Test-Path $List)) { Write-Host "File not found: $List" -ForegroundColor Red; exit 1 }
    $allTitles = Get-Content $List | Where-Object { $_.Trim() -ne "" }
} else {
    $allTitles = $Titles
}

if ($allTitles.Count -eq 0) {
    Write-Host "No titles provided. Usage: .\new-posts.ps1 -Titles `"a`",`"b`"" -ForegroundColor Yellow
    exit 1
}

$date = Get-Date -Format "yyyy-MM-ddTHH:mm:ss+08:00"
$tagList = ($Tags -split "," | ForEach-Object { $_.Trim() }) -join "', '"

foreach ($title in $allTitles) {
    $slug = $title.Trim()
    $file = Join-Path $contentDir "$slug.md"
    if (Test-Path $file) {
        Write-Host "[SKIP] already exists: $slug" -ForegroundColor Yellow
        continue
    }
    $draftState = 'false'
    if ($Draft.IsPresent) { $draftState = 'true' }
    $content = @"
+++
title = '$title'
date = '$date'
draft = $draftState
tags = ['$tagList']
categories = ['$Category']
description = ''
+++
"@
    Set-Content -Path $file -Value $content -Encoding UTF8
    Write-Host "[CREATE] $file" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done! Created $($allTitles.Count) post(s)." -ForegroundColor Cyan
if (-not $Draft) {
    Write-Host "Posts have draft=false. Commit and push to publish: git add . ; git commit ; git push" -ForegroundColor Cyan
} else {
    Write-Host "Posts are drafts. Edit them and set draft=false to publish." -ForegroundColor Cyan
}
