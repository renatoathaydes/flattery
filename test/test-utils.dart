import 'dart:convert';
import 'dart:io';

import 'package:webdriver/io.dart';

Process _chromeDriverProcess;

Future<WebDriver> launchBrowserAndGetDriver() async {
  if (_chromeDriverProcess == null) {
    _chromeDriverProcess = await Process.start(
        'chromedriver', ['--port=4444', '--url-base=wd/hub']);

    await for (String browserOut in const LineSplitter()
        .bind(utf8.decoder.bind(_chromeDriverProcess.stdout))) {
      if (browserOut.contains('Starting ChromeDriver')) {
        break;
      }
    }
  }

  // Connect to it with the webdriver package
  return await createDriver(
      uri: Uri.parse('http://localhost:4444/wd/hub/'),
      desired: Capabilities.chrome);
}

void stopBrowser() {
  _chromeDriverProcess?.kill();
}
