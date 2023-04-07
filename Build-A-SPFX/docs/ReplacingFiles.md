
# Changes for SharePoint Framework  project to support running the local workbench from within a Docker container. The following files needs the change.

The main problem is that by default the development web server running inside the container is mapped to localhost. Localhost isn't however exposed outside of the container, so it needs to be changed to 0.0.0.0. You do this by adjusting the hostname property, like you did. This has however a side-effect: Windows doesn't know how to handle 0.0.0.0. This is why you need to patch the node_modules\@microsoft\spfx-heft-plugins\lib\plugins\webpackConfigurationPlugin\WebpackConfigurationGenerator.js:393 file to:

const debugBaseUrl = `${serveConfig.https ? 'https' : 'http'}://localhost:${serveConfig.port || 4321}/${distFolderName}/`;

The trick here is to force the debugBaseUrl which is exposed on the host, to point to localhost instead of 0.0.0.0 which it would get from the hostname property by default.

One final tip: when running the gulp serve command, add to it --nobrowser. Since you're running the command inside a container which doesn't have a web browser, the command is throwing an error. You can avoid it by adding the --nobrowser switch to the command. I hope this helps.