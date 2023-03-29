$adminAppId = "96f226e5-bf28-4ed2-ab7f-9163edf691c9"; #admin-app TODO to replace
$clientAppId = "7c09c877-8503-4246-890c-a036cd382792"; #client-app

$tenantPrefix = "sriitdev2"; # replace with your tenant id TODO to replace
$tenantName = $tenantPrefix +".onmicrosoft.com";
$spoTenantName = "https://" + $tenantPrefix + ".sharepoint.com";

# site to apply granular permission, 
# it can be repeated for more than one sites
$site2apply = "https://sriitdev2.sharepoint.com/sites/AD_profileinfo"

$password = (ConvertTo-SecureString -AsPlainText 'pass@word1' -Force)

$adminConn = Connect-PnPOnline -Url $spoTenantName -ClientId $adminAppId -CertificatePath './pnpSites-Selected.pfx' -CertificatePassword $password  -Tenant $tenantName

### GET
$perms = Get-PnPAzureADAppSitePermission -Site $site2apply

# #### GRANT
# # Grant-PnPAzureADAppSitePermission -AppId $clientAppId -DisplayName "clientApp" -Permissions Read -Site $site2apply -Verbose

# #### SET
Set-PnPAzureADAppSitePermission -Site $site2apply -Permissions Write -PermissionId $perms.Id

# #### REVOKE
# Revoke-PnPAzureADAppSitePermission -Site $site2apply -PermissionId $perms.Id