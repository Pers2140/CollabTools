"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.WebpackConfigurationGenerator = exports.CONFIG_JSON_SYMBOL = exports.IS_SPFX_WEBPACK_CONFIGURATION_SYMBOL = exports.FILE_LOADER_EXTENSIONS = void 0;
// NodeJS
const path = __importStar(require("path"));
const webpack = __importStar(require("webpack"));
const os = __importStar(require("os"));
const crypto = __importStar(require("crypto"));
// Externals
const lodash_1 = __importDefault(require("lodash"));
const webpack4_module_minifier_plugin_1 = require("@rushstack/webpack4-module-minifier-plugin");
const node_core_library_1 = require("@rushstack/node-core-library");
const set_webpack_public_path_plugin_1 = require("@rushstack/set-webpack-public-path-plugin");
const true_case_path_1 = require("true-case-path");
// Local
const CopyReleaseAssetsPlugin_1 = require("./webpackPlugins/CopyReleaseAssetsPlugin");
const ComponentNamePlugin_1 = require("./webpackPlugins/ComponentNamePlugin");
const WebpackStatsPlugin_1 = require("./webpackPlugins/WebpackStatsPlugin");
const AsyncComponentPlugin_1 = require("./webpackPlugins/AsyncComponentPlugin");
const CumulativeManifestProcessor_1 = require("../../spfxManifests/cumulativeManifestProcessor/CumulativeManifestProcessor");
const ExternalsProcessor_1 = require("../../spfxManifests/utilities/ExternalsProcessor");
const getFullHash_1 = require("../../spfxManifests/utilities/getFullHash");
const constants_1 = require("../../utilities/constants");
const ManifestPlugin_1 = require("../../spfxManifests/webpack/ManifestPlugin");
/**
 * @public
 */
exports.FILE_LOADER_EXTENSIONS = [
    'jpg',
    'png',
    'woff',
    'woff2',
    'eot',
    'ttf',
    'svg',
    'gif',
    'dds'
];
/**
 * @public
 */
exports.IS_SPFX_WEBPACK_CONFIGURATION_SYMBOL = Symbol('IS_SPFX_WEBPACK_CONFIGURATION');
/**
 * @public
 */
exports.CONFIG_JSON_SYMBOL = Symbol('CONFIG_JSON');
const VERSIONED_ASSETS_FOLDER_NAME = 'assets-versioned';
const cssHashCache = new Map();
const DEFAULT_GENERATE_CSS_CLASS_NAME = (existingClassName, cssFilename, cssContent) => {
    let hash = cssHashCache.get(cssFilename);
    if (!hash) {
        hash = crypto.createHmac('sha1', cssFilename).update(cssContent).digest('hex').substring(0, 8);
        cssHashCache.set(cssFilename, hash);
    }
    return `${existingClassName}_${hash}`;
};
/**
 * @public
 */
