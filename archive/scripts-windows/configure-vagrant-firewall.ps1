#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Configure Windows Firewall rules for Vagrant Ruby to eliminate UAC prompts

.DESCRIPTION
    This script creates permanent firewall rules for Vagrant's Ruby interpreter,
    allowing vagrant-goodhosts to function without requiring Administrator privileges
    on subsequent runs.

.NOTES
    File Name      : configure-vagrant-firewall.ps1
    Author         : IACT DevBox
    Prerequisite   : PowerShell 5.1+ (Run as Administrator - ONE TIME ONLY)
    Version        : 1.0.0

.EXAMPLE
    .\configure-vagrant-firewall.ps1
    Adds firewall rules for Vagrant Ruby

.EXAMPLE
    .\configure-vagrant-firewall.ps1 -Remove
    Removes firewall rules for Vagrant Ruby
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Remove,
    
    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# =============================================================================
# CONFIGURATION
# =============================================================================

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"

# Colors
$ColorSuccess = "Green"
$ColorError = "Red"
$ColorWarning = "Yellow"
$ColorInfo = "Cyan"

# Firewall rule configuration
$RuleBaseName = "Vagrant Ruby (IACT DevBox)"
$RuleInboundName = "$RuleBaseName - Inbound"
$RuleOutboundName = "$RuleBaseName - Outbound"

# Vagrant Ruby paths (common locations)
$VagrantPaths = @(
    "C:\HashiCorp\Vagrant\embedded\bin\ruby.exe",
    "C:\Program Files\HashiCorp\Vagrant\embedded\bin\ruby.exe",
    "$env:ProgramFiles\HashiCorp\Vagrant\embedded\bin\ruby.exe",
    "${env:ProgramFiles(x86)}\HashiCorp\Vagrant\embedded\bin\ruby.exe"
)

# =============================================================================
# FUNCTIONS
# =============================================================================

function Write-Header {
    param([string]$Text)
    Write-Host ""
    Write-Host "=" * 70 -ForegroundColor $ColorInfo
    Write-Host "  $Text" -ForegroundColor $ColorInfo
    Write-Host "=" * 70 -ForegroundColor $ColorInfo
    Write-Host ""
}

function Write-Success {
    param([string]$Text)
    Write-Host "[OK] $Text" -ForegroundColor $ColorSuccess
}

function Write-Error-Message {
    param([string]$Text)
    Write-Host "[ERROR] $Text" -ForegroundColor $ColorError
}

function Write-Warning-Message {
    param([string]$Text)
    Write-Host "[WARN] $Text" -ForegroundColor $ColorWarning
}

function Write-Info {
    param([string]$Text)
    Write-Host "[INFO] $Text" -ForegroundColor $ColorInfo
}

function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Find-VagrantRuby {
    Write-Info "Searching for Vagrant Ruby interpreter..."
    
    foreach ($path in $VagrantPaths) {
        if (Test-Path $path) {
            Write-Success "Found: $path"
            return $path
        }
    }
    
    Write-Warning-Message "Vagrant Ruby not found in common locations"
    Write-Info "Checking PATH environment variable..."
    
    # Try to find ruby.exe in PATH
    $rubyInPath = Get-Command ruby.exe -ErrorAction SilentlyContinue
    if ($rubyInPath) {
        $rubyPath = $rubyInPath.Source
        # Verify it's Vagrant's Ruby
        if ($rubyPath -like "*Vagrant*" -or $rubyPath -like "*vagrant*") {
            Write-Success "Found in PATH: $rubyPath"
            return $rubyPath
        }
    }
    
    return $null
}

function Test-FirewallRuleExists {
    param([string]$RuleName)
    
    try {
        $rule = Get-NetFirewallRule -DisplayName $RuleName -ErrorAction SilentlyContinue
        return ($null -ne $rule)
    }
    catch {
        return $false
    }
}

