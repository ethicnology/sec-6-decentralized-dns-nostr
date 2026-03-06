import 'package:nostr_namecoin/features/wallet/domain/entities/address_info_entity.dart';
import 'package:nostr_namecoin/features/wallet/domain/entities/transaction_entity.dart';

enum WalletStatus { initial, loading, loaded, error }

class WalletState {
  final String? mnemonic;
  final String? address;
  final int? balanceSats;
  final int? currentHeight;
  final List<AddressInfoEntity> addresses;
  final List<TransactionEntity> transactions;
  final WalletStatus status;
  final String? errorMessage;

  const WalletState({
    this.mnemonic,
    this.address,
    this.balanceSats,
    this.currentHeight,
    this.addresses = const [],
    this.transactions = const [],
    this.status = WalletStatus.initial,
    this.errorMessage,
  });

  WalletState copyWith({
    String? mnemonic,
    String? address,
    int? balanceSats,
    int? currentHeight,
    List<AddressInfoEntity>? addresses,
    List<TransactionEntity>? transactions,
    WalletStatus? status,
    String? errorMessage,
  }) {
    return WalletState(
      mnemonic: mnemonic ?? this.mnemonic,
      address: address ?? this.address,
      balanceSats: balanceSats ?? this.balanceSats,
      currentHeight: currentHeight ?? this.currentHeight,
      addresses: addresses ?? this.addresses,
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  String get balanceDisplay {
    if (balanceSats == null) return '—';
    final nmc = balanceSats! / 100000000;
    return '${nmc.toStringAsFixed(8)} NMC';
  }
}
