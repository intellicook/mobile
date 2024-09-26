class RiveModel {
  const RiveModel({
    required this.src,
    required this.artboard,
    this.stateMachine,
  });

  final String src;
  final String artboard;
  final String? stateMachine;
}
