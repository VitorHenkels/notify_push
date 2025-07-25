import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notify_push/animations/curved_example.dart';
import 'package:notify_push/notification_detail.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //iniciar serviço background
  FirebaseMessaging.onBackgroundMessage(_backgroundMessaging);
  runApp(const CurvedExample());
}

//Future para notificação background
Future<void> _backgroundMessaging(RemoteMessage message) async {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

  //NOTIFICAÇÃO
  void firebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    //pedindo permissão pro usuário
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    //token FCN, quando o user aceita as notificações, o token é enviado pra um banco
    //e é vinculado ao usuário
    String? tokenFCM = await messaging.getToken();
    print("TOKEN FCM: $tokenFCM");

    //NOTIFICAÇÃO COM APP ABERTO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';

      //exibindo a mensagem
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(
            body,
            maxLines: 1,
            style: TextStyle(overflow: TextOverflow.ellipsis),
          ),
          actions: [
            TextButton(onPressed: () => {}, child: Text('Ver detalhes')),
            TextButton(onPressed: () => {}, child: Text('Fechar')),
          ],
        ),
      );
    });
    //notificação com app em background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotificationDetail(title: title, body: body),
        ),
      );
    });

    //notificação com app fechado
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final title = message.notification?.title ?? '';
        final body = message.notification?.body ?? '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationDetail(title: title, body: body),
          ),
        );
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    firebaseMessaging();
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
            const Text('You have pushed the button this many times:'),
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
