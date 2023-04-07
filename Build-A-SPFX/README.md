
# Setting Up SPFX 

## Quicklinks

- [Installing WSL2 and Docker](docs/InstallingWSL2%26Docker.md)
- [Replacing troublesome files/troubleshooting](docs/ReplacingFiles.md)
- SPFX fast-serve-tool ... coming soon

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
    docker run -it --name spfx-helloworld -v ${PWD}:/usr/app/spfx -p 4321:4321 -p 35729:35729 m365pnp/spfx
</br>

     <!-- temporary container - will self destruct when closed -->
    docker run --rm -it --name spfx-helloworld -v ${PWD}:/usr/app/spfx -p 4321:4321 -p 35729:35729 m365pnp/spfx

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

<p>Temporary solution:  Visit <a href ="https://localhost:4321/temp/manifests.js">https://localhost:4321/temp/manifests.js</a> in a separate tab <p>