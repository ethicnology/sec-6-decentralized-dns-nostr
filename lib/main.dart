import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coinlib/coinlib.dart' show loadCoinlib;
import 'package:nostr_namecoin/shared/shared.dart';
import 'package:nostr_namecoin/shared/infrastructure/database/app_database.dart';
import 'package:nostr_namecoin/shared/infrastructure/adapters/drift_database_adapter.dart';
import 'package:nostr_namecoin/features/resolve/resolve.dart';
import 'package:nostr_namecoin/features/identity/identity.dart';
import 'package:nostr_namecoin/features/wallet/wallet.dart';
import 'package:nostr_namecoin/features/chat/presentation/pages/nostr_page.dart';
import 'package:nostr_namecoin/features/settings/presentation/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadCoinlib();

  // Database
  final db = AppDatabase.create();

  // Facades
  final electrumFacade = ElectrumFacade();
  final namecoinFacade = NamecoinFacade();
  final nostrFacade = NostrFacade();
  final walletFacade = WalletFacade(electrumFacade, db);

  // Adapters
  final blockchainPort = ElectrumBlockchainAdapter(electrumFacade);
  final nameCodecPort = NamecoinNameAdapter(namecoinFacade);
  final nostrKeyPort = NostrKeyAdapter(nostrFacade);
  final nostrRelayPort = NostrRelayAdapter(nostrFacade);
  final walletPort = WalletAdapter(walletFacade);
  final databasePort = DriftDatabaseAdapter(db);

  // Use cases
  final resolveNameUseCase = ResolveNameUseCase(blockchainPort, nameCodecPort);
  final searchNameUseCase = SearchNameUseCase(resolveNameUseCase);
  final generateKeypairUseCase = GenerateKeypairUseCase(nostrKeyPort);
  final importKeypairUseCase = ImportKeypairUseCase(nostrKeyPort);
  final generateMnemonicUseCase = GenerateMnemonicUseCase(walletPort);
  final importMnemonicUseCase = ImportMnemonicUseCase(walletPort);
  final getBalanceUseCase = GetBalanceUseCase(walletPort);
  final registerNameUseCase = RegisterNameUseCase(walletPort, databasePort);
  final updateNameValueUseCase = UpdateNameValueUseCase(walletPort);

  // Connect to Electrum on startup
  blockchainPort.connect();

  runApp(
    App(
      searchNameUseCase: searchNameUseCase,
      generateKeypairUseCase: generateKeypairUseCase,
      importKeypairUseCase: importKeypairUseCase,
      nostrKeyPort: nostrKeyPort,
      nostrRelayPort: nostrRelayPort,
      nostrFacade: nostrFacade,
      generateMnemonicUseCase: generateMnemonicUseCase,
      importMnemonicUseCase: importMnemonicUseCase,
      getBalanceUseCase: getBalanceUseCase,
      walletPort: walletPort,
      blockchainPort: blockchainPort,
      registerNameUseCase: registerNameUseCase,
      updateNameValueUseCase: updateNameValueUseCase,
      databasePort: databasePort,
    ),
  );
}

class App extends StatelessWidget {
  final SearchNameUseCase searchNameUseCase;
  final GenerateKeypairUseCase generateKeypairUseCase;
  final ImportKeypairUseCase importKeypairUseCase;
  final NostrKeyPort nostrKeyPort;
  final NostrRelayPort nostrRelayPort;
  final NostrFacade nostrFacade;
  final GenerateMnemonicUseCase generateMnemonicUseCase;
  final ImportMnemonicUseCase importMnemonicUseCase;
  final GetBalanceUseCase getBalanceUseCase;
  final WalletPort walletPort;
  final BlockchainPort blockchainPort;
  final RegisterNameUseCase registerNameUseCase;
  final UpdateNameValueUseCase updateNameValueUseCase;
  final DatabasePort databasePort;

  const App({
    super.key,
    required this.searchNameUseCase,
    required this.generateKeypairUseCase,
    required this.importKeypairUseCase,
    required this.nostrKeyPort,
    required this.nostrRelayPort,
    required this.nostrFacade,
    required this.generateMnemonicUseCase,
    required this.importMnemonicUseCase,
    required this.getBalanceUseCase,
    required this.walletPort,
    required this.blockchainPort,
    required this.registerNameUseCase,
    required this.updateNameValueUseCase,
    required this.databasePort,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResolveBloc(searchNameUseCase)),
        BlocProvider(
          create: (_) => IdentityBloc(
            generateKeypairUseCase,
            importKeypairUseCase,
            nostrKeyPort,
            nostrRelayPort,
            nostrFacade,
          ),
        ),
        BlocProvider(
          create: (_) => WalletBloc(
            generateMnemonicUseCase,
            importMnemonicUseCase,
            walletPort,
            blockchainPort,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Decentralized DNS',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: HomePage(
          registerNameUseCase: registerNameUseCase,
          updateNameValueUseCase: updateNameValueUseCase,
          databasePort: databasePort,
          nostrFacade: nostrFacade,
          nostrRelayPort: nostrRelayPort,
          blockchainPort: blockchainPort,
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final RegisterNameUseCase registerNameUseCase;
  final UpdateNameValueUseCase updateNameValueUseCase;
  final DatabasePort databasePort;
  final NostrFacade nostrFacade;
  final NostrRelayPort nostrRelayPort;
  final BlockchainPort blockchainPort;

  const HomePage({
    super.key,
    required this.registerNameUseCase,
    required this.updateNameValueUseCase,
    required this.databasePort,
    required this.nostrFacade,
    required this.nostrRelayPort,
    required this.blockchainPort,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ResolvePage(
        registerNameUseCase: widget.registerNameUseCase,
        updateNameValueUseCase: widget.updateNameValueUseCase,
        databasePort: widget.databasePort,
        nostrFacade: widget.nostrFacade,
        nostrRelayPort: widget.nostrRelayPort,
      ),
      NostrPage(
        nostrFacade: widget.nostrFacade,
        nostrRelayPort: widget.nostrRelayPort,
        onNavigateToSettings: () => setState(() => _currentIndex = 2),
      ),
      SettingsPage(blockchainPort: widget.blockchainPort),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Decentralized DNS')),
      body: pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Nostr',
          ),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
