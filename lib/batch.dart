import 'package:flutter/material.dart';
import 'package:vti_student/todaybatch.dart';
import 'configs/globals.dart';
class batch extends StatelessWidget {
  const batch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  MyHomePage(),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(25.0)
                    ),
                    child:  TabBar(
                      indicator: BoxDecoration(
                          color: primaryColor,
                          borderRadius:  BorderRadius.circular(25.0)
                      ) ,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: const  [
                        Tab(text: 'Today Batches',),
                        Tab(text: 'Tomorrow Batches',),
                        Tab(text: 'allday Batches',),
                      ],
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                        children:  [
                          TodayBatch(day: 'Today'),
                          TodayBatch(day: 'Tomorrow'),
                          TodayBatch(day: 'allday'),
                        ],
                      )
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}

