<#
.SYNOPSIS
    Import, export, and assign Intune endpoint security policies that flow through the
    Microsoft Defender for Endpoint security-settings-management channel
    ("Managed by MDE" devices, not Intune-enrolled).

.DESCRIPTION
    Uses the Microsoft Graph PowerShell SDK (Invoke-MgGraphRequest) against the
    /beta/deviceManagement/configurationPolicies endpoint (settings catalog).

    The MDE channel is what makes these policies reach non-enrolled devices. It is
    encoded in each policy body as:  "technologies": "mdm,microsoftSense"

    RELIABLE WORKFLOW (recommended):
      1. Build ONE policy of each type in the portal exactly how you want it.
      2. Run this script with -Action Export  ->  captures verified, re-importable JSON.
      3. Version those JSON files in source control. Re-import to restore/replicate.

    The bundled ./policies/*.json files are BEST-EFFORT starting points. Validate the
    setting definition IDs against an exported policy from YOUR tenant before relying on them.

.PARAMETER Action
    Import | Export | Assign

.PARAMETER Path
    Folder containing *.json to import (Import) or destination folder for exports (Export).

.PARAMETER PolicyId
    For Export of a single policy, or for Assign.

.PARAMETER GroupId
    Entra ID device-group object ID to assign a policy to (Assign).

.EXAMPLE
    # Connect and import every JSON in ./policies
    .\Manage-IntuneMDEPolicies.ps1 -Action Import -Path .\policies

.EXAMPLE
    # Export all endpoint-security configuration policies as clean, re-importable JSON
    .\Manage-IntuneMDEPolicies.ps1 -Action Export -Path .\exported

.EXAMPLE
    # Assign a created policy to your pilot device group
    .\Manage-IntuneMDEPolicies.ps1 -Action Assign -PolicyId <id> -GroupId <entraGroupObjectId>

.NOTES
    Requires:  Install-Module Microsoft.Graph.Authentication -Scope CurrentUser
    Scope:     DeviceManagementConfiguration.ReadWrite.All
#>
[CmdletBinding()]
param(
    [ValidateSet('Import', 'Export', 'Assign')]
    [string]$Action = 'Import',

    [string]$Path = '.\policies',

    [string]$PolicyId,

    [string]$GroupId
)

$ErrorActionPreference = 'Stop'
$Base = 'https://graph.microsoft.com/beta/deviceManagement/configurationPolicies'

# --- Auth -------------------------------------------------------------------
if (-not (Get-Module -ListAvailable Microsoft.Graph.Authentication)) {
    throw "Install-Module Microsoft.Graph.Authentication -Scope CurrentUser  (then re-run)"
}
Import-Module Microsoft.Graph.Authentication -ErrorAction Stop

if (-not (Get-MgContext)) {
    Connect-MgGraph -Scopes 'DeviceManagementConfiguration.ReadWrite.All' -NoWelcome
}
Write-Host ("Connected as {0} ({1})" -f (Get-MgContext).Account, (Get-MgContext).TenantId) -ForegroundColor Cyan

# --- Helpers ----------------------------------------------------------------
# Read-only properties Graph rejects on POST. Stripped before re-import.
$ReadOnlyProps = @(
    'id', 'createdDateTime', 'lastModifiedDateTime', 'settingCount',
    'creationSource', 'isAssigned', 'priorityMetaData', 'templateReference@odata.context',
    '@odata.context', 'supportsScopeTags'
)

function Remove-ReadOnly {
    param([Parameter(Mandatory)] $Object)
    foreach ($p in $ReadOnlyProps) { $Object.PSObject.Properties.Remove($p) | Out-Null }
    # settings come back with their own 'id'; strip so they re-create cleanly
    if ($Object.settings) {
        foreach ($s in $Object.settings) { if ($s.PSObject.Properties['id']) { $s.PSObject.Properties.Remove('id') | Out-Null } }
    }
    return $Object
}

function Import-Policies {
    $files = Get-ChildItem -Path $Path -Filter '*.json' -File | Sort-Object Name
    if (-not $files) { Write-Warning "No *.json found in $Path"; return }

    foreach ($f in $files) {
        Write-Host "`nImporting $($f.Name) ..." -ForegroundColor Yellow
        $body = Get-Content $f.FullName -Raw
        try {
            $resp = Invoke-MgGraphRequest -Method POST -Uri $Base -Body $body -ContentType 'application/json'
            Write-Host ("  Created: {0}  [{1}]" -f $resp.name, $resp.id) -ForegroundColor Green
            Write-Host ("  Assign with: .\Manage-IntuneMDEPolicies.ps1 -Action Assign -PolicyId {0} -GroupId <groupId>" -f $resp.id)
        }
        catch {
            Write-Host "  FAILED: $($_.Exception.Message)" -ForegroundColor Red
            Write-Host "  (Most common cause: a settingDefinitionId/option value that doesn't match this tenant's service version." -ForegroundColor DarkYellow
            Write-Host "   Fix: build that one policy in the portal, Export it, diff the IDs.)" -ForegroundColor DarkYellow
        }
    }
}

function Export-Policies {
    if (-not (Test-Path $Path)) { New-Item -ItemType Directory -Path $Path | Out-Null }

    if ($PolicyId) {
        $ids = @($PolicyId)
    }
    else {
        # Pull all settings-catalog policies; filter to ones using the MDE (microsoftSense) channel
        $all = (Invoke-MgGraphRequest -Method GET -Uri "$Base`?`$select=id,name,technologies").value
        $ids = ($all | Where-Object { $_.technologies -match 'microsoftSense' }).id
        Write-Host ("Found {0} MDE-channel policies to export." -f $ids.Count) -ForegroundColor Cyan
    }

    foreach ($id in $ids) {
        $p = Invoke-MgGraphRequest -Method GET -Uri "$Base/$id`?`$expand=settings"
        $clean = Remove-ReadOnly -Object ([pscustomobject]$p)
        $safeName = ($clean.name -replace '[^\w\-]', '_')
        $out = Join-Path $Path "$safeName.json"
        $clean | ConvertTo-Json -Depth 50 | Set-Content -Path $out -Encoding UTF8
        Write-Host ("  Exported: {0}" -f $out) -ForegroundColor Green
    }
}

function Assign-Policy {
    if (-not $PolicyId -or -not $GroupId) { throw "-PolicyId and -GroupId are both required for Assign." }
    $assignBody = @{
        assignments = @(
            @{ target = @{ '@odata.type' = '#microsoft.graph.groupAssignmentTarget'; groupId = $GroupId } }
        )
    } | ConvertTo-Json -Depth 10
    Invoke-MgGraphRequest -Method POST -Uri "$Base/$PolicyId/assign" -Body $assignBody -ContentType 'application/json' | Out-Null
    Write-Host ("Assigned policy {0} -> group {1}" -f $PolicyId, $GroupId) -ForegroundColor Green
}

# --- Dispatch ---------------------------------------------------------------
switch ($Action) {
    'Import' { Import-Policies }
    'Export' { Export-Policies }
    'Assign' { Assign-Policy }
}
