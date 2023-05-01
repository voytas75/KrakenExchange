# `KrakenExchange` powershell module - release notes

## 2.1.0 - 2023.04.30

### Added

- param alias in `Find-KEZeroProfitPrice`,
- new function `Get-KEClosedOrders`,
- new function `Get-KEOrdersInfo`,
- new function `Get-KETradesHistory`,
- new function `Get-KETradesInfo`,
- new function `Get-KEOpenPositions`,
- alias `Get-KEAsset` for function `Get-KEAssetInfo`,
- alias `Get-KEAssets` for function `Get-KEAssetInfo`,
- alias `Get-KEPairs` for function `Get-KETradableAssetPair`,
- alias `Get-KEAssetPairs` for function `Get-KETradableAssetPair`,
- interval `21600` to `Get-KEOHLCData`,
- new private function `New-KEDataFolder` for create kraken data folder,
- new private function `New-KEEnvVariable` for environment variable.

### Changed

- output of `Find-KEProfit`,
- validate set fo param `OHLCInterval`,
- show all assets by function `Get-KEAssetInfo`,
- show all pairs by function `Get-KETradableAssetPair`,
- `validatepattern` for asset, crypto and currency.

## 2.0.0 - 2023.04.09

### Added

- new function `Connect-KExchange`
- new function `Disconnect-KExchange`
- new function `Get-KETradeBalance`
- new function `Get-KEOpenOrders`
- new function `Get-KETradeVolume`

### Changed

- secure api key and secret,
- minor changes.

## 1.1.0 - 2023.04.06

### Added

- added `Get-KETradeVolume` function to retrieve trading volume information for a specified asset pair.
- added `Get-KEOHLCData` function to retrieve Open, High, Low, and Close data for a specified asset pair.
- added `Get-KEOrderBook` to retrieve the order book for a given trading pair.
- added `Get-KERecentSpreads` to retrieve recent spreads for a specified trading pair.
- added `Get-KERecentTrades` to retrieve recent trades for a specified trading pair.

### Changed

- secure api key and secret,
- fixed issue with `Get-KETickerInformation` function not returning correct ticker information for certain asset pairs,
- updated help documentation for all functions to provide additional information and usage examples,
- refactored code for improved performance and maintainability,
- minor changes.

## 1.0.1 - 2023.04.04

### Added

- new functions,
- secure api key and secret.

### Changed

- minor changes.

## 1.0.0 - 2023.03

### Added

- functions for public endpoints.

### Changed

- minor changes.
