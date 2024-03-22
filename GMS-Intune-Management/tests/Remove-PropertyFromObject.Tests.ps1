Describe "Remove-PropertyFromObject" {
    BeforeAll {
        . "$PSScriptRoot/../private/Remove-PropertyFromObject.ps1"
    }
    
    Context "When removing a property from an object" {
        It "Should remove the specified property" {
            # Arrange
            $object = [PSCustomObject]@{
                Property1 = "Value1"
                Property2 = "Value2"
            }
            $property = "Property1"

            # Act
            $result = Remove-PropertyFromObject -object $object -property $property

            # Assert
            $result | Get-Member -Name $property -MemberType NoteProperty | Should -BeNullOrEmpty
        }
    }

    Context "When removing a non-existent property from an object" {
        It "Should not modify the object" {
            # Arrange
            $object = [PSCustomObject]@{
                Property1 = "Value1"
                Property2 = "Value2"
            }
            $property = "NonExistentProperty"

            # Act
            $result = Remove-PropertyFromObject -object $object -property $property

            # Assert
            $result -eq $object | Should -Be $true
        }
    }
}