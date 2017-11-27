$ModulePath = (Get-Module -ListAvailable TervisOracle).ModuleBase
. $ModulePath\Definition.ps1

function Get-HostGroupHostDNSName {
    Param (
        [Parameter(Mandatory,ValueFromPipeline)]$HostGroupName
    )
    process {
        $HostGroup = $HostGroupDefinition | 
        Where-Object Name -EQ $HostGroupName

        if ($HostGroup.HostGroupName) {
            $HostGroup.HostGroupName | Get-HostGroupHostDNSName
        }

        if ($HostGroup.EnvironmentName) {
            foreach ($EnvironmentName in $HostGroup.EnvironmentName) {
                $HostGroup.Host | Get-TervisDNSName -EnvironmentName $EnvironmentName                
            }
        } elseif ($HostGroup.Host) {
            $HostGroup.Host | Get-TervisDNSName
        }
    }
}

function Get-HostGroupHostIPAddress {
    Param (
        [Parameter(Mandatory)]$HostGroupName
    )
    $DNSNames = Get-HostGroupHostDNSName -HostGroupName $HostGroupName

    $DNSRecords = foreach ($DNSName in $DNSNames) {
        Resolve-DnsName -Name $DNSName |
        Where-Object QueryType -EQ "A" 
    }

    $Sorted = $DNSRecords |
    % {[Version]$_.IPAddress } |
    Sort -Unique 
    
    $Sorted | % { $_.ToString() }
}

function Test-OracleCNAME {
    $OracleCNAMEs = Get-OracleCNAME
    foreach ($CNAME in $OralceCNAMEs) {
        Resolve-DnsName -Name $CNAME -Type CNAME
    }
}

function Get-HostGroupCNAMEToDNSAMapping {
    Param (
        [Parameter(Mandatory)]$HostGroupName
    )
    $DNSNames = Get-HostGroupHostDNSName -HostGroupName $HostGroupName

    $DNSNames |
    % { Resolve-DnsName -Name $_ -Type CNAME } |
    Select-Object -Property Name, NameHost
}