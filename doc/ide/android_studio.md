# Android Studio

## Live Templates

```dart
class $NAME$ extends StatefulWidget {
  @override
  _$NAME$Controller createState() => _$NAME$Controller();
}
 
class _$NAME$Controller extends State<$NAME$> {
  @override
  Widget build(BuildContext context) => _$NAME$View(this);
}
 
class _$NAME$View extends WidgetView<$NAME$, _$NAME$Controller> {
  const _$NAME$View(_$NAME$Controller state) : super(state);
 
  @override
  Widget build(BuildContext context) {
    return Container($END$);
  }
}
```