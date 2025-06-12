param (
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

# Check if file exists
if (-not (Test-Path $FilePath)) {
    throw "File not found: $FilePath"
}

# Allowed ApplicationArea values
$allowed = @(
    "All", "Basic", "Suite", "Advanced", "RelationshipMgmt", "SalesTax", "VAT",
    "BasicEU", "BasicNO", "Dimensions", "SalesAnalysis", "InventoryAnalysis",
    "PurchaseAnalysis", "Location", "Assembly", "Manufacturing", "Planning"
)

# Read AL file content
$content = Get-Content -Path $FilePath -Raw
$lines = Get-Content -Path $FilePath

$lineNumber = 0

foreach ($line in $lines) {
    $lineNumber++
    $trimmedLine = $line.Trim()

    # Check for invalid ApplicationArea values
    if ($line -match "ApplicationArea\s*=\s*(\w+)") {
        $appArea = [regex]::Match($line, "ApplicationArea\s*=\s*(\w+)").Groups[1].Value
        if ($allowed -notcontains $appArea) {
            Write-Output "❌ Line $lineNumber : Invalid ApplicationArea value: '$appArea'"
        }
    }

    # Check for commented action blocks (/* action( pattern)
    if ($line -match "/\*\s*action\s*\(") {
        Write-Output "❌ Line $lineNumber : Commented-out action block detected"
    }

    # Check for hardcoded Error messages (not in comment lines)
    if ($line -notmatch "^\s*//" -and $line -notmatch "^\s*/\*") {
        if ($line -match "Error\s*\(\s*'[^']+'") {
            Write-Output "❌ Line $lineNumber : Hardcoded Error message found (should use labels)"
        }
        if ($line -match "Confirm\s*\(\s*'[^']+'") {
            Write-Output "❌ Line $lineNumber : Hardcoded Confirm message found (should use labels)"
        }
        if ($line -match "Message\s*\(\s*'[^']+'") {
            Write-Output "❌ Line $lineNumber : Hardcoded Message text found (should use labels)"
        }
    }

    # Check for commented-out AL objects (// field(, // action(, // procedure(, // part()
    if ($line -match "//\s*(field|action|procedure|part)\s*\(") {
        Write-Output "❌ Line $lineNumber : Commented-out AL object (field/action/procedure/part)"
    }

    # Check for empty begin...end blocks
    if ($line -match "begin\s*$") {
        # Look for matching end on same line or next lines
        $nextLineIndex = $lineNumber
        $foundEnd = $false
        while ($nextLineIndex -le $lines.Count) {
            if ($nextLineIndex -eq $lineNumber) {
                # Check if end is on same line
                if ($line -match "begin\s*end\s*;") {
                    $foundEnd = $true
                    break
                }
            } else {
                $nextLine = $lines[$nextLineIndex - 1].Trim()
                if ($nextLine -match "^\s*end\s*;" -and $nextLine -notmatch "\S.*end\s*;") {
                    $foundEnd = $true
                    break
                } elseif ($nextLine -match "\S" -and $nextLine -notmatch "^\s*end\s*;") {
                    # Found non-empty, non-end content
                    break
                }
            }
            $nextLineIndex++
        }
        if ($foundEnd) {
            Write-Output "⚠️ Line $lineNumber : Empty begin...end block"
        }
    }

    # Check for Visible = false
    if ($line -match "Visible\s*=\s*false\s*;") {
        Write-Output "⚠️ Line $lineNumber : UI element marked as Visible = false"
    }

    # Check for TODO comments
    if ($line -match "TODO|ToDo|to-do") {
        Write-Output "⚠️ Line $lineNumber : TODO found — consider resolving before production"
    }

    # Check for hardcoded object IDs in Run/RunModal calls
    if ($line -match "\b(Codeunit|Page|Report|XmlPort)\.Run(Modal)?\s*\(\s*(\d+)") {
        $objectType = $matches[1]
        Write-Output "⚠️ Line $lineNumber : Hardcoded object ID used in $objectType.Run/RunModal — consider using symbolic names or constants"
    }

    # Check for DataClassification = ToBeClassified
    if ($line -match "DataClassification\s*=\s*ToBeClassified") {
        Write-Output "⚠️ Line $lineNumber : DataClassification is set to 'ToBeClassified' — consider using a proper classification"
    }
}