Describe "Format-PolicyFileName" {
    BeforeAll {
        . "$PSScriptRoot/../private/Format-PolicyFileName.ps1"
    }
    Context "When formatting a policy name" {
        It "Should remove invalid characters" {
            # Arrange
            $policyName = 'Policy\Name:*?\"<>|'

            # Act
            $result = Format-PolicyFileName -policyName $policyName

            # Assert
            $result -eq "PolicyName"
        }
    }

    Context "When formatting a policy name without invalid characters" {
        It "Should return the same policy name" {
            # Arrange
            $policyName = "ValidPolicyName"

            # Act
            $result = Format-PolicyFileName -policyName $policyName

            # Assert
            $result -eq $policyName
        }
    }
}