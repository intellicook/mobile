import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<BuildContext>()])
// ignore: unused_import
import 'fixtures.mocks.dart';

class TextFixture {
  static const text = 'Test Text';

  static Widget widget({text = text}) => Directionality(
        textDirection: TextDirection.ltr,
        child: Text(text),
      );
}
