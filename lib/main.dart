import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'form_data.dart';

void main() {
  runApp(const ImgurUploadApp());
}

class ImgurUploadApp extends StatelessWidget {
  const ImgurUploadApp({Key? key}) : super(key: key);

  static final year = DateTime.now().year;
  static final gitUrl = Uri.parse('https://github.com/kurt-liao');
  static final linkedInUrl =
      Uri.parse('https://www.linkedin.com/in/kurt-liao-07360b17b/');
  static final mediumUrl = Uri.parse('https://medium.com/kurt');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Imgur Upload Tool',
        debugShowCheckedModeBanner: false,
        supportedLocales: const <Locale>[Locale('en', 'US')],
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        localizationsDelegates: const [
          FormBuilderLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: Scaffold(
          appBar: AppBar(title: const Text('Imgur Upload Tool')),
          body: FooterView(
              footer: Footer(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                                height: 45.0,
                                width: 45.0,
                                child: Center(
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25.0), // half of height and width of Image
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.github,
                                        size: 20.0,
                                      ),
                                      color: const Color(0xFF162A49),
                                      onPressed: () => _launchUrl(gitUrl),
                                      tooltip: 'Github',
                                    ),
                                  ),
                                )),
                            SizedBox(
                                height: 45.0,
                                width: 45.0,
                                child: Center(
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25.0), // half of height and width of Image
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.linkedin,
                                        size: 20.0,
                                      ),
                                      color: const Color(0xFF162A49),
                                      onPressed: () => _launchUrl(linkedInUrl),
                                      tooltip: 'LinkedIn',
                                    ),
                                  ),
                                )),
                            SizedBox(
                                height: 45.0,
                                width: 45.0,
                                child: Center(
                                  child: Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          25.0), // half of height and width of Image
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        FontAwesomeIcons.medium,
                                        size: 20.0,
                                      ),
                                      color: const Color(0xFF162A49),
                                      onPressed: () => _launchUrl(mediumUrl),
                                      tooltip: 'Medium',
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                          children: [
                            const WidgetSpan(
                              child: Icon(
                                FontAwesomeIcons.scaleBalanced,
                                size: 16.0,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '    MIT License. Copyright ©$year kurt-liao.',
                            )
                          ],
                        ),
                      ),
                    ]),
              ),
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Padding(padding: EdgeInsets.all(10), child: UploadForm())
                  ],
                )
              ]),
        ));
  }
}

class UploadForm extends StatefulWidget {
  const UploadForm({Key? key}) : super(key: key);

  @override
  State<UploadForm> createState() {
    return UploadFormState();
  }
}

class UploadFormState extends State<UploadForm> {
  bool autoValidate = true;
  final _formKey = GlobalKey<FormBuilderState>();

  File? chosenImage;
  String fileName = '';
  dynamic iconColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FormBuilder(
              key: _formKey,
              onChanged: () {
                _formKey.currentState!.save();
                // debugPrint(_formKey.currentState!.value.toString());
              },
              autovalidateMode: AutovalidateMode.disabled,
              initialValue: const {
                'access_token': '',
              },
              skipDisabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 15),
                  FormBuilderTextField(
                    autovalidateMode: AutovalidateMode.always,
                    name: 'access_token',
                    decoration: const InputDecoration(
                      labelText: 'Access Token',
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      chooseImage();
                    },
                    child: const Text.rich(
                      TextSpan(
                        style: TextStyle(
                          fontSize: 14,
                        ),
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.upload,
                              size: 20.0,
                            ),
                          ),
                          TextSpan(
                            text: '上傳圖片',
                          )
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: fileName != '',
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: fileName,
                          ),
                          WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete_sharp,
                                    size: 20.0,
                                  ),
                                  color: const Color(0xFF162A49),
                                  onPressed: () {
                                    setState(() {
                                      chosenImage = null;
                                      fileName = '';
                                    });
                                  },
                                  tooltip: 'Remove',
                                ),
                                onHover: (event) => setState(() {
                                  iconColor = Colors.red;
                                }),
                                onExit: (event) => setState(() {
                                  iconColor = Colors.black;
                                }),
                              )),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15)
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.saveAndValidate() ?? false) {
                        final data = _formKey.currentState?.value;
                        String jsonStr = jsonEncode(data);
                        uploadImage(jsonStr);
                      } else {
                        // debugPrint(_formKey.currentState?.value.toString());
                        // debugPrint('validation failed');
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _formKey.currentState?.reset();
                      setState(() {
                        chosenImage = null;
                        fileName = '';
                      });
                    },
                    // color: Theme.of(context).colorScheme.secondary,
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadImage(String? jsonData) {
    Map<String, dynamic> json = jsonDecode(jsonData!);
    final data = FormData.fromJson(json);
    final accessToken = data.access_token;

    return http.post(Uri.parse('https://api.imgur.com/3/image'),
        headers: <String, String>{'Authorization': 'Bearer $accessToken'},
        body: FormData(accessToken));
  }

  Future<void> chooseImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      chosenImage = File(result.files.single.path!);
      if (chosenImage != null) {
        final splitted = chosenImage?.path.split('/');
        if (splitted != null && splitted.isNotEmpty) {
          setState(() {
            fileName = splitted[splitted.length - 1];
          });
        }
      }
    }
  }
}

Future<void> _launchUrl(url) async {
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}
