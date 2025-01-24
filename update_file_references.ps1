param(
    [switch]$WhatIf = $false
)

# Function to update file references
function Update-FileReferences {
    param(
        [string]$Path
    )

    # Patterns to replace
    $replacements = @{
        'lecture-'    = 'lecture_'
        'hw-'         = 'hw_'
        'discussion-' = 'discussion_'
        'reading-'    = 'reading_'
    }

    $updatedFiles = 0

    Get-ChildItem -Path $Path -Recurse -Include *.md | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        $originalContent = $content

        # Check for matching patterns before replacement
        $matchingPatterns = $replacements.Keys | Where-Object { $content -match $_ }
        if ($matchingPatterns) {
            Write-Host "Found matching patterns in $($_.FullName):"
            $matchingPatterns | ForEach-Object { Write-Host "  - $_" }
        }

        # Replace each pattern
        foreach ($key in $replacements.Keys) {
            $content = $content -replace [regex]::Escape($key), $replacements[$key]
        }

        if ($content -ne $originalContent) {
            $updatedFiles++
            if ($WhatIf) {
                Write-Host "Would update references in: $($_.FullName)"
            }
            else {
                Set-Content -Path $_.FullName -Value $content
                Write-Host "Updated references in: $($_.FullName)"
            }
        }
    }

    Write-Host "Total files updated: $updatedFiles"
}

# Run the update function
Update-FileReferences -Path "."

# Optional: If you want to do a dry run first, use the script with -WhatIf
# .\update_file_references.ps1 -WhatIf 