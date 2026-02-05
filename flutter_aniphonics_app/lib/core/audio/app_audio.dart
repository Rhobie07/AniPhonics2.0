import 'audio_controller.dart';
import 'audio_service.dart';

final AudioController audioController = AudioController();
final AudioService audioService = AudioService(
  audioController: audioController,
);
