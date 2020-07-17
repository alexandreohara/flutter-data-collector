import 'package:data_collector/design/constants.dart';
import 'package:flutter/material.dart';

class CardSample extends StatelessWidget {
  const CardSample({
    this.onPressed,
  });

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: <Widget>[
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BORDER_RADIUS_32),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(BORDER_RADIUS_32),
            onTap: this.onPressed,
            child: Container(
              height: 204,
              width: 156,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 128,
                    width: 156,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(32.0)),
                      child: Image.asset(
                        'lib/assets/images/image-sample.jpeg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(SPACING_16),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Headline 6',
                            style: theme.textTheme.headline6,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'Body 2',
                            style: theme.textTheme.bodyText2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
