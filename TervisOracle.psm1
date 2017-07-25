$OracleAppliationCNAMELeaf = @"
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
"@ -split "`r`n"

$OracleInfrastructureCNAMELeaf = @"
DataLoadClassic
OraDBARMT
RemoteDesktopWebAccess
"@

$OracleZetaCNAMELeaf = @"
ebsias
ebsodbee
rpias
rpodbee
rpweblogic
"@

$OracleContractorUsedResourcesOutsideOracleSystems = @"
rdbrocker2012r2
rdgateway2012r2
"@

$EnvironmentsWithOracleApplications = "Delta","Epsilon","Production"

function Get-OracleCNAME {
    $ADDomain = Get-ADDomain

    foreach ($Environment in $EnvironmentsWithOracleApplications) {
        foreach ($CNAMELeaf in $OracleAppliationCNAMELeaf) {
            "$CNAMELeaf.$Environment.$($ADDomain.DNSRoot)"
        }
    }
}

function Test-OracleCNAME {
    $OracleCNAMEs = Get-OracleCNAME
    foreach ($CNAME in $OralceCNAMEs) {
        Resolve-DnsName -Name $CNAME -Type CNAME
    }
}

function Get-OracleIPAddresses {
    $OracleCNAMEs = Get-OracleCNAME
    foreach ($CNAME in $OralceCNAMEs) {
        Resolve-DnsName -Name $CNAME |
        Where-Object QueryType -EQ "A" |
        Select-Object -ExpandProperty IPAddress
    }
}