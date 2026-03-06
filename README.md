# Decentralized DNS for Nostr Identities

> **Proof of concept** a censorship-resistant, human-readable identity for [Nostr](https://nostr.com) using [Namecoin](https://www.namecoin.org), with a path toward [BitNames](https://www.truthcoin.info/blog/bitnames/) on [Drivechain](https://drivechain.info/) via [BIP300](https://bips.xyz/300) / [BIP301](https://bips.xyz/301).

---

## The Problem

[Nostr](https://nostr.com) is a censorship-resistant messaging protocol. But your *human-readable identity* is a different story…

**NIP-05** — the current standard for Nostr usernames — maps `alice@example.com` to an `npub` via an HTTPS request to a traditional web server. The two most popular Nostr clients (Primal, Damus) sell NIP-05 identities as a certificate:

```
alice@primal.net  →  GET https://primal.net/.well-known/nostr.json?name=alice
alice@damus.io    →  GET https://damus.io/.well-known/nostr.json?name=alice
```

This reintroduces centralization:

- The domain can be seized (registrar, registry, ICANN, government)
- The company can deplatform you — delete your entry from `nostr.json`
- The company can shut down — all user identities break

---

## Decentralized DNS

[Namecoin](https://www.namecoin.org) is the first attempt (2011) **from the Bitcoin community** to address this problematic while externalizing the DNS data out of Bitcoin transactions. It is a Bitcoin fork with three additional consensus opcodes (`OP_NAME_NEW`, `OP_NAME_FIRSTUPDATE`, `OP_NAME_UPDATE`) that turn UTXOs into a key-value store secured by Bitcoin's proof-of-work.

A name registration is an on-chain UTXO. The value (up to 520 bytes) can hold a JSON blob with your Nostr public key:

```json
{ "nostr": "npub1xyz..." }
```

Resolution is a single chain query, no HTTP server, no third party, no trust required. 
You can run your own Namecoin node to resolve names without relying on a central authority.

**To censor a Namecoin name registration, an attacker needs to reorg the chain — which requires more than 50% of Bitcoin's total hashrate**

The idea of a decentralized DNS on Bitcoin is not new — Satoshi himself was involved in the discussion that led directly to Namecoin's creation.

> — Satoshi Nakamoto, [*"BitDNS and Generalizing Bitcoin"*](https://bitcointalk.org/index.php?topic=1790.260#msg28715) (BitcoinTalk, Dec 11, 2010)


He was describing **merged mining** a separate chains sharing Bitcoin's hashrate — which is exactly how Namecoin works today. The architecture this project builds on is the direct result of that thread.

The **merged mining** allow Bitcoin miners to simultaneously mine multiple chains with no additional energy expenditure.

A Namecoin block header is embedded directly in the Bitcoin coinbase transaction. Bitcoin miners solving the Bitcoin Proof-of-Work simultaneously solve the Namecoin block. They are the **same miners, the same hashrate, the same work**.

```
Bitcoin block
  └── coinbase transaction
        └── Namecoin block header (embedded)
              └── name_new / name_firstupdate / name_update transactions
```

This makes Namecoin a **sidechain that adds value to Bitcoin without competing with it**:

- Bitcoin miners earn additional NMC revenue from the same work
- Namecoin inherits Bitcoin's proof-of-work security
- To reverse a Namecoin name: you must reverse the Bitcoin block it is anchored in
- No separate security budget, no token competing with BTC


---

## What This PoC Does

A Flutter mobile/desktop client combining:

| Tab | Description |
|---|---|
| **Search** | Resolve any Namecoin name (`d/alice` → `alice.bit`) to its Nostr npub. Register new names. |
| **Nostr** | Encrypted direct messages (NIP-17 gift wrap) using your Namecoin identity. |
| **Settings** | BIP44 Namecoin wallet, Nostr keypair, relay configuration, Electrum node. |

The app is a self-contained registrar + resolver + Nostr client. No centralized API, no third-party service.

**Name format:** `d/alice` on-chain → displayed as `alice.bit`. The JSON value field stores the npub following [IFA-0001](https://github.com/namecoin/proposals) conventions:

```json
{ "nostr": "npub1xyz..." }
```

**Multi-user** (NIP-05 embedded format) — one Namecoin name acts as a NIP-05 provider for multiple identities. The `_` key is the owner (`bob@nostr/bob`); other keys are sub-users (`bobot@nostr/bob`):

```json
{
  "nostr": {
    "names": {
      "_":    "npub1alice...",
      "bob":  "npub1bob..."
    }
  }
}
```

This means a single on-chain registration can replace an entire `nostr.json` file without a server.

---

## Why Not the Alternatives?

We evaluated various approaches.

**NIP-05 through centralized DNS:** Centralized by design.The domain can be seized, the company can deplatform you.

**Web of Trust (petnames on Nostr relays):** Names are contextual — "alice" may resolves differently per user. Hundreds of relay queries per lookup. Relay persistence is not guaranteed. New users with an empty social graph get zero resolution.

**Handshake (BNS):** Only TLD ownership is on-chain. DNS records live on Alice's server — which can be seized. Two-hop resolution. Its own hashrate (much weaker than Bitcoin). Namebase (main registrar) shut down in 2023.

---

## Addressing the Squatting Concern

Like regular DNS, Namecoin's `d/` namespace has significant squatting.

**Mitigating squatting with subspaces** If `d/alice` is squatted, register `n/alice`, `nostr/alice`, or `alice` (no prefix). A squatter would have to predict every prefix.

---

## The Future: BitNames on Drivechain (BIP300/BIP301)

Namecoin solves the problem today. But it requires a separate token (NMC) which can be taboo for some Bitcoiners.

A complementary solution is **BitNames** — a Namecoin-equivalent namespace living natively inside Bitcoin itself, as a sidechain enabled by [BIP300/BIP301 (Drivechain)](https://bips.xyz/300).

Sztorc describes the potential:

> *"With a BitName system, it is possible for me to register the BitName 'psztorc', and then use 'psztorc' as my login at any participating web service. [...] I would own 'psztorc' everywhere, even on new social media platforms that haven't been invented yet. The digital identity would really 'be' me."*
>
> — Paul Sztorc, [*"Sidechain For BitNames/Logins/DNS, Taking on ICANN"*](https://www.truthcoin.info/blog/bitnames/) (Feb 2021)

fiatjaf, the creator of Nostr, also advocates for Drivechain as the path to decentralized names on Bitcoin:

> *"[Drivechain sidechains could enable] decentralized and yet meaningful human-readable names [...] — things that couldn't be tried with real Bitcoin or interfacing with real bitcoins."*
>
> — fiatjaf, [*"Drivechain"*](https://fiatjaf.com/drivechain.html)

**Drivechain** (BIP300/BIP301) would allow a Namecoin-equivalent sidechain secured directly by Bitcoin miners, **without NMC as a separate token** and without any modification to Bitcoin's UTXO set.

**The obstacle: BIP300/BIP301 require new Bitcoin opcodes that have not yet been activated on mainnet. Drivechain remains a proposal.** [Layer Two Labs](https://www.layertwolabs.com) is actively working on it.

---

## Status

This is a **proof of concept** heavily vibecoded, it may contains a lot of AI-slop. It is not production-ready software. It demonstrates that:

1. A censorship-resistant human-readable Nostr identity is technically feasible today
2. Namecoin's merge-mined security is sufficient for this use case
3. The same architecture can migrate to BitNames when Drivechain is available
