function Count-IntuneObjects {
    @{
        deviceConfigurationsCount  = (Invoke-GMSIntuneGraphRequest -Endpoint deviceConfigurations -Method GET).Count
        configurationPoliciesCount = (Invoke-GMSIntuneGraphRequest -Endpoint configurationPolicies -Method GET -Paging).Count
        policySetsCount            = (Invoke-GMSIntuneGraphRequest -Endpoint policySets -Method GET -Paging).Count
    }
}
