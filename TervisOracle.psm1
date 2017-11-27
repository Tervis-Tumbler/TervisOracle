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

function Get-OracleCNAME {

    foreach ($Environment in $EnvironmentsWithOracleApplications) {
        $OracleAppliationCNAMEHost | Get-TervisDNSName -EnvironmentName $Environment
    }

    $OracleZetaCNAMEHost | Get-TervisDNSName -EnvironmentName Zeta
    $OracleInfrastructureCNAMEHost | Get-TervisDNSName -EnvironmentName Infrastructure
}

function Test-OracleCNAME {
    $OracleCNAMEs = Get-OracleCNAME
    foreach ($CNAME in $OralceCNAMEs) {
        Resolve-DnsName -Name $CNAME -Type CNAME
    }
}

function Get-OracleManagedServiceHostNeedingAccessToDNSARecord {    
    $OracleContractorUsedResourcesOutsideOracleSystems | Get-TervisDNSName
}

function Get-OracleManagedServiceHostNeedingAccessToDNSName {
    $OracleCNAME = Get-OracleCNAME
}

function Get-OracleIPAddresses {
    $OracleCNAMEs = Get-OracleCNAME
    $DNSRecords = foreach ($CNAME in $OracleCNAMEs) {
        Resolve-DnsName -Name $CNAME |
        Where-Object QueryType -EQ "A" 
    }

    $Sorted = $DNSRecords |
    % {[Version]$_.IPAddress } |
    Sort -Unique 
    
    $Sorted | % { $_.ToString() }
}

function Get-OracleCNAMEToDNSAMapping {
    $OracleCNAME = Get-OracleCNAME

    $OracleCNAME |
    % { Resolve-DnsName -Name $_ -Type CNAME } |
    Select-Object -Property Name, NameHost
}