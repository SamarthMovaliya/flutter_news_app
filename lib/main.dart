import 'package:flutter/material.dart';
import 'package:news_api_app/apiHelper/apihelper.dart';
import 'package:news_api_app/modal/global.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => myApp(),
        "viewPage": (context) => ViewPage(),
      },
    ),
  );
}

class myApp extends StatefulWidget {
  const myApp({Key? key}) : super(key: key);

  @override
  State<myApp> createState() => _myAppState();
}

class _myAppState extends State<myApp> {
  late Future data;

  @override
  void initState() {
    data = newsApiHelper.newsApi
        .fetchNewsData(ct: selected_ct, cou: selected_cout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        leading: const Icon(Icons.menu_rounded),
        centerTitle: false,
        title: const Text(
          'Latest News',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        backgroundColor: Colors.red.shade900,
      ),
      body: FutureBuilder(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(
              child: Text('error occurred ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<global>? myData = snapshot.data as List<global>;
            return Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categories
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selected_ct = e;
                                          data = newsApiHelper.newsApi
                                              .fetchNewsData(
                                                  cou: selected_cout,
                                                  ct: selected_ct);
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: (selected_ct == e)
                                              ? Colors.red.shade100
                                              : Colors.red.shade50,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          border: Border.fromBorderSide(
                                            BorderSide(
                                              width: (selected_ct == e) ? 2 : 1,
                                              color: Colors.red.shade500,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            e,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red.shade900),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: DropdownButton(
                                  elevation: 20,
                                  alignment: Alignment.center,
                                  dropdownColor: Colors.grey.shade100,
                                  style: const TextStyle(color: Colors.black),
                                  borderRadius: BorderRadius.circular(20),
                                  icon: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.list,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                  isExpanded: true,
                                  underline: Container(),
                                  value: selected_cout,
                                  items: country
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(
                                            e,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) {
                                    setState(() {
                                      selected_cout = val;
                                      data = newsApiHelper.newsApi
                                          .fetchNewsData(
                                              cou: selected_cout,
                                              ct: selected_ct);
                                    });
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 14,
                  child: Card(
                    child: ListView(
                      children: myData
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, 'viewPage',
                                      arguments: e);
                                },
                                child: Card(
                                  elevation: 7,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: ListTile(
                                      subtitle: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 25,
                                            width: 30,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade700,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Text(
                                              e.sourceName,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                      leading: Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              colorFilter: ColorFilter.mode(
                                                  Colors.black.withOpacity(0.8),
                                                  BlendMode.colorDodge),
                                              image: (e.img == null)
                                                  ? const NetworkImage(
                                                      'https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj')
                                                  : NetworkImage(e.img,
                                                      scale: 0.1)),
                                        ),
                                      ),
                                      title: Text(
                                        e.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Container(
                                        height: 35,
                                        width: 70,
                                        child: Text(
                                          "${e.author} ...",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ViewPage extends StatefulWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    global e = ModalRoute.of(context)!.settings.arguments as global;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        centerTitle: false,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          e.author.toString(),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 30,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.8),
                            BlendMode.colorDodge),
                        image: (e.img == null)
                            ? const NetworkImage(
                                'https://yt3.googleusercontent.com/MRywaef1JLriHf-MUivy7-WAoVAL4sB7VHZXgmprXtmpOlN73I4wBhjjWdkZNFyJNiUP6MHm1w=s900-c-k-c0x00ffffff-no-rj')
                            : NetworkImage(e.img, scale: 0.1)),
                  ),
                ),
              )),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Text(
                          e.title,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        e.sourceName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Content',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    e.content,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Description',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    e.desc,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
