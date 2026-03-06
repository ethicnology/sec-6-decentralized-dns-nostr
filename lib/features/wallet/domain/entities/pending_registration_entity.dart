class PendingRegistrationEntity {
  final int id;
  final String name;
  final String saltHex;
  final String commitmentHex;
  final String nameNewTxid;
  final String? nameFirstUpdateTxid;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PendingRegistrationEntity({
    required this.id,
    required this.name,
    required this.saltHex,
    required this.commitmentHex,
    required this.nameNewTxid,
    this.nameFirstUpdateTxid,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPendingNew => status == 'pending_new';
  bool get isPendingFirstUpdate => status == 'pending_firstupdate';
  bool get isCompleted => status == 'completed';
}