function Add-VagrantFirewallRules {
    Write-Header "Adding Vagrant Ruby Firewall Rules"
    
    # Check Administrator
    if (-not (Test-Administrator)) {
        Write-Error-Message "This script must be run as Administrator"
        Write-Info "Right-click PowerShell and select 'Run as Administrator'"
        return $false
    }
    
    Write-Success "Running as Administrator"
    
    # Find Vagrant Ruby
    $rubyPath = Find-VagrantRuby
    
    if (-not $rubyPath) {
        Write-Error-Message "Could not find Vagrant Ruby interpreter"
        Write-Info ""
        Write-Info "Please ensure Vagrant is installed."
        Write-Info "If Vagrant is installed in a custom location, you can manually add"
        Write-Info "the firewall rule by running:"
        Write-Info ""
        Write-Info '  New-NetFirewallRule -DisplayName "Vagrant Ruby" \'
        Write-Info '    -Direction Inbound \'
        Write-Info '    -Program "C:\Your\Path\To\ruby.exe" \'
        Write-Info '    -Action Allow \'
        Write-Info '    -Profile Private,Domain'
        Write-Info ""
        return $false
    }
    
    Write-Info ""
    Write-Info "Ruby path: $rubyPath"
    Write-Info ""
    
    # Check if rules already exist
    $inboundExists = Test-FirewallRuleExists -RuleName $RuleInboundName
    $outboundExists = Test-FirewallRuleExists -RuleName $RuleOutboundName
    
    if ($inboundExists -and $outboundExists -and -not $Force) {
        Write-Warning-Message "Firewall rules already exist"
        Write-Info ""
        Write-Info "Existing rules:"
        Write-Info "  - $RuleInboundName"
        Write-Info "  - $RuleOutboundName"
        Write-Info ""
        Write-Info "To recreate rules, run with -Force flag"
        return $true
    }
    
    # Remove existing rules if Force flag is set
    if ($Force -and ($inboundExists -or $outboundExists)) {
        Write-Info "Force flag detected, removing existing rules..."
        Remove-VagrantFirewallRules -Silent
    }
    
    # Create Inbound rule
    Write-Info "Creating Inbound firewall rule..."
    try {
        $inboundRule = New-NetFirewallRule `
            -DisplayName $RuleInboundName `
            -Description "Allows Vagrant Ruby to accept inbound connections on private networks (IACT DevBox)" `
            -Direction Inbound `
            -Program $rubyPath `
            -Action Allow `
            -Profile Private,Domain `
            -Enabled True `
            -ErrorAction Stop
        
        Write-Success "Inbound rule created: $RuleInboundName"
    }
    catch {
        Write-Error-Message "Failed to create inbound rule"
        Write-Error-Message $_.Exception.Message
        return $false
    }
    
    # Create Outbound rule
    Write-Info "Creating Outbound firewall rule..."
    try {
        $outboundRule = New-NetFirewallRule `
            -DisplayName $RuleOutboundName `
            -Description "Allows Vagrant Ruby to make outbound connections on private networks (IACT DevBox)" `
            -Direction Outbound `
            -Program $rubyPath `
            -Action Allow `
            -Profile Private,Domain `
            -Enabled True `
            -ErrorAction Stop
        
        Write-Success "Outbound rule created: $RuleOutboundName"
    }
    catch {
        Write-Error-Message "Failed to create outbound rule"
        Write-Error-Message $_.Exception.Message
        
        # Clean up inbound rule if outbound failed
        if ($inboundRule) {
            Write-Info "Cleaning up inbound rule..."
            Remove-NetFirewallRule -DisplayName $RuleInboundName -ErrorAction SilentlyContinue
        }
        
        return $false
    }
    
    # Verify rules were created
    Write-Info ""
    Write-Info "Verifying firewall rules..."
    
    if ((Test-FirewallRuleExists -RuleName $RuleInboundName) -and 
        (Test-FirewallRuleExists -RuleName $RuleOutboundName)) {
        Write-Success "Firewall rules verified successfully"
        
        Write-Info ""
        Write-Info "=========================================="
        Write-Info "  Firewall Configuration Complete!"
        Write-Info "=========================================="
        Write-Info ""
        Write-Info "Vagrant Ruby firewall rules have been added."
        Write-Info ""
        Write-Info "Benefits:"
        Write-Info "  ✓ No more UAC prompts when running 'vagrant up'"
        Write-Info "  ✓ vagrant-goodhosts works without Administrator privileges"
        Write-Info "  ✓ Automatic hosts file updates for adminer.devbox"
        Write-Info ""
        Write-Info "Next steps:"
        Write-Info "  1. Open a NEW PowerShell window (no admin required)"
        Write-Info "  2. Run: vagrant up adminer"
        Write-Info "  3. No more UAC prompts! ✨"
        Write-Info ""
        Write-Info "To view rules:"
        Write-Info "  Get-NetFirewallRule -DisplayName '*Vagrant Ruby*' | Format-List"
        Write-Info ""
        Write-Info "To remove rules:"
        Write-Info "  .\configure-vagrant-firewall.ps1 -Remove"
        Write-Info ""
        Write-Info "=========================================="
        Write-Info ""
        
        return $true
    }
    else {
        Write-Warning-Message "Could not verify firewall rules"
        return $false
    }
}

