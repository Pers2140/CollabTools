
# Setting Up SPFX 

## Quicklinks

- [Installing WSL2 and Docker](docs/InstallingWSL2%26Docker.md)
- [Replacing troublesome files/troubleshooting](docs/ReplacingFiles.md)

## 
<span style="background-color: #000;color:red">before starting please run the InstallWSL2&Docker PowerShell script to install the prerequisites. If this fails to run please follow the steps in [Installing WSL2 and Docker](docs/InstallingWSL2%26Docker.md)</span>

<span style="background-color: #000;color:yellow">This process is currently only working in Chrome </span>
## Creating Docker container

<p>
Navigate to your project folder. The command below will passthrough the current 
folder to your container and expose the necessary ports for SPFX workbench.
<p>

</br>

    <!-- persistent container -->
    docker run -it --name spfx-helloworld -v ${PWD}:/usr/app/spfx -p 4321:4321 -p 35729:35729 m365pnp/spfx:1.16.0
</br>

     <!-- temporary container - will self destruct when closed -->
    docker run --rm -it --name spfx-helloworld -v ${PWD}:/usr/app/spfx -p 4321:4321 -p 35729:35729 m365pnp/spfx:1.16.0

## Replacing troublesome files

<p><b>After running yo @microsoft/sharepoint </b> to build your project files.</p>

run <span style="background-color:#012456;color:white">./files_to_replace/replacefiles.ps1</span> in a separate tab on your local machine - not inside the container.

</br>

## Starting Workbench Server
<p>Add the certificate used by SPFx to the Trusted Root Certification Authorities store for the current user.<p>

    gulp trust-dev-cert

<p>Start server ... this will take awhile <p>

    gulp serve --nobrowser

## Sharepoint workbench

<p>
    Visit <a href ="https://sriintl.sharepoint.us/_layouts/15/workbench.aspx">https://sriintl.sharepoint.us/_layouts/15/workbench.aspx</a>.
    This is currently only working in Chrome
<p>

## Warning error -<span style="background-color:white;color:black">Your web part will not appear in the toolbox. Please make sure "gulp serve" is running in a web part project. Please refresh the page once "gulp serve" is running. </span>

<p>Temporary solution:  Visit <a href ="https://localhost:4321/temp/manifests.js">https://localhost:4321/temp/manifests.js</a> in a separate tab <>

## SPFx Fast Serve Tool
<p>A command line utility, which modifies your SharePoint Framework solution, so that it runs continuous serve command as fast as possible. <span style="background-color: #000;color:yellow">Also supports live reload! </span><p>
How to use

1. Install `spfx-fast-serve` globally using npm:
    ```
    npm install spfx-fast-serve -g
    ```

2. Open a command line in a folder with your SharePoint Framework solution you want to speed up.

3. Run `spfx-fast-serve` and follow instructions. In most cases, you shouldn't do anything specific and the CLI "just works".

4. Run `npm install`.

5. Run `npm run serve` and enjoy the incredible speed of the `serve` command!



## Deploying your app

<p>If gulp serve is still running, stop it from running by selecting CTRL+C.</p>
<p>Open package-solution.json from the config folder.

The package-solution.json file defines the package metadata as shown in the following code:</p>

        {
    "$schema": "https://developer.microsoft.com/json-schemas/spfx-build/package-solution.schema.json",
    "solution": {
        "name": "mysolution-client-side-solution",
        "id": "ee1a495d-c7bb-499b-bd71-728aaeb79cd2",
        "version": "1.0.0.0",
        "includeClientSideAssets": true,
        "skipFeatureDeployment": true,
        "isDomainIsolated": false,
        "developer": {
        "name": "",
        "websiteUrl": "",
        "privacyUrl": "",
        "termsOfUseUrl": "",
        "mpnId": "Undefined-1.14.0"
        },
        "metadata": {
        "shortDescription": {
            "default": "mysolution description"
        },
        "longDescription": {
            "default": "mysolution description"
        },
        "screenshotPaths": [],
        "videoUrl": "",
        "categories": []
        },
        "features": [
        {
            "title": "mysolution Feature",
            "description": "The feature that activates elements of the mysolution solution.",
            "id": "d72e47b2-d5a2-479f-9f9a-85e1e7472dee",
            "version": "1.0.0.0"
        }
        ]
    },
    "paths": {
        "zippedPackage": "solution/mysolution.sppkg"
    }
    }

</br>
<p>In the console window, enter the following command to bundle your client-side solution:</p>

    gulp bundle

<p>In the console window, enter the following command to package your client-side solution that contains the web part:</p>

    gulp package-solution

## The command creates the following package: ./sharepoint/solution/helloworld-webpart.sppkg.