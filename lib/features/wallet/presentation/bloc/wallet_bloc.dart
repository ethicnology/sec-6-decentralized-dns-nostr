import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nostr_namecoin/features/wallet/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:nostr_namecoin/features/wallet/domain/usecases/import_mnemonic_usecase.dart';
import 'package:nostr_namecoin/shared/domain/ports/blockchain_port.dart';
import 'package:nostr_namecoin/shared/domain/ports/wallet_port.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_event.dart';
import 'package:nostr_namecoin/features/wallet/presentation/bloc/wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final ImportMnemonicUseCase _importMnemonicUseCase;
  final WalletPort _walletPort;
  final BlockchainPort _blockchainPort;

  WalletBloc(
    this._generateMnemonicUseCase,
    this._importMnemonicUseCase,
    this._walletPort,
    this._blockchainPort,
  ) : super(const WalletState()) {
    on<GenerateMnemonicRequestedEvent>(_onGenerate);
    on<ImportMnemonicRequestedEvent>(_onImport);
    on<RefreshBalanceRequestedEvent>(_onRefreshBalance);
    on<NewAddressRequestedEvent>(_onNewAddress);
    on<SweepFromBip84RequestedEvent>(_onSweepFromBip84);
  }

  Future<void> _onGenerate(
    GenerateMnemonicRequestedEvent event,
    Emitter<WalletState> emit,
  ) async {
    try {
      final mnemonic = _generateMnemonicUseCase.call();
      final address = _walletPort.getNextReceiveAddress();
      emit(state.copyWith(
        mnemonic: mnemonic,
        address: address,
        status: WalletStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onImport(
    ImportMnemonicRequestedEvent event,
    Emitter<WalletState> emit,
  ) async {
    try {
      _importMnemonicUseCase.call(event.mnemonic);
      final address = _walletPort.getNextReceiveAddress();
      emit(state.copyWith(
        mnemonic: event.mnemonic,
        address: address,
        status: WalletStatus.loading,
      ));
      // Auto-scan after import
      await _syncWallet(emit);
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshBalance(
    RefreshBalanceRequestedEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      await _syncWallet(emit);
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _syncWallet(Emitter<WalletState> emit) async {
    final sync = await _walletPort.syncAll();
    final currentHeight = await _blockchainPort.getCurrentHeight();
    emit(state.copyWith(
      balanceSats: sync.totalBalance,
      currentHeight: currentHeight,
      addresses: sync.addresses,
      transactions: sync.transactions,
      status: WalletStatus.loaded,
    ));
  }

  void _onNewAddress(
    NewAddressRequestedEvent event,
    Emitter<WalletState> emit,
  ) {
    try {
      final address = _walletPort.getNextReceiveAddress();
      emit(state.copyWith(address: address));
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSweepFromBip84(
    SweepFromBip84RequestedEvent event,
    Emitter<WalletState> emit,
  ) async {
    emit(state.copyWith(status: WalletStatus.loading));
    try {
      await _walletPort.sweepFromBip84();
      await _syncWallet(emit);
    } catch (e) {
      emit(state.copyWith(
        status: WalletStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
