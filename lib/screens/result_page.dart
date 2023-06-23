import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final List<dynamic> responseData;

  ResultScreen(this.responseData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(title: Text('Results')),
      body: ListView.builder(
        itemCount: responseData.length,
        itemBuilder: (context, index) {
          final product = responseData[index];
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
                            color: Colors.purple,
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
    );
  }
}