class WebpackConfigurationGenerator {
    static async generateWebpackConfigurationAsync(options) {
        var _a;
        WebpackConfigurationGenerator._validateEntries(options.configJson, options.folders.buildFolder);
        const terminal = options.terminal;
        const configBundleEntries = options.configJson.bundles || {};
        const distFolderName = path.basename(options.folders.outputFolder);
        //#region EXTERNAL COMPONENTS
        // Discover packages that should be externalized because they have manifests
        const cumulativeManifestProcessor = new CumulativeManifestProcessor_1.CumulativeManifestProcessor({
            terminal: options.terminal,
            rootPath: options.folders.buildFolder,
            tempFolderName: path.basename(options.folders.tempFolder),
            distFolderName: distFolderName,
            includeAssemblies: true
        });
        const referencedProjects = cumulativeManifestProcessor.discoverManifests(options.folders.buildFolder, CumulativeManifestProcessor_1.DependencyDiscoveryMode.deepSparseIgnoreFirstProject);
        const linkedExternals = {};
        // Add these projects to externalized packages
        for (const [manifestId, versionMap] of Object.entries(referencedProjects)) {
            for (const [, referencedProject] of Object.entries(versionMap)) {
                if (referencedProject.packageName && !referencedProject.isAssembly) {
                    linkedExternals[referencedProject.packageName] = {
                        id: manifestId,
                        name: referencedProject.packageName,
                        version: referencedProject.manifestData.version
                    };
                }
            }
        }
        const nonStandardExternals = (0, ExternalsProcessor_1.getNonStandardExternals)(options.folders.buildFolder, referencedProjects);
        for (const [externalName, external] of Object.entries(nonStandardExternals)) {
            linkedExternals[externalName] = external;
        }
        const externalsKeys = new Set(Object.keys(linkedExternals));
        if (options.configJson.externals) {
            for (const externalKey of Object.keys(options.configJson.externals)) {
                externalsKeys.add(externalKey);
            }
        }
        // Remove the specified linked externals to ensure they're bundled
        if ((_a = options.linkedExternalsToBundle) === null || _a === void 0 ? void 0 : _a.length) {
            for (const linkedExternalToBundle of options.linkedExternalsToBundle) {
                externalsKeys.delete(linkedExternalToBundle);
            }
        }
        // Don't list the project being built as an external
        externalsKeys.delete(options.projectPackageJson.name);
        //#endregion
        const configBundleEntriesCount = Object.keys(configBundleEntries).length;
        if (configBundleEntriesCount === 0) {
            terminal.writeWarningLine('No entries are defined, so no bundles will be produced.');
            return undefined;
        }
        terminal.writeVerboseLine(`${configBundleEntriesCount} entries specified.`);
        terminal.writeVerboseLine(`${externalsKeys.size} externals specified.`);
        const bundleEntries = [];
        const webpackEntries = {};
        const libraryNameMap = new Map();
        const bundleNameMap = new Map();
        for (const [bundleName, configEntry] of Object.entries(configBundleEntries)) {
            const bundleEntry = {
                bundleName,
                components: {}
            };
            for (const componentEntry of configEntry.components) {
                const manifestData = node_core_library_1.JsonFile.load(path.resolve(options.folders.buildFolder, componentEntry.manifest));
                // If the manifest version is "*", replace it with the package version. Do this here to make sure the
                //  bundle's name doesn't contain the "*" version
                if (manifestData.version === '*') {
                    const packageJson = node_core_library_1.PackageJsonLookup.instance.tryLoadPackageJsonFor(options.folders.buildFolder);
                    if (!packageJson) {
                        throw new Error(`Unable to find package.json for "${options.folders.buildFolder}"`);
                    }
                    // Remove pre-release name if any, because pre-release is not handled by SPFx yet.
                    const indexOfDelimiter = packageJson.version.indexOf('-');
                    const manifestVersion = indexOfDelimiter > 0 ? packageJson.version.substr(0, indexOfDelimiter) : packageJson.version;
                    manifestData.version = manifestVersion;
                }
                // Keep a counter of the manifests inside the bundle so we can set the exportName property in the produced
                //  manifest(s) and generate a JS file to bundle both components' entrypoints
                bundleEntry.components[manifestData.id] = {
                    ...componentEntry,
                    manifestData,
                    manifestPath: path.join(options.folders.buildFolder, componentEntry.manifest),
                    exportName: undefined
                };
            }
            const bundleId = WebpackConfigurationGenerator._getBundleId(bundleEntry);
            const componentKeys = Object.keys(bundleEntry.components);
            if (componentKeys.length === 1) {
                // Single component, just point to its entrypoint in the webpack config
                webpackEntries[bundleName] = node_core_library_1.Import.resolveModule({
                    modulePath: bundleEntry.components[componentKeys[0]].entrypoint,
                    baseFolderPath: options.folders.buildFolder
                });
                bundleNameMap.set(bundleName, bundleId);
            }
            else {
                // Multiple components, we need to generate an entry to point the webpack config in the temp folder
                webpackEntries[bundleName] = this._generateBundleEntrypointFile({
                    bundleEntry,
                    buildFolder: options.folders.buildFolder,
                    tempFolder: options.folders.tempFolder
                });
            }
            libraryNameMap.set(bundleName, bundleId);
            bundleEntries.push(bundleEntry);
        }
        let webpackLibraryName;
        if (options.libraryName) {
            webpackLibraryName = options.libraryName;
        }
        else {
            if (bundleEntries.length === 1) {
                // We're producing one bundle, so we can generate a simple name
                webpackLibraryName = libraryNameMap.get(bundleEntries[0].bundleName);
            }
            else {
                // There are multiple bundles. Because we need something unique for the webpack JSONP function, we'll just
                // concatenate the IDs and then hash them. In a plugin, we'll replace the "define(<name>, ..."
                // names with the real IDs.
                webpackLibraryName = (0, getFullHash_1.getFullHash)(bundleEntries.map((bundle) => libraryNameMap.get(bundle.bundleName)).join(''));
            }
        }
        const generateCssClassName = options.generateCssClassName || DEFAULT_GENERATE_CSS_CLASS_NAME;
        const cssLoaders = [
            {
                loader: WebpackConfigurationGenerator._requireResolveWithCorrectCase('@microsoft/loader-load-themed-styles'),
                options: {
                    async: true
                }
            },
            {
                loader: WebpackConfigurationGenerator._requireResolveWithCorrectCase('css-loader')
            },
            {
                loader: WebpackConfigurationGenerator._requireResolveWithCorrectCase('postcss-loader'),
                options: {
                    ident: 'postcss',
                    minimize: true,
                    plugins: [require('cssnano')({ preset: ['default', { mergeLonghand: false }] })]
                }
            }
        ];
        const scssLoader = {
            loader: require.resolve('sass-loader'),
            options: {
                implementation: require('sass'),
                sassOptions: {
                    includePaths: [
                        path.resolve(options.folders.buildFolder, 'node_modules'),
                        path.resolve('./node_modules')
                    ]
                }
            }
        };
        const simpleCssLoaderPath = WebpackConfigurationGenerator._requireResolveWithCorrectCase('@microsoft/sp-css-loader');
        const simpleCssLoaderOptions = {
            async: true,
            loadThemedStylesImportPath: options.loadThemedStylesImportPath,
            production: options.production
        };
        const scssLoaders = [
            {
                loader: simpleCssLoaderPath,
                options: simpleCssLoaderOptions
            },
            scssLoader
        ];
        const moduleScssLoaders = [
            {
                loader: simpleCssLoaderPath,
                options: {
                    ...simpleCssLoaderOptions,
                    generateCssClassName: generateCssClassName
                }
            },
            scssLoader
        ];
        const outputFilenameParts = ['[name]'];
        if (options.getLocalization) {
            outputFilenameParts.push('_[locale]');
        }
        if (!options.serveMode && options.production) {
            // The "contenthash" template is the hash of file contents and is preferred over "hash".
            // Serve mode does not support "contenthash" and 3rd party developers may use deployed
            // manifests files for local development, which precludes the use of dynamic hashes.
            outputFilenameParts.push('_[contenthash]');
        }
        outputFilenameParts.push('.js');
        const outputFilename = outputFilenameParts.join('');
        const config = {
            [exports.IS_SPFX_WEBPACK_CONFIGURATION_SYMBOL]: true,
            [exports.CONFIG_JSON_SYMBOL]: options.configJson,
            module: {
                rules: [
                    {
                        use: cssLoaders,
                        test: /\.css$/
                    },
                    {
                        use: moduleScssLoaders,
                        test: /\.module\.scss$/
                    },
                    {
                        use: scssLoaders,
                        test: /(?<!\.module)\.scss$/
                    },
                    {
                        use: {
                            loader: WebpackConfigurationGenerator._requireResolveWithCorrectCase('file-loader'),
                            options: {
                                name: '[name]_[hash].[ext]',
                                // Leave this as `false` to avoid breaking 3rd party projects that use the old
                                // `require('./image.png')` syntax.
                                esModule: false
                            }
                        },
                        test: {
                            or: exports.FILE_LOADER_EXTENSIONS.map((ext) => new RegExp(`\\.${lodash_1.default.escapeRegExp(ext)}((\\?|\\#).+)?$`))
                        }
                    },
                    {
                        use: {
                            loader: WebpackConfigurationGenerator._requireResolveWithCorrectCase('html-loader')
                        },
                        test: /\.html$/
                    }
                ],
                noParse: [/\.map$/]
            },
            resolve: {
                alias: {},
                modules: ['node_modules', 'lib']
            },
            context: options.folders.buildFolder,
            devtool: options.production ? undefined : 'source-map',
            mode: options.production ? 'production' : 'development',
            entry: webpackEntries,
            externals: Array.from(externalsKeys),
            output: {
                hashFunction: 'md5',
                chunkFilename: `chunk.${outputFilename}`,
                filename: outputFilename,
                library: webpackLibraryName,
                libraryTarget: options.libraryTarget || 'amd',
                path: options.folders.outputFolder,
                devtoolModuleFilenameTemplate: 'webpack:///../[resource-path]',
                devtoolFallbackModuleFilenameTemplate: 'webpack:///../[resource-path]?[hash]',
                crossOriginLoading: options.crossOriginLoading !== false && 'anonymous'
            },
            optimization: {
                moduleIds: 'hashed',
                splitChunks: {
                    automaticNameMaxLength: 50
                } // SplitChunksOptions in the webpack typings is missing the automaticNameMaxLength option
            },
            performance: {
                hints: false
            },
            plugins: [
                new set_webpack_public_path_plugin_1.SetPublicPathPlugin({
                    scriptName: {
                        useAssetName: true
                    }
                }),
                new webpack.DefinePlugin({
                    'process.env.NODE_ENV': JSON.stringify(options.production ? 'production' : 'dev'),
                    DEBUG: !options.production,
                    DEPRECATED_UNIT_TEST: false
                }),
                new ComponentNamePlugin_1.ComponentNamePlugin({
                    getLibraryNameForChunk: (chunk) => bundleNameMap.get(chunk.name)
                })
            ]
        };
        // Stats are incredibly expensive to write and generate.
        // Leave this option behind a flag for generation
        if (options.emitStats) {
            config.plugins.push(new WebpackStatsPlugin_1.WebpackStatsPlugin({
                dropPath: path.resolve(options.folders.releaseFolder, 'webpack-stats', `${path.basename(options.folders.buildFolder)}.stats.json`)
            }));
        }
        if (!options.disableAsyncComponentLoading) {
            const asyncComponentPluginExternalComponents = [];
            for (const [, linkedExternal] of Object.entries(linkedExternals)) {
                asyncComponentPluginExternalComponents.push({
                    componentId: linkedExternal.id,
                    componentName: linkedExternal.name,
                    componentVersion: linkedExternal.version
                });
            }
            config.plugins.push(new AsyncComponentPlugin_1.AsyncComponentPlugin({
                externalComponents: asyncComponentPluginExternalComponents
            }));
        }
        let tryGetLocFileTranslations = () => undefined;
        let localizedData = {};
        let selectedLocales = new Set([constants_1.DEFAULT_LOCALE]);
        if (options.getLocalization) {
            const localizationPackage = options.getLocalization();
            localizedData = await localizationPackage.getProjectLocalizedStringsAsync();
            tryGetLocFileTranslations = localizationPackage.getLocFileTranslations.bind(localizationPackage);
            const localizedDataKeys = Object.keys(localizedData);
            if (localizedDataKeys.length > 0) {
                if (options.selectedLocales) {
                    for (const selectedLocale of options.selectedLocales) {
                        if (selectedLocale !== constants_1.DEFAULT_LOCALE && !localizedData.hasOwnProperty(selectedLocale)) {
                            throw new Error(`The selected locale (${selectedLocale}) is not present in the localized data.`);
                        }
                    }
                    selectedLocales = new Set([constants_1.DEFAULT_LOCALE, ...options.selectedLocales]);
                }
                else if (options.production) {
                    selectedLocales = new Set([constants_1.DEFAULT_LOCALE, ...localizedDataKeys]);
                }
            }
            const { localizationPlugin, stringsLoaders } = await localizationPackage.getLocalizationConfigurationAsync(selectedLocales);
            config.module.rules.push(...stringsLoaders);
            config.plugins.push(localizationPlugin);
        }
        let serveConfig = {};
        try {
            serveConfig = await node_core_library_1.JsonFile.loadAsync(path.join(options.folders.buildFolder, 'config', 'serve.json'));
        }
        catch (e) {
            if (!node_core_library_1.FileSystem.isNotExistError(e)) {
                throw e;
            }
        }
        const debugBaseUrl = `${serveConfig.https ? 'https' : 'http'}://localhost:${serveConfig.port || 4321}/${distFolderName}/`;
        let cdnBaseUrl;
        try {
            const writeManifestsConfig = await node_core_library_1.JsonFile.loadAsync(path.join(options.folders.buildFolder, 'config', 'write-manifests.json'));
            cdnBaseUrl = writeManifestsConfig.cdnBasePath;
        }
        catch (e) {
            if (!node_core_library_1.FileSystem.isFileDoesNotExistError(e)) {
                throw e;
            }
        }
        config.plugins.push(new ManifestPlugin_1.ManifestPlugin({
            terminal,
            selectedLocales,
            sourceLocaleName: constants_1.DEFAULT_LOCALE,
            bundleEntries: bundleEntries,
            internalModuleBaseUrls: cdnBaseUrl ? [cdnBaseUrl] : [],
            debugInternalModuleBaseUrls: [debugBaseUrl],
            linkedExternals: linkedExternals,
            referencedProjects: referencedProjects,
            cumulativeManifestProcessor: cumulativeManifestProcessor,
            tryGetLocFileTranslations,
            asyncOnlyDependencies: {
                asyncOnlyDependencyNames: options.configJson.asyncComponents || [],
                violationsAsErrors: options.production
            },
            componentDependenciesAuditDropPath: path.join(options.folders.releaseFolder, 'component-dependency-audit', `${path.basename(options.folders.buildFolder)}.json`),
            manifestsJsFileMetadata: options._manifestsJsFileMetadata
        }));
        if (options.production) {
            config.optimization.minimize = true;
            config.optimization.minimizer = [
                new webpack4_module_minifier_plugin_1.ModuleMinifierPlugin({
                    minifier: new webpack4_module_minifier_plugin_1.WorkerPoolMinifier({
                        // Cap the number of worker processes to avoid CPU saturation.
                        maxThreads: Math.min(8, os.cpus().length),
                        terserOptions: {
                            compress: {
                                passes: 3
                            },
                            mangle: true,
                            output: {
                                comments: false,
                                wrap_func_args: false
                            }
                        }
                    })
                })
            ];
        }
        else {
            config.module.rules.push({
                test: /\.js$/,
                enforce: 'pre',
                use: WebpackConfigurationGenerator._requireResolveWithCorrectCase('source-map-loader'),
                exclude: [/node_modules/]
            });
        }
        // Always produce the release/ folder
        config.plugins.push(new CopyReleaseAssetsPlugin_1.CopyReleaseAssetsPlugin({
            releasePath: options.folders.releaseFolder,
            isDebug: !options.production,
            assetsFolderName: options.assetsAreVersioned ? VERSIONED_ASSETS_FOLDER_NAME : undefined,
            manifestsFolderName: options.releaseManifestFolderName
        }));
        return config;
    }
    static getComponentsBundleId(manifests) {
        return manifests.map((manifest) => `${manifest.id}_${manifest.version}`).join('+');
    }
    static _getBundleId(bundle) {
        const manifests = [];
        Object.keys(bundle.components).forEach((id) => manifests.push(bundle.components[id].manifestData));
        return WebpackConfigurationGenerator.getComponentsBundleId(manifests);
    }
    /**
     * Writes the entrypoint file to the temp directory and returns the path to the file.
     */
    static _generateBundleEntrypointFile(options) {
        const entrypointFileFolderPath = path.resolve(options.tempFolder, 'bundle-entries');
        const filePath = path.join(entrypointFileFolderPath, `${options.bundleEntry.bundleName}.js`);
        const fileLines = ['Object.defineProperty(exports, "__esModule", { value: true });', ''];
        for (const [componentId, bundleComponent] of Object.entries(options.bundleEntry.components)) {
            const fullEntrypointPath = node_core_library_1.Import.resolveModule({
                modulePath: bundleComponent.entrypoint,
                baseFolderPath: options.buildFolder
            });
            const relativeEntrypointPath = path.relative(entrypointFileFolderPath, fullEntrypointPath);
            bundleComponent.exportName = componentId;
            fileLines.push('');
            fileLines.push(`// ${bundleComponent.manifestData.alias}`);
            fileLines.push(`exports['${componentId}'] = require('${relativeEntrypointPath.replace(/\\/g, '/')}');`);
        }
        const fileContents = fileLines.join('\n');
        node_core_library_1.FileSystem.writeFile(filePath, fileContents, { ensureFolderExists: true });
        return filePath;
    }
    static _requireResolveWithCorrectCase(packageName) {
        const resolveResult = node_core_library_1.Import.resolvePackage({ packageName, baseFolderPath: __dirname });
        return (0, true_case_path_1.trueCasePathSync)(resolveResult);
    }
    static _validateEntries(configJson, rootPath) {
        if (configJson.bundles) {
            const entrypointPaths = new Set();
            const manifestPaths = new Set();
            for (const [, bundleEntry] of Object.entries(configJson.bundles)) {
                for (const component of bundleEntry.components) {
                    const entrypointPath = node_core_library_1.Import.resolveModule({
                        modulePath: component.entrypoint,
                        baseFolderPath: rootPath
                    }).toUpperCase();
                    if (entrypointPaths.has(entrypointPath)) {
                        throw new Error(`Entry path "${entrypointPath}" occurs in multiple config.json components. This is not supported.`);
                    }
                    else {
                        entrypointPaths.add(entrypointPath);
                    }
                    const manifestPath = path.resolve(path.join(rootPath, component.manifest)).toUpperCase();
                    if (manifestPaths.has(manifestPath)) {
                        throw new Error(`Manifest path "${manifestPath}" occurs in multiple config.json components. This is not ` +
                            'supported.');
                    }
                    else {
                        manifestPaths.add(manifestPath);
                    }
                }
            }
        }
    }
}
exports.WebpackConfigurationGenerator = WebpackConfigurationGenerator;
//# sourceMappingURL=WebpackConfigurationGenerator.js.map