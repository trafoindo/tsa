import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DocumenntationReportScreen extends StatefulWidget {
  const DocumenntationReportScreen({super.key});

  @override
  State<DocumenntationReportScreen> createState() =>
      _DocumenntationReportScreenState();
}

class _DocumenntationReportScreenState
    extends State<DocumenntationReportScreen> {

  final Uri _url = Uri.parse(
      'https://drive.google.com/drive/folders/1Nt0_WehMbwneTNIcaYV7CUc-zaYNn9Ul');

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Documentation Report",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Card(
                child: Image.asset("assets/image/default.png"),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    _launchUrl();
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text('Open Drive'),
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
