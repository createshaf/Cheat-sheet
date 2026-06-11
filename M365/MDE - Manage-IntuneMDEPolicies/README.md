# Windows MDE-Managed Endpoint Security Policies — Graph Import Kit

Import Windows endpoint security policies into Intune via Microsoft Graph, targeting the
**Defender for Endpoint security-settings-management channel** ("Managed by MDE", non-enrolled devices).

## Status of this kit
- `policies/01-Antivirus.json` — **VERIFIED, import-ready.** Built from a real export of your tenant.
- `_scaffold/*.json` (EDR, Firewall, Firewall Rules, ASR) — **structure reference only, will NOT import as-is.**
  Build + export each (see workflow below). They're kept so you can see the intended settings/values.

## The key lesson (why hand-authored JSON failed)
These are endpoint-security **template** policies (`templateReference.templateFamily = endpointSecurityAntivirus`, etc).
Every setting must carry its own `settingInstanceTemplateReference` and `settingValueTemplateReference` — GUIDs
that are **unique per setting** and only obtainable by exporting a policy you built in the portal. A body with a
valid `settingDefinitionId` but no template references returns HTTP 400 / `Setting Id is not found`.
`microsoftSense` (the MDE channel) also exposes a **subset** of settings — e.g. `DisableLocalAdminMerge`
does not exist for MDE-managed devices, which is why it 400'd.

## The reliable loop (proven with your AV policy)
1. Build the policy in the portal (Defender XDR → Endpoints → Configuration management →
   Endpoint security policies → Windows). The portal only offers MDE-valid settings.
2. Capture it as JSON — either:
   - `.\Manage-IntuneMDEPolicies.ps1 -Action Export -Path .\verified`  (exports + cleans automatically), or
   - GET it in Graph Explorer / portal, then `.\Manage-IntuneMDEPolicies.ps1 -Action Clean -PolicyFile .\raw.json`
3. Drop the cleaned file in `.\policies` and re-import anywhere with `-Action Import`.

Repeat for EDR, Firewall, Firewall Rules, ASR. ~2 minutes each.

## Prerequisites
```powershell
Install-Module Microsoft.Graph.Authentication -Scope CurrentUser
```
Role: **Endpoint Security Manager** with `DeviceManagementConfiguration.ReadWrite.All`.

## Usage
```powershell
# Import the verified AV policy (and anything else you've added to .\policies)
.\Manage-IntuneMDEPolicies.ps1 -Action Import -Path .\policies

# Assign a created policy to your pilot device group
.\Manage-IntuneMDEPolicies.ps1 -Action Assign -PolicyId <policyId> -GroupId <entraGroupObjectId>

# Export all MDE-channel policies as clean, re-importable JSON
.\Manage-IntuneMDEPolicies.ps1 -Action Export -Path .\verified

# Clean a raw export captured outside this script
.\Manage-IntuneMDEPolicies.ps1 -Action Clean -PolicyFile .\raw-export.json
```

## What's encoded in your AV policy (`01-Antivirus.json`)
Real-time/behavior/on-access ON, Cloud Protection ON, Cloud Block Level **High**, Cloud Extended Timeout 50,
PUA **Block**, Submit Samples (safe) auto, archive/email/script/network-file/removable scanning ON,
full scan on mapped drives OFF, Signature Update Interval 4h, scheduled quick scan, retain cleaned malware 30d,
Network Protection **Block**, threat default actions (severe/high = Remove, moderate/low = Quarantine),
update channels = Current Channel (Broad), schedule randomization ON.

Two of your choices worth a conscious confirm:
- **Allow User UI Access = Disabled** (`..._0`) — silent client; users won't see the Defender UI/notifications.
  Fine for servers; for user endpoints some orgs keep it visible to aid self-service troubleshooting.
- **Update channels = Broad (value 5)** — most stable / last to receive updates. For a *pilot* you sometimes
  want Staged (4) to surface issues earlier; for a server baseline, Broad is the safe call.

The policy is named `...Windows-Server-Baseline` and includes a server-only setting
(`allowdatagramprocessingonwinserver`). Server-only settings simply no-op on Win10/11 clients, so it's safe to
reuse for the client pilot — just confirm the naming matches your intent.

---

## ASR rule reference (GUID → Audit) — for when you build the ASR policy
State codes: `0` Off · `1` Block · `2` Audit · `6` Warn. Per your decision, all = `2` (Audit).
Network Protection = Block, Controlled Folder Access = Audit (flip to Enabled post-pilot).

| Rule | GUID |
|---|---|
| Block abuse of exploited vulnerable signed drivers | 56a863a9-875e-4185-98a7-b882c64b5ce5 |
| Block Adobe Reader from creating child processes | 7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c |
| Block all Office apps from creating child processes | d4f940ab-401b-4efc-aadc-ad5f3c50688a |
| Block credential stealing from LSASS | 9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2 |
| Block executable content from email/webmail | be9ba2d9-53ea-4cdc-84e5-9b1eeee46550 |
| Block executable files unless prevalence/age/trusted | 01443614-cd74-433a-b99e-2ecdc07bfc25 |
| Block potentially obfuscated scripts | 5beb7efe-fd9a-4556-801d-275e5ffc04cc |
| Block JS/VBScript launching downloaded executable | d3e037e1-3eb8-44c8-a917-57927947596d |
| Block Office apps creating executable content | 3b576869-a4ec-4529-8536-b80a7769e899 |
| Block Office apps injecting code into other processes | 75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84 |
| Block Office communication app creating child processes | 26190899-1602-49e8-8b27-eb1d0a1ce869 |
| Block persistence through WMI event subscription | e6db77e5-3df2-4cf1-b95a-636979351e5b |
| Block process creations from PSExec and WMI | d1e49aac-8f56-4280-b9ba-993a6d77406c |
| Block rebooting machine in Safe Mode (preview) | 33ddedf1-c6e0-47cb-833e-de6133960387 |
| Block untrusted/unsigned processes from USB | b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4 |
| Block copied/impersonated system tools (preview) | c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb |
| Block Webshell creation for Servers | a8f5898e-1dc8-49a9-9878-85004b8a61e6 |
| Block Win32 API calls from Office macros | 92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b |
| Use advanced protection against ransomware | c1db55ab-c21a-4637-bb3f-a12568109d35 |

---

## Mature alternatives (maintained frameworks that do this round-trip for you)
- **IntuneManagement** (Micke-K) — GUI export/import/migrate incl. endpoint security + assignments.
- **Microsoft365DSC** — declarative, drift-detecting config-as-code.
- **IntuneCD** — pipeline backup/deploy.

