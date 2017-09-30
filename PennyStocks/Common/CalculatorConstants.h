//
//  CalculatorConstants.h
//  PennyStocks
//
//  Created by Markus Bröker on 19.05.17.
//  Copyright © 2017 Markus Bröker. All rights reserved.
//

#ifndef CalculatorConstants_h
#define CalculatorConstants_h

// Definition der verfügbaren Börsen
#define EXCHANGE_BITTREX @"BITTREX_EXCHANGE"
#define EXCHANGE_POLONIEX @"POLONIEX_EXCHANGE"

#define POLONIEX_ASK @"lowestAsk"
#define POLONIEX_BID @"highestBid"
#define POLONIEX_LOW24 @"low24hr"
#define POLONIEX_HIGH24 @"high24hr"
#define POLONIEX_QUOTE_VOLUME @"quoteVolume"
#define POLONIEX_BASE_VOLUME @"baseVolume"
#define POLONIEX_PERCENT @"percentChange"
#define POLONIEX_LAST @"last"

// ASSET KEYS
#define ASSET1 @"ETH"
#define ASSET2 @"DASH"
#define ASSET3 @"ZEC"
#define ASSET4 @"LTC"
#define ASSET5 @"NEO"
#define ASSET6 @"QTUM"
#define ASSET7 @"OMG"
#define ASSET8 @"MCO"
#define ASSET9 @"PAY"
#define ASSET10 @"BAT"

// ASSET DESCRIPTION KEYS
#define DASHBOARD @"Dashboard"
#define ASSET1_DESC @"Ethereum"
#define ASSET2_DESC @"Digital Cash"
#define ASSET3_DESC @"ZCash"
#define ASSET4_DESC @"Litecoin"
#define ASSET5_DESC @"Neo"
#define ASSET6_DESC @"Qtum"
#define ASSET7_DESC @"OmiseGO"
#define ASSET8_DESC @"Monaco"
#define ASSET9_DESC @"Pay Token"
#define ASSET10_DESC @"Basic Attention"

// FIAT CURRENCY KEYS
#define EUR @"EUR"
#define USD @"USD"
#define GBP @"GBP"
#define JPY @"JPY"
#define CNY @"CNY"

// SHARED USER DEFAULTS KEYS
#define KEY_INITIAL_RATINGS @"initialRatings"
#define KEY_CURRENT_SALDO @"currentSaldo"
#define KEY_SALDO_URLS @"saldoUrls"
#define KEY_TRADING_WITH_CONFIRMATION @"tradingWithConfirmation"

#define KEY_FIAT_CURRENCIES @"fiatCurrencies"
#define KEY_DEFAULT_EXCHANGE @"defaultExchange"

// CHECKPOINT KEYS
#define CP_INITIAL_PRICE @"initialPrice"
#define CP_CURRENT_PRICE @"currentPrice"
#define CP_PERCENT @"percent"

// REAL_PRICE KEYS
#define RP_PRICE @"price"
#define RP_REALPRICE @"realPrice"
#define RP_CHANGE @"change"

// TEMPLATEVIEW KEYS
#define TV_APPLICATIONS @"applications"
#define TV_TRADERS @"traders"

#define TV_HOMEPAGE @"homepage"
#define TV_TRADER1 @"trader1"
#define TV_TRADER2 @"trader2"

#define TV_TICKER_PLACEHOLDER @"---"
#define OPTIONS_MENUBAR @"menubar"

#define COINCHANGE_PERCENTAGE @"coinchangePercentage"

#endif /* CalculatorConstants_h */
