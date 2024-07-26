# Install the Azure PowerShell module if not already installed
# Install-Module -Name Az -AllowClobber -Scope CurrentUser

# Connect to Azure
#Connect-AzAccount

# Get all subscriptions in the tenant
$subscriptions = Get-AzSubscription

# Initialize an array to store role assignments
$allRoleAssignments = @()

# Loop through each subscription
foreach ($subscription in $subscriptions) {
    # Set the current subscription context
    Set-AzContext -SubscriptionId $subscription.Id

    # Get role assignments for the current subscription
    $roleAssignments = Get-AzRoleAssignment

    # Add the subscription ID to each role assignment
    foreach ($roleAssignment in $roleAssignments) {
        $roleAssignment | Add-Member -MemberType NoteProperty -Name SubscriptionId -Value $subscription.Id
        $roleAssignment | Add-Member -MemberType NoteProperty -Name SubscriptionName -Value $subscription.Name
        $allRoleAssignments += $roleAssignment
    }
}

# Export all role assignments to a CSV file
$allRoleAssignments | Export-Csv .\roles.csv -NoTypeInformation

Write-Output "Role assignments have been exported"
