import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  var ifRpgGame = IFRpgGame()
    ..camera.viewport = FixedResolutionViewport(Vector2(1280.0, 640.0));
  runApp(GameWidget(game: ifRpgGame));
}

class IFRpgGame extends FlameGame with HasDraggables {
  @override
  Future<void> onLoad() async {
    super.onLoad();
    var joystick = JoystickComponent(
      knob: CircleComponent(
          radius: 30, paint: BasicPalette.white.withAlpha(200).paint()),
      background: CircleComponent(
          radius: 100, paint: BasicPalette.white.withAlpha(100).paint()),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(await TiledComponent.load('rpg.tmx', Vector2.all(32)));
    var joystickPlayer = JoystickPlayer(joystick);
    camera.followComponent(joystickPlayer);
    add(joystickPlayer);
    add(joystick);
  }
}

class JoystickPlayer extends SpriteComponent with HasGameRef {
  double maxSpeed = 300.0;

  final JoystickComponent joystick;

  JoystickPlayer(this.joystick) : super(size: Vector2(64, 64)) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png');
    position = gameRef.size / 2;
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * maxSpeed * dt);
      angle = joystick.delta.screenAngle();
    }
  }
}
