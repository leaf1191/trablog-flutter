import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablog/page/basic_page.dart';
import 'package:trablog/page/sign_page/title_page.dart';
import 'package:trablog/view_model/basic_model.dart';
import 'package:trablog/view_model/memory_model.dart';
import 'package:trablog/view_model/plan_model.dart';
import 'package:trablog/view_model/title_model.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<TitleModel>().toNextPage(() async {
      try{
        await context.read<TitleModel>().checkToken();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider(create: (context) => BasicModel()),
                        ChangeNotifierProvider(create: (context) => PlanModel()),
                        ChangeNotifierProvider(create: (context) => MemoryModel())
                      ],
                      child: const BasicPage(),
                    )));
      } catch(e){
        print(e.toString());
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => TitleModel(),
              child: const TitlePage(),
            ))
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage('assets/cat/cat.png'))),
        )),
      ),
    );
  }
}
