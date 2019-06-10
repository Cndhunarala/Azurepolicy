#Connect-AzureRmAccount


#Register-AzureRmResourceProvider -ProviderNamespace 'Microsoft.PolicyInsights'
Get-AzureRmResourceGroup | Format-Table ResourceGroupName,Location
$resourcenumber = Read-Host "Enter Number of ResourceGroups you want to apply Policies"
$policyresourceoutputarray = @()
for($i=0; $i -lt $resourcenumber; $i++)
{
$increment++
$resourcevalue = Read-Host "Enter ResourceGroup Name $increment"
if($resourcevalue -ne '')
{
 $policyresourceoutputarray +=$resourcevalue
}
}
$resourceout = @()
$approvedvnetnames = @()
$notallowedtypearray = @()
foreach($resourceinput in $policyresourceoutputarray)
{
Write-Output "Applying Policies on ResourceGroup: $resourceinput"
 $rg = Get-AzureRmResourceGroup -Name $resourceinput
 if($resourceinput -ne '')
 {
 $resourceout += "$resourceinput,"
 }
#Audit Log
        
        $definition = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/7f89b1eb-583c-429a-8828-af049802c1d9
        New-AzureRmPolicyAssignment -name "Audit diagnostics" -PolicyDefinition $definition -PolicyParameter '{"listOfResourceTypes":{"value":["Microsoft.Cache/Redis","Microsoft.Compute/virtualmachines"]}}' -Scope $rg.ResourceId
        Write-Output "Successfully created Audit log --- $resourceinput"
        
        #output
        $auditoutputfile = "Created Audit log --- $resourceout"
#Not allowed resource types

       
        
            $definition = New-AzureRmPolicyDefinition -Name "not-allowed-resourcetypes" -DisplayName "Not allowed resource types" -description "This policy enables you to specify the resource types that your organization cannot deploy." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/not-allowed-resourcetypes/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/not-allowed-resourcetypes/azurepolicy.parameters.json' -Mode All
            $definition
            $assignment = New-AzureRmPolicyAssignment -Name "not-allowed-resourcetypes" -Scope $rg.ResourceId  -listOfResourceTypesNotAllowed  'Microsoft.Storage/locations','Microsoft.Network/expressRouteCircuits','Microsoft.Network/expressRouteGateways','Microsoft.Compute/availabilitySets','Microsoft.Compute/disks','Microsoft.Compute/locations','Microsoft.Compute/virtualMachineScaleSets','Microsoft.Consumption/CostTags','Microsoft.Consumption/Tags','microsoft.insights/activityLogAlerts' -PolicyDefinition $definition
            $assignment
            
            Write-Output "Successfully created Not allowed resource types"
            #output
            $notallowedresourceoutfile = "Created Not allowed resource types"
            
        
        
        
#Apply tag and its default value
        
# Create the Policy Definition (Subscription scope)
        $definition = New-AzureRmPolicyDefinition -Name 'allowed-custom-images' -DisplayName 'Approved VM images' -description 'This policy governs the approved VM images' -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/apply-default-tag-value/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/apply-default-tag-value/azurepolicy.parameters.json' -Mode All

# Set the Policy Parameter (JSON format)
        
        $policyparam = '{ "tagName": { "value": "Azuretag" }, "tagValue": { "value": "Azuretag" } }'
# Create the Policy Assignment
        $assignment = New-AzureRmPolicyAssignment -Name 'apply-default-tag-value' -DisplayName 'Apply tag and its default value Assignment' -Scope $rg.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam
        Write-Output "Successfully created Apply tag and its value"
        #output
        $tagoutfile = "Created Apply tag and its value --- $resourceout -- TagName:AzureTag"



#Allowed SKU for storagge accounts and virtual machines

        
        $policydefinitions = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/PolicyInitiatives/skus-for-multiple-types/azurepolicyset.definitions.json"
        $policysetparameters = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/PolicyInitiatives/skus-for-multiple-types/azurepolicyset.parameters.json"
        $policyset= New-AzureRmPolicySetDefinition -Name "skus-for-multiple-types" -DisplayName "Allowed SKUs for Storage Accounts and Virtual Machines" -Description "This policy allows you to speficy what skus are allowed for storage accounts and virtual machines" -PolicyDefinition $policydefinitions -Parameter $policysetparameters 
        #$getstoragedetails = Get-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName
        #$getsku = $getstoragedetails.Sku
        #$getskuvalue = $getsku.Name
        New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -Name "skus-for-multiple-types" -Scope $rg.ResourceId  -LISTOFALLOWEDSKUS_1 Standard_A2_v2,Standard_A1_v2,Standard_D1_v2,Standard_D2,Standard_B1s -LISTOFALLOWEDSKUS_2 Standard_LRS,Standard_GRS
        Write-Output "Successfully created Allowed SKUS for storage account and virtual machines"
        #output
        $storagevmoutfile = "Created Allowed SKUS for storage account and virtual machines --- Standard_A2_v2,Standard_A1_v2,Standard_D1_v2,Standard_D2,Standard_B1s & StandardLRS,StandardGRS"
#Audit non-managed-disk-vm


        $definition = New-AzureRmPolicyDefinition -Name "audit-non-managed-disk-vm" -DisplayName "Create VM using Managed Disk" -description "Create VM using Managed Disk" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-non-managed-disk-vm/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/audit-non-managed-disk-vm/azurepolicy.parameters.json' -Mode All
        $definition
        $assignment = New-AzureRmPolicyAssignment -Name "audit-non-managed-disk-vm" -Scope $rg.ResourceId  -PolicyDefinition $definition
        $assignment
        Write-Output "Successfully Created Audit-non-managed-disk-vm"
        #output
        $nonmanagedoutfile = "Created Audit-non-managed-disk-vm ---- $resourceout"
#Allow storage account SKUS

        
        $definition = New-AzureRmPolicyDefinition -Name "allowed-storageaccount-sku" -DisplayName "Allowed storage account SKUs" -description "This policy enables you to specify a set of storage account SKUs that your organization can deploy." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-storageaccount-sku/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-storageaccount-sku/azurepolicy.parameters.json' -Mode All
        $definition
        $assignment = New-AzureRmPolicyAssignment -Name "allowed-storageaccount-sku" -Scope $rg.ResourceId  -listOfAllowedSKUs Standard_LRS,Standard_GRS  -PolicyDefinition $definition
        $assignment
        Write-Output "Successfully created Allow storage account SKUS"
        #output
        $storageoutfile = "Created Allow storage account SKUS --- StandardLRS,StandardGRS"

#Allow custom VM image

        
        $definition = New-AzureRmPolicyDefinition -Name "custom-image-from-rg" -DisplayName "Allow custom VM image from a Resource Group" -description "This policy allows only usage of images from a resource group" -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/custom-image-from-rg/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/custom-image-from-rg/azurepolicy.parameters.json' -Mode All
        $definition
        $assignment = New-AzureRmPolicyAssignment -Name "custom-image-from-rg" -Scope $rg.ResourceId  -resourceGroupName $rg -PolicyDefinition $definition
        $assignment
        Write-Output "Successfully created Allow custom VM image policy"
        #output
        $customvmoutfile = "Created Allow custom VM image policy --- $resourceout "
#Allowed locations


        
   
        # Create the Policy Definition (Subscription scope)
        $definition = New-AzureRmPolicyDefinition -Name "allowed-locations" -DisplayName "Allowed locations" -description "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/built-in-policy/allowed-locations/azurepolicy.parameters.json' -Mode Indexed
        # Set the scope to a resource group; may also be a resource, subscription, or management group
        $scope = Get-AzureRmResourceGroup -Name $rg.ResourceGroupName
        # Set the Policy Parameter (JSON format)
        $policyparam = '{ "listOfAllowedLocations": { "value": ["EastUS"] } }'
        # Create the Policy Assignment
        $assignment = New-AzureRmPolicyAssignment -Name 'allowed-locations-assignment' -DisplayName 'Allowed locations Assignment' -Scope $scope.ResourceId -PolicyDefinition $definition -PolicyParameter $policyparam
        Write-Output "Successfully created Allowed Locations Policy"
        #output
        $allowedlocationoutfile = "Created Allowed Locations Policy -- AllowedLocation:EastUs"
                

#Audit SQL server audit settings

        $definition = Get-AzureRmPolicyDefinition -Id /providers/Microsoft.Authorization/policyDefinitions/a6fb4358-5bf4-4ad7-ba82-2cd2f41ce5e9

        New-AzureRmPolicyAssignment -name "SQL Audit audit" -PolicyDefinition $definition -PolicyParameter '{"setting": {"value":"enabled"}}' -Scope $rg.ResourceId
        #output
        $Auditsqloutfile = "Created Audit SQL server audit settings -- $resourceout "

#Billing tags policy initiative
        $policydefinitions = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/PolicyInitiatives/multiple-billing-tags/azurepolicyset.definitions.json"
        $policysetparameters = "https://raw.githubusercontent.com/Azure/azure-policy/master/samples/PolicyInitiatives/multiple-billing-tags/azurepolicyset.parameters.json"

        $policyset= New-AzureRmPolicySetDefinition -Name "multiple-billing-tags" -DisplayName "Billing Tags Policy Initiative" -Description "Specify cost Center tag and product name tag" -PolicyDefinition $policydefinitions -Parameter $policysetparameters

        New-AzureRmPolicyAssignment -PolicySetDefinition $policyset -Name "multiple-billing-tags" -Scope $rg.ResourceId -costCenterValue "CostTag" -productNameValue "101"
        #output
        $Billingoutfile = "Created Billing tags policy initiative -- $resourceout"
#Allowed load balancer SKUs

        $definition = New-AzureRmPolicyDefinition -Name "load-balancer-skus" -DisplayName "Allowed Load Balancer SKUs" -description "This policy enables you to specify a set of load balancer SKUs that your organization can deploy." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/load-balancer-skus/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Network/load-balancer-skus/azurepolicy.parameters.json' -Mode All
        $definition
        $assignment = New-AzureRmPolicyAssignment -Name "load-balancer-skus" -Scope $rg.ResourceId  -listOfAllowedSKUs standard -PolicyDefinition $definition
        $assignment
        #output
        $loadbalanceroutfile = "Created Allowed load balancer SKUs -- $resourceout"

#Not allowed VM extensions
        $definition = New-AzureRmPolicyDefinition -Name "not-allowed-vmextension" -DisplayName "Not allowed VM Extensions" -description "This policy governs which VM extensions that are explicitly denied." -Policy 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/not-allowed-vmextension/azurepolicy.rules.json' -Parameter 'https://raw.githubusercontent.com/Azure/azure-policy/master/samples/Compute/not-allowed-vmextension/azurepolicy.parameters.json' -Mode All
        $definition
        $assignment = New-AzureRmPolicyAssignment -Name "not-allowed-vmextension" -Scope $rg.ResourceId  -notAllowedExtensions "Azure Pipelines Agent" -PolicyDefinition $definition
        $assignment
        #output
        $vmextensionoutfile = "Created Not allowed VM extensions --- $resourceout -- Extension:Azure Pipelines Agent "

}

