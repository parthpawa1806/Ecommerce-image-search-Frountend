import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final List<dynamic> responseData;

  ResultScreen(this.responseData);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  List<String> buttons = ["T-Shirts", "Shirts", "Croptop", "Pants", "Trousers", "Shorts"];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[500]),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Text(
              'Results',
              style: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.grey,
                fontSize: 17,
              ),
            ),
          ),
        ),
      ),
      body:
          ListView.builder(
            itemCount: widget.responseData.length,
            itemBuilder: (context, index) {
              final product = widget.responseData[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.black,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      child: Image.network(
                        product['ImageURL'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Divider(thickness: 2),
                    Expanded(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              product['ProductTitle'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Text(
                            product['SubCategory'],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                         
                          Text(
                            product['Usage'],
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                          )
                      ],
                    ),
                )],
                ),
              );
            },
          ),
       bottomNavigationBar: BottomAppBar(
          
       ),
    );
  }

  Widget box(String title){
     return Container(
        margin: EdgeInsets.all(10),
        width: 20,
        color: Colors.black,
        alignment: Alignment.center,
        child: ElevatedButton(onPressed: null, child: Text(title))
     );
  }
}