class TransactionMsg {
  final String? msg;
  final bool continueAdding;

  const TransactionMsg({
    required this.continueAdding,
    this.msg,
  });
}
