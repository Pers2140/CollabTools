
Copy-item ./files_to_replace/serve.json ../config
Copy-item ./files_to_replace/WebpackConfigurationGenerator.js ../node_modules\@microsoft\spfx-heft-plugins\lib\plugins\webpackConfigurationPlugin

write-host "`n Finshed replacing files ... `n"

node_modules\@microsoft\spfx-heft-plugins\lib\plugins\webpackConfigurationPlugin
