# Insider People Search Sync Script

## Tool Information:
- Author: darius.persaud@sri.com 
- Language(s): PowerShell
- Dependencies: TODO Add any dependencies here...

## Description:

TODO - Add Description


## Insider Sync Modules

### These modules were built to interact with Sharepoint using the Microsoft Graph API platform
### - All files are currently being uploaded to https://sriitdev2.sharepoint.com/sites/AD_profileinfo/Documents
<br>

## Get-ADPhotos 
<br>

### This module pulls the mail and jpegphoto attribute for each user in Active Directory.
### Then saves the jpeg bytestream as a file named with the email address 
### ex. darius.persaud@sri.com.jpg

<br>

## Get-MSGraph
<br>

### Using MSGraph and a Azure application's client ID and client secret
### we are able to generate a Bearer token to access Sharepoint's directory system.
### This module contains three functions:
<br>

> Get-UserToken - Returns Bearer token using Azure app client id and secret

> Start-FileUpload - Can upload a file to a folder or to the root of a drive

> Start-FolderUpload - Can upload a folder to a specific online folder or to the root of the drive 

###
<br>

## Update-StaffInfo

<br>

### This module connects to active directory in order to pull the required information
### It then stores all the users at SRI as Objects in a JSON file and uploads to Sharepoint

<br>
