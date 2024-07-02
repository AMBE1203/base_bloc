import 'index.dart';

const flavorKey = 'FLAVOR';
const baseUrlKey = 'BASEURL';
const xApiKey = 'XAPI';
const launchJsonPath = './.vscode/launch.json';
const settingsJsonPath = './.vscode/settings.json';
const workspaceXmlPath = './.idea/workspace.xml';

const flavorsList = [
  Flavor(
    flavorEnum: FlavorsEnum.dev,
    name: 'dev',
    prefix: 'DEV',
    baseUrl: "https://dev.com",
    apiKey: "apikey_dev",
    envPath: './config/dev.env',
  ),
  Flavor(
    flavorEnum: FlavorsEnum.stg,
    name: 'stg',
    prefix: 'STG',
    baseUrl: "https://stg.com",
    apiKey: "apikey_stg",
    envPath: './config/stg.env',
  ),
  Flavor(
    flavorEnum: FlavorsEnum.prod,
    name: 'prod',
    prefix: 'PROD',
    baseUrl: "https://prod.com",
    apiKey: "apikey_prod",
    envPath: './config/prod.env',
  ),
];
