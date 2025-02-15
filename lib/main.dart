import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchNumber = TextEditingController();
  ScrollController scrollController = ScrollController();
  GlobalKey itemKey = GlobalKey();
  int targetIndex = -1;
  Color defaultColor = Colors.green;
  Color highlightColor = Colors.yellow;

  scrollToIndex() async {
    if (searchNumber.text.isEmpty) {
      print(
          "Empty text ------------------------------------------------------");
      return;
    }
    if (int.parse(searchNumber.text) < 0 ||
        int.parse(searchNumber.text) > 100) {
      print(
          "Invalid number range --------------------------------------------");
      return;
    }
    setState(() {
      targetIndex = int.parse(searchNumber.text);
    });
    if (itemKey.currentContext != null && targetIndex != -1) {
      RenderBox box = itemKey.currentContext?.findRenderObject() as RenderBox;
      double itemHeight = box.size.height;
      scrollController.animateTo(
        itemHeight * targetIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
  }

  scrollToTop() {
    if (scrollController.hasClients && scrollController.position.pixels > 0) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            onPressed: scrollToTop,
            child: Icon(
              Icons.arrow_upward,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            onPressed: scrollToBottom,
            child: Icon(
              Icons.arrow_downward,
              size: 28,
              color: Colors.white,
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Whatsapp Chat Scrolling Effect"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searchNumber,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: scrollToIndex,
                  child: Container(
                    height: 55,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 101,
                controller: scrollController,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    key: targetIndex == index ? itemKey : null,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      color: targetIndex == index
                          ? highlightColor
                          : Colors.green.withValues(alpha: 0.2),
                    ),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "$index",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
