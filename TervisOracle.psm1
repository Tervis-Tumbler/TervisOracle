$OracleAppliationCNAMEHost = @"
apexweblogic
discoverer
ebsias
ebsodbee
infadac
obiaodbee
obieeweblogic
rpias
rpodbee
rpweblogic
soaodbee
soaweblogic
obiapp
"@ -split "`r`n"

$OracleInfrastructureCNAMEHost = @"
OraDBARMT
RemoteDesktopWebAccess
"@ -split "`r`n"

$OracleZetaCNAMEHost = @"
ebsias
ebsodbee
rpias
rpodbee
rpweblogic
"@ -split "`r`n"

$OracleContractorUsedResourcesOutsideOracleSystems = @"
rdbrocker2012r2
rdgateway2012r2
INF-RDWebAcc01
TFS2012
SharePoint2007
TrackIT
INF-DC1
INF-DC2
INF-DC3
"@ -split "`r`n"

$EnvironmentsWithOracleApplications = "Delta","Epsilon","Production"

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

function Get-TervisDNSName {
    param (
        [Parameter(Mandatory,ValueFromPipeline)]$Host,
        $EnvironmentName
    )
    begin {
        if ( -not $Script:ADDomain) { 
            $Script:ADDomain = Get-ADDomain
        }
    }
    process {
        "$Host$(if($EnvironmentName){".$EnvironmentName"}).$($Script:ADDomain.DNSRoot)"
    }
}

function Get-OracleManagedServiceHostNeedingAccessToDNSName {
    $OracleCNAME = Get-OracleCNAME
}

function Get-OracleIPAddresses {
    $OracleCNAMEs = Get-OracleCNAME
    foreach ($CNAME in $OracleCNAMEs) {
        Resolve-DnsName -Name $CNAME |
        Where-Object QueryType -EQ "A" |
        Select-Object -ExpandProperty IPAddress
    }
}

function Get-OracleCNAMEToDNSAMapping {
    $OracleCNAME = Get-OracleCNAME

    $OracleCNAME |
    % { Resolve-DnsName -Name $_ -Type CNAME } |
    Select-Object -Property Name, NameHost
}