function Count-LocalObjects {
    @{
        deviceConfigurationsCount  = (Get-ChildItem -Path ./deviceConfigurations).Count
        configurationPoliciesCount = (Get-ChildItem -Path ./configurationPolicies).Count
        policySetsCount            = (Get-ChildItem -Path ./policySets).Count
    }
}
