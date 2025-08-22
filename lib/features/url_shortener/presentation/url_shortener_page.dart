import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/widgets/button_widget.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/widgets/url_tile_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Linkfy')),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 300,
                  child: Text(
                    'Create shortened URLs easily that redirect to your desired links.',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),

                SizedBox(height: 20),

                TextField(
                  controller: _urlController,
                  decoration: InputDecoration(
                    labelText: 'Enter URL',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.paste),
                      onPressed: () async {
                        final clipboardData = await Clipboard.getData(
                          'text/plain',
                        );
                        if (clipboardData != null &&
                            clipboardData.text != null) {
                          _urlController.text = clipboardData.text!;
                        }
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Container(
                    width: double.infinity,
                    child: Row(
                      spacing: 12,
                      children: [
                        Expanded(
                          child: ButtonWidget(
                            text: 'Clear',
                            onPressed: () {
                              _urlController.clear();
                            },
                          ),
                        ),
                        Expanded(
                          child: ButtonWidget(
                            text: 'Shorten',
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ListView.builder(
                  itemBuilder: (context, index) {
                    return UrlTileWidget(
                      index: index,
                      shorttedUrl: 'https://short.url/${index + 1}',
                    );
                  },
                  itemCount: 10,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
