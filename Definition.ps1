$HostGroupDefinition =  [PSCustomObject]@{
    Name = "Trevera"
    HostGroupName = "Oracle","ContractorSupportInfrastructure","OracleSupportInfrastructure"
},
[PSCustomObject]@{
    Name = "Helios"
    HostGroupName = "MES","ContractorSupportInfrastructure"
},
[PSCustomObject]@{
    Name = "Oracle"
    HostGroupName = "OracleNonZeta","OracleZeta"
},
[PSCustomObject]@{
    Name = "OracleNonZeta"
    DNSRecordType = "CNAME"
    Host = @"
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
    EnvironmentName = "Delta","Epsilon","Production"
},
[PSCustomObject]@{
    Name = "OracleZeta"
    DNSRecordType = "CNAME"
    Host = @"
ebsias
ebsodbee
rpias
rpodbee
rpweblogic
"@ -split "`r`n"
    EnvironmentName = "Zeta"
},
[PSCustomObject]@{
    Name = "OracleSupportInfrastructure"
    DNSRecordType = "CNAME"
    Host = @"
OraDBARMT
RemoteDesktopWebAccess
"@ -split "`r`n"
    EnvironmentName = "Infrastructure"
},
[PSCustomObject]@{
    Name = "ContractorSupportInfrastructure"
    DNSRecordType = "A"
    Host = @"
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
},
[PSCustomObject]@{
    Name = "MES"
    DNSRecordType = "CNAME"
    Host = @"
MESIIS
MESSQ
"@ -split "`r`n"
    EnvironmentName = "Delta","Epsilon","Production"
}