Write-Output "------Policy Validation------"
$subscriptionid = Get-AzureRmSubscription
$defination = Get-AzureRmPolicyDefinition | Where-Object  {$_.SubscriptionId -eq $subscriptionid.Id} 
$definationoutput=$defination.Properties.displayName
        
$path="C:\policyoutfile.txt"
$test = Test-Path -Path $path
if($test -eq "True")
{
    Remove-Item $path
    $addingdata  = Add-Content 'C:\policyoutfile.txt'  "Azure Policies Applied on following ResourceGroups: $resourceout" ,"----Azure General----:" ,$notallowedresourceoutfile,$allowedlocationoutfile,$allowedoutfile,"----Azure Compute:----",$nonmanagedoutfile,$customvmoutfile,$vmextensionoutfile,"----Azure Network:----" ,$loadbalanceroutfile,"----Azure Storage:----" ,$storagevmoutfile,$storageoutfile,"----Azure Tags:----",$tagoutfile,$Billingoutfile,"----Azure Monitoring:----",$auditoutputfile,"----Policy Validation----",$definationoutput
}
else
{
    $addingdata  = Add-Content 'C:\policyoutfile.txt'  "Azure Policies Applied on following ResourceGroups: resourceout" ,"----Azure General----:" ,$notallowedresourceoutfile,$allowedlocationoutfile,$allowedoutfile,"----Azure Compute:----",$nonmanagedoutfile,$customvmoutfile,$vmextensionoutfile,"----Azure Network:----" ,$loadbalanceroutfile,"----Azure Storage:----" ,$storagevmoutfile,$storageoutfile,"----Azure Tags:----",$tagoutfile,$Billingoutfile,"----Azure Monitoring:----",$auditoutputfile,"----Policy Validation----",$definationoutput
}       




$SourceFile = 'C:\policyoutfile.txt'
$TargetFile = 'C:\policyoutfile.html'
$File = Get-Content $SourceFile
$FileLine = @()
$heading = "Netenrich Azure Policy Management"
Foreach ($Line in $File) {
$MyObject = New-Object -TypeName PSObject
Add-Member -InputObject $MyObject -Type NoteProperty -Name $heading -Value $Line
$FileLine += $MyObject
}
$FileLine | ConvertTo-Html -Property $heading  | Out-File $TargetFile
start $TargetFile  
 
