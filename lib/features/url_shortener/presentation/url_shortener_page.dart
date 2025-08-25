import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nubank_shorten_links/core/injection_container.dart';
import 'package:nubank_shorten_links/features/url_shortener/data/models/short_url_model.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_cubit.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/cubit/url_shortener_state.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/resources/url_shortener_strings.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/widgets/button_widget.dart';
import 'package:nubank_shorten_links/features/url_shortener/presentation/widgets/url_tile_widget.dart';

class UrlShortenerPage extends StatefulWidget {
  final UrlShortenerCubit? cubit;

  const UrlShortenerPage({Key? key, this.cubit}) : super(key: key);

  @override
  State<UrlShortenerPage> createState() => _UrlShortenerPageState();
}

class _UrlShortenerPageState extends State<UrlShortenerPage> {
  late final UrlShortenerCubit _cubit;
  TextEditingController _urlController = TextEditingController();

  List<ShortUrlModel> shortUrls = [];

  @override
  void initState() {
    super.initState();
    _cubit = widget.cubit ?? sl<UrlShortenerCubit>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.loadStoredUrls();
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<UrlShortenerCubit, UrlShortenerState>(
        builder: (context, state) {
          List<ShortUrlModel> storedUrls = state is UrlShortenerStoredUrlsLoaded
              ? state.urls
              : [];

          if (state is UrlShortenerStoredUrlsLoaded) {
            storedUrls = state.urls;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                UrlShortenerStrings.pageTitle,
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: Center(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 300,
                        child: Text(
                          '${UrlShortenerStrings.descriptionOne}',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),

                      SizedBox(height: 20),

                      TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: '${UrlShortenerStrings.labelText}',
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
                                  text: '${UrlShortenerStrings.clearButton}',
                                  onPressed: () {
                                    _urlController.clear();
                                    _cubit.clearList();
                                  },
                                ),
                              ),
                              Expanded(
                                child: ButtonWidget(
                                  text: '${UrlShortenerStrings.shortenButton}',
                                  onPressed: () {
                                    _cubit.shortenUrl(_urlController.text);

                                    _urlController.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      state is UrlShortenerLoading ||
                              state is UrlShortenerListLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: storedUrls.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return UrlTileWidget(
                                  index: index,
                                  shorttedUrl: '${storedUrls[index].shortUrl}',
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
