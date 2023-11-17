

import 'package:web3dart/web3dart.dart';

List<TokenData> token = [
  TokenData(
    balance: '0.0ETH',
    tokenBalanceInUSD: 'US\$0,00',
    contractName: "Ethereum",
    contractTickerSymbol: "ETH",
    quoteRate: "\$1600",
    logoUrl: 'assets/images/ethereum.svg',
  ),
  TokenData(
    balance: '0.00Matic',
    tokenBalanceInUSD: 'US\$0,00',
    contractName: "Polygon",
    contractTickerSymbol: "Matic",
    quoteRate: "\$0.89",
    logoUrl: 'assets/images/polygon.svg',
  ),
];

class TokenData {
  final EthereumAddress? contractAddress;
  final String? quoteRate;
  final String? balance;
  final String? tokenBalanceInUSD;
  final String? contractName;
  final String? contractTickerSymbol;
  final String? logoUrl;

  TokenData(
      {this.contractAddress,
      this.quoteRate,
      this.balance,
      this.tokenBalanceInUSD,
      this.contractName,
      this.contractTickerSymbol,
      this.logoUrl});
}
