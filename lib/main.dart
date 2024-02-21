import 'package:chili_labs_task/data/repository/gif_repository.dart';
import 'package:chili_labs_task/presentation/bloc/search_bloc.dart';
import 'package:chili_labs_task/presentation/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  await dotenv.load();
  final gifRepository = GifRepository(client: http.Client());
  runApp(MyApp(
    gifRepository: gifRepository,
  ));
}

class MyApp extends StatelessWidget {
  final gifRepository;
  const MyApp({super.key, this.gifRepository});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chili Labs task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => SearchBloc(gifRepository: gifRepository),
        child: SearchScreen(),
      ),
    );
  }
}