function Remove-VagrantFirewallRules {
    param(
        [switch]$Silent
    )
    
    if (-not $Silent) {
        Write-Header "Removing Vagrant Ruby Firewall Rules"
    }
    
    # Check Administrator
    if (-not (Test-Administrator)) {
        Write-Error-Message "This script must be run as Administrator"
        return $false
    }
    
    if (-not $Silent) {
        Write-Success "Running as Administrator"
    }
    
    # Check if rules exist
    $inboundExists = Test-FirewallRuleExists -RuleName $RuleInboundName
    $outboundExists = Test-FirewallRuleExists -RuleName $RuleOutboundName
    
    if (-not $inboundExists -and -not $outboundExists) {
        if (-not $Silent) {
            Write-Warning-Message "No firewall rules found"
            Write-Info "Nothing to remove"
        }
        return $true
    }
    
    # Remove Inbound rule
    if ($inboundExists) {
        if (-not $Silent) {
            Write-Info "Removing Inbound rule..."
        }
        try {
            Remove-NetFirewallRule -DisplayName $RuleInboundName -ErrorAction Stop
            if (-not $Silent) {
                Write-Success "Inbound rule removed"
            }
        }
        catch {
            Write-Error-Message "Failed to remove inbound rule"
            Write-Error-Message $_.Exception.Message
            return $false
        }
    }
    
    # Remove Outbound rule
    if ($outboundExists) {
        if (-not $Silent) {
            Write-Info "Removing Outbound rule..."
        }
        try {
            Remove-NetFirewallRule -DisplayName $RuleOutboundName -ErrorAction Stop
            if (-not $Silent) {
                Write-Success "Outbound rule removed"
            }
        }
        catch {
            Write-Error-Message "Failed to remove outbound rule"
            Write-Error-Message $_.Exception.Message
            return $false
        }
    }
    
    if (-not $Silent) {
        Write-Info ""
        Write-Success "Firewall rules removed successfully"
        Write-Info ""
        Write-Info "Note: You will now receive UAC prompts when running 'vagrant up'"
        Write-Info "To add the rules back, run this script without the -Remove flag"
        Write-Info ""
    }
    
    return $true
}

function Show-FirewallStatus {
    Write-Header "Vagrant Ruby Firewall Status"
    
    # Find Vagrant Ruby
    $rubyPath = Find-VagrantRuby
    
    if ($rubyPath) {
        Write-Success "Vagrant Ruby found: $rubyPath"
    }
    else {
        Write-Warning-Message "Vagrant Ruby not found"
    }
    
    Write-Info ""
    Write-Info "Firewall Rules:"
    
    # Check Inbound rule
    if (Test-FirewallRuleExists -RuleName $RuleInboundName) {
        Write-Success "  ✓ Inbound rule exists: $RuleInboundName"
        
        $rule = Get-NetFirewallRule -DisplayName $RuleInboundName
        Write-Info "    Status: $($rule.Enabled)"
        Write-Info "    Action: $($rule.Action)"
        Write-Info "    Profile: $($rule.Profile)"
    }
    else {
        Write-Warning-Message "  ✗ Inbound rule not found"
    }
    
    # Check Outbound rule
    if (Test-FirewallRuleExists -RuleName $RuleOutboundName) {
        Write-Success "  ✓ Outbound rule exists: $RuleOutboundName"
        
        $rule = Get-NetFirewallRule -DisplayName $RuleOutboundName
        Write-Info "    Status: $($rule.Enabled)"
        Write-Info "    Action: $($rule.Action)"
        Write-Info "    Profile: $($rule.Profile)"
    }
    else {
        Write-Warning-Message "  ✗ Outbound rule not found"
    }
    
    Write-Info ""
    
    # Recommendation
    $inboundExists = Test-FirewallRuleExists -RuleName $RuleInboundName
    $outboundExists = Test-FirewallRuleExists -RuleName $RuleOutboundName
    
    if ($inboundExists -and $outboundExists) {
        Write-Success "Status: Configured ✓"
        Write-Info ""
        Write-Info "You can run 'vagrant up' without Administrator privileges"
    }
    else {
        Write-Warning-Message "Status: Not Configured"
        Write-Info ""
        Write-Info "To configure, run:"
        Write-Info "  .\configure-vagrant-firewall.ps1"
    }
    
    Write-Info ""
}

# =============================================================================
# MAIN EXECUTION
# =============================================================================

try {
    if ($Remove) {
        # Remove mode
        $result = Remove-VagrantFirewallRules
        if ($result) {
            exit 0
        }
        else {
            exit 1
        }
    }
    else {
        # Add mode (default)
        $result = Add-VagrantFirewallRules
        
        if ($result) {
            Write-Info ""
            Write-Info "To view firewall status, run:"
            Write-Info "  Get-NetFirewallRule -DisplayName '*Vagrant Ruby*'"
            Write-Info ""
            exit 0
        }
        else {
            exit 1
        }
    }
}
catch {
    Write-Error-Message "Unexpected error occurred"
    Write-Error-Message $_.Exception.Message
    Write-Error-Message $_.ScriptStackTrace
    exit 1
}
