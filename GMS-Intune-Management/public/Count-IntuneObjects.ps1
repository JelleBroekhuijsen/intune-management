function Count-IntuneObjects {
    @{
        deviceConfigurationsCount  = (Invoke-GMSIntuneGraphRequest -Endpoint $($global:GMSIntuneConfigurationObjects | ? GMSObjectType -eq 'deviceConfigurations').ApiEndpoint -Method GET).Count
        configurationPoliciesCount = (Invoke-GMSIntuneGraphRequest -Endpoint $($global:GMSIntuneConfigurationObjects | ? GMSObjectType -eq 'configurationPolicies').ApiEndpoint -Method GET -Paging).Count
        policySetsCount            = (Invoke-GMSIntuneGraphRequest -Endpoint $($global:GMSIntuneConfigurationObjects | ? GMSObjectType -eq 'policySets').ApiEndpoint -Method GET -Paging).Count
    }
}
