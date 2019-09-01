import 'package:flutter/material.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpinningDiamond extends StatefulWidget {
  SpinningDiamond({this.constantSpeed = 0, this.size = 64});

  final double constantSpeed;
  final double size;

  @override
  State<StatefulWidget> createState() => _SpinningDiamondState();
}

class _SpinningDiamondState extends State<SpinningDiamond>
    with FlareController {
  ActorAnimation _rotate;
  double _rotation = 0;
  double _speed;

  @override
  void initState() {
    _speed = widget.constantSpeed;
    super.initState();
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _rotate = artboard.getAnimation("rotate");

    print(_rotate.duration);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _rotation += elapsed * _speed * -1;

    if (_speed > widget.constantSpeed) _speed *= .95;

    _rotate.apply(_rotation % _rotate.duration, artboard, 1);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _speed += 5;
      },
      child: Stack(
        children: <Widget>[
          SvgPicture.asset(
            'assets/diamond.svg',
            width: widget.size,
            height: widget.size,
          ),
          Container(
            width: widget.size,
            height: widget.size,
            child: FlareActor(
              'assets/rotating-diamond.flr',
              controller: this,
              animation: "idle",
              alignment: Alignment.center,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
