import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nes_ui/nes_ui.dart';
import 'package:provider/provider.dart';

import '../audio/audio_controller.dart';
import '../level_selection/levels.dart';
import '../player_progress/player_progress.dart';
import 'endless_runner.dart';
import 'game_win_dialog.dart';

/// This widget defines the properties of the game screen.
///
/// It mostly sets up the overlays (widgets shown on top of the Flame game) and
/// the gets the [AudioController] from the context and passes it in to the
/// [EndlessRunner] class so that it can play audio.
class GameScreen extends StatelessWidget {
  const GameScreen({required this.level, super.key});

  final GameLevel level;

  static const String winDialogKey = 'win_dialog';
  static const String backButtonKey = 'back_button';
  static const String directionButtonKey = 'direction_button'; 

  @override
  Widget build(BuildContext context) {
    final audioController = context.read<AudioController>();
    return Scaffold(
      body: GameWidget<EndlessRunner>(
        key: const Key('play session'),
        game: EndlessRunner(
          level: level,
          playerProgress: context.read<PlayerProgress>(),
          audioController: audioController,
        ),
        overlayBuilderMap: {
          backButtonKey: (BuildContext context, EndlessRunner game) {
            return Positioned(
              top: 20.0,
              right: 10.0,
              child: NesButton(
                type: NesButtonType.normal,
                onPressed: GoRouter.of(context).pop,
                child: NesIcon(iconData: NesIcons.leftArrowIndicator),
              ),
            );
          },
          directionButtonKey: (BuildContext context, EndlessRunner game) {
            return Positioned(
              bottom: 30.0, 
              right: 50.0, 
              child: Column(
                children: [

                  NesButton(
                    type: NesButtonType.normal,
                    onPressed: () {
                      final player = game.world.player;
                      player.manualJump();
                    },
                    child: NesIcon(iconData: NesIcons.topArrowIndicator), 
                  ),

                  const SizedBox(height: 10.0),

                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [

                      NesButton(
                        type: NesButtonType.normal,
                        onPressed: () {
                          final player = game.world.player;
                          player.moveLeft();
                        },
                        child: NesIcon(iconData: NesIcons.leftArrowIndicator), 
                      ),

                      const SizedBox(width: 10.0),

                      NesButton(
                        type: NesButtonType.normal,
                        onPressed: () {
                          final player = game.world.player;
                          player.moveRight();
                        },
                        child: NesIcon(iconData: NesIcons.rightArrowIndicator), 
                      ),

                    ],
                  ),

                ],
              ),
            );
          },
          winDialogKey: (BuildContext context, EndlessRunner game) {
            return GameWinDialog(
              level: level,
              levelCompletedIn: game.world.levelCompletedIn,
            );
          },
        },
      ),
    );
  }
}
