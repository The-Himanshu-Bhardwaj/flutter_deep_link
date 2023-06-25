import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart' as uniLinks;
import 'package:flutter/services.dart' show PlatformException;

String number = '';
String code = '';
// Add this code in your main function before running the app
Future<void> initUniLinks() async {
  try {
    final initialLink = await uniLinks.getInitialLink();
    handleDeepLink(Uri.parse(initialLink!));
  } on PlatformException {
    // Handle error if any
  }

  uniLinks.uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      handleDeepLink(uri);
    }
  });
}

void handleDeepLink(Uri deepLink) {
  if (deepLink.pathSegments.isNotEmpty) {
    if (deepLink.pathSegments[0] == 'order') {
      final orderNumber = deepLink.pathSegments[1];
      final customerCode = deepLink.pathSegments[2];
      debugPrint('order number is --->>> $orderNumber');
      debugPrint('code is ---->>> $customerCode');
      number = orderNumber;
      code = customerCode;
      // Handle the order number and navigate to the appropriate screen
    }
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initUniLinks();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
             Text(
              'You have pushed the button this many times $number:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
