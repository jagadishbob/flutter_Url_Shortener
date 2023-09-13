import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_shortener/copy_to_clipboard.dart';
import 'package:url_shortener/link.dart';

class Homepage extends StatefulWidget {
  const Homepage({
    Key? key,
    required this.links,
  }) : super(key: key);
  final List<Links> links;

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final formKey = GlobalKey<FormState>();
  final urlTextController = TextEditingController();

  void urlLink(String url) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator.adaptive(),
                SizedBox(
                  height: 10,
                ),
                Text("We're shorting the link"),
              ],
            ),
          ),
        );
      },
    );
    try {
      final response =
          await Dio().get('https://api.shrtco.de/v2/shorten?url=$url');
      if (response.data['ok'] == true) {
        final data = response.data;
        final shortLink = data['result']['full_short_link'];
        final originalLink = data['result']['original_link'];
        // print("This is Shortener link $shortLink");
        // print("This is original link $originalLink");
        copyToClipboard(shortLink);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('shorten Link copied to clipboard'),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop();
        }
        final resultLink=Links(originalLink: originalLink, shortLink: shortLink);
        widget.links.insert(0, resultLink);
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Something went wrong please try again'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(15),
      children: [
        Image.asset(
          'assets/img1.png',
          width: 300,
        ),
        const Text('Enter Your URL',
            style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
        const SizedBox(height: 10),
        Form(
            key: formKey,
            child: TextFormField(
              controller: urlTextController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Ionicons.link),
                  hintText: 'Enter URL',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100))),
              validator: (value) {
                if (value!.isEmpty) {
                  return "please enter an url";
                }
                if (!value.startsWith('https://') &&
                    !value.startsWith('www.')) {
                  return "enter a valid url";
                }
                // final urlRegex = RegExp(
                //     r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \\.-]*)*\/?$');
                // if (!urlRegex.hasMatch(value)) {
                //   return "enter a valid url";
                // }
                return null;
              },
            )),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (!formKey.currentState!.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("please enter a valid url")));
              return;
            }
            urlLink(urlTextController.text);
          },
          style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8)),
          child: const Text("Shorter Url"),
        ),
      ],
    );
  }
}
