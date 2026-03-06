sealed class WalletEvent {}

class GenerateMnemonicRequestedEvent extends WalletEvent {}

class ImportMnemonicRequestedEvent extends WalletEvent {
  final String mnemonic;
  ImportMnemonicRequestedEvent(this.mnemonic);
}

class RefreshBalanceRequestedEvent extends WalletEvent {}

class NewAddressRequestedEvent extends WalletEvent {}

class SweepFromBip84RequestedEvent extends WalletEvent {}
