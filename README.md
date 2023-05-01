# KrakenExchange

[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/krakenexchange?label=KrakenExchange%20)](https://www.powershellgallery.com/packages/KrakenExchange/2.0.0) &nbsp; ![PowerShell version](https://img.shields.io/badge/PowerShell-v7.0-blue)

**Note**: The module and scripts are not affiliated with Kraken or any other cryptocurrency exchange, and use of is at your own risk.

[KrakenExchange](https://www.powershellgallery.com/packages/KrakenExchange) is a PowerShell module that allows you and provide an easy way to interact with the Kraken cryptocurrency exchange API. It includes cmdlets for querying account information, getting ticker information for a specific currency pair, ...

Future versions of the module will expand on this functionality, providing even more powerful tools for automating trading strategies and performing market analysis. You will be able to get ticker information for a specific asset pair, place buy and sell orders, get your trade history, and much more. The module also supports getting open orders and canceling orders, making it a comprehensive tool for managing your trades.

KrakenExchange is designed to be flexible and customizable, allowing you to easily integrate it into your existing PowerShell scripts and automation workflows. Whether you're a seasoned trader or just getting started with cryptocurrency trading, this module provides a powerful toolset to help you succeed in the market.

## Installation

**Note**: This PowerShell module is only compatible with **PowerShell version 7 and above**. If you are running an older version of PowerShell, you will need to [upgrade](https://aka.ms/powershell-release?tag=stable) to use this module.

The module is available on [PowerShell Gallery](https://www.powershellgallery.com/packages/KrakenExchange).

```powershell
Install-Module -Name KrakenExchange
```

## Usage

### `Connect-KExchange`

Function `Connect-KExchange` provide API data for private access (can be skipped for public access):

```powershell
Connect-KExchange
```

You will be asked to provide APi Key and API Secret

**Note** that it is important to keep your API Secret secure and not share it with anyone. You will need both your API Key and API Secret to access your Kraken account via API.

---

#### ApiKey and ApiSecret

To get a Kraken API Key and API Secret, you will need to follow these steps:

1. Create a Kraken account if you don't already have one. You can sign up at <https://www.kraken.com/signup>.

2. Log in to your Kraken account and click on the "Settings" tab in the top right corner.

3. Select the "API" option from the dropdown menu.

4. Click the "Generate New Key" button.

5. You will need to give your API key a name and select the permissions you want to grant to the key. Kraken provides a variety of permission options, such as trading, funding, and viewing account balances.

6. Once you have selected your permissions, click the "Generate Key" button.

7. After generating your key, you will see your API Key and API Secret displayed on the screen. Make sure to copy both the API Key and API Secret to a safe location, as the API Secret will only be displayed once.

---

### `Get-KEAssetInfo`

```powershell
PS C:\> Get-KEAssetInfo -Asset eth | convertto-json
{
  "error": [],
  "result": {
    "XETH": {
...
    }
  }
}
```

### `Get-KETicker`

Gets ticker using Websockets API and default `-Pair` is `BTC/USD`:

```powershell
PS C:\> Get-KETicker

a : {27848.30000, 0, 0.10000000}
...
o : {28179.00000, 28496.40000}
```

[message ticker](https://docs.kraken.com/websockets/#message-ticker)

### `Get-KETickerInformation`

```powershell
PS C:\> Get-KETickerInformation -Pair "BTCUSD" | ConvertTo-Json -Depth 3
{
  "error": [],
  "result": {
    "XXBTZUSD": {
      "a": [
        "27911.10000",
...
      "o": "28179.00000"
    }
  }
}
```

### `Get-KETradableAssetPair`

```powershell
PS C:\> Get-KETradableAssetPair -Pair "ethusd" -Info info | ConvertTo-Json -Depth 4
{
  "error": [],
  "result": {
    "XETHZUSD": {
      "altname": "ETHUSD",
...
      "short_position_limit": 1800
    }
  }
}
```

### `Get-KEAssetInfo`

```powershell
PS C:\> Get-KEAssetInfo -Asset "eth,btc" | ConvertTo-Json
{
  "error": [],
  "result": {
    "XETH": {
...
    },
    "XXBT": {
...
    }
  }
}
```

### `Disconnect-KExchange`

To clear API user's data environment variables:

```powershell
Disconnect-KExchange
```

## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Contributing

Contributions to this project are welcome and encouraged! If you notice a bug, have an idea for a new feature, or would like to contribute code, please open a GitHub issue or pull request.

Before contributing, please review our [contribution guidelines](CONTRIBUTING.md) for instructions on how to get started.

## License

This project is licensed under the terms of the [GNU General Public License (GPL) version 3](LICENSE).

The GPL is a copyleft license, which means that any derivative works must be distributed under the same terms. This ensures that the code remains free and open source.

For more information about the GPL, please see the [official GNU website](https://www.gnu.org/licenses/gpl-3.0.en.html).

## Contact

If you have any questions or comments about this project, please feel free to [contact us](mailto:wnapierala@hotmail.com). We would be happy to hear from you!
