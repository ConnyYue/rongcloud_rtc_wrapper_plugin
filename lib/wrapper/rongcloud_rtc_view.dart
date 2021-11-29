/// @author Pan ming da
/// @time 2021/6/8 15:57
/// @version 1.0

part of 'rongcloud_rtc_engine.dart';

class RCRTCView extends StatefulWidget {
  static Future<RCRTCView> create({
    BoxFit fit = BoxFit.contain,
    bool mirror = true,
    Function()? onFirstFrameRendered,
  }) async {
    int id = await _channel.invokeMethod('create');
    RCRTCView view = RCRTCView._(id, fit, mirror, onFirstFrameRendered);
    return view;
  }

  RCRTCView._(
    this._id,
    BoxFit fit,
    bool mirror,
    this._onFirstFrameRendered,
  )   : _state = _RCRTCViewState(fit, mirror),
        super(key: Key('RCRTCView[$_id][${DateTime.now().microsecondsSinceEpoch}]')) {
    _state.init(this);
  }

  Future<void> _destroy() async {
    await _channel.invokeMethod('destroy', _id);
  }

  set mirror(bool mirror) {
    _state.mirror = mirror;
  }

  bool get mirror => _state.mirror;

  set fit(BoxFit fit) {
    _state.fit = fit;
  }

  BoxFit get fit => _state.fit;

  @override
  State<StatefulWidget> createState() => _state;

  static final MethodChannel _channel = MethodChannel('cn.rongcloud.rtc.flutter/view');
  final int _id;
  final _RCRTCViewState _state;
  final Function()? _onFirstFrameRendered;
}

class _RCRTCViewState extends State<RCRTCView> {
  _RCRTCViewState(this._fit, this._mirror);

  void init(RCRTCView view) {
    this.view = view;
    subscription = EventChannel('cn.rongcloud.rtc.flutter/view:${view._id}').receiveBroadcastStream().listen(onData);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => _build(constraints),
    );
  }

  Widget _build(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: FittedBox(
        fit: fit,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: width.toDouble(),
          height: height.toDouble(),
          child: Transform(
            transform: Matrix4.rotationY(mirror ? -pi : 0.0),
            alignment: FractionalOffset.center,
            child: Texture(textureId: view._id),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    view._destroy();
    super.dispose();
  }

  BoxFit get fit => _fit;

  set fit(BoxFit fit) {
    _fit = fit;
    if (mounted) setState(() {});
  }

  bool get mirror => _mirror;

  set mirror(bool mirror) {
    _mirror = mirror;
    if (mounted) setState(() {});
  }

  void onData(dynamic data) {
    final Map<dynamic, dynamic> json = data;
    final String? event = json['event'];
    switch (event) {
      case 'onFirstFrame':
        view._onFirstFrameRendered?.call();
        break;
      case 'onSizeChanged':
        _changeSize(json);
        break;
    }
  }

  void _changeSize(Map<dynamic, dynamic> json) {
    width = json['width'];
    height = json['height'];
    if (mounted) setState(() {});
  }

  late RCRTCView view;
  late StreamSubscription<dynamic> subscription;

  int width = 0, height = 0;

  BoxFit _fit = BoxFit.contain;
  bool _mirror = true;
}
