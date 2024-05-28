// import 'dart:convert';
// import 'package:bepocart/changepassword.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class OtpPage extends StatefulWidget {
//    OtpPage({Key? key}) : super(key: key);

//   @override
//   State<OtpPage> createState() => _OtpPageState();
// }

// class _OtpPageState extends State<OtpPage> {
//   List<TextEditingController> controllers =
//       List.generate(6, (_) => TextEditingController());
//   var url = "https://c05e-59-92-206-153.ngrok-free.app/otp-verfication/";

//   Future<void> otpverify() async {
//     try {
//       String otpCode = controllers.map((controller) => controller.text).join();
//       print("===========================$otpCode");
//       var response = await http.post(
//         Uri.parse(url),
//         body: {
//           "otp_code": otpCode
//           },
//       );
//       print(response.statusCode);
//       if (response.statusCode == 200) {
//         var responseData = jsonDecode(response.body);
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => changepassword()),
//         );
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Text(
//               "Verification Code",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Text(
//               "We have sent the verification code to your registered Email.",
//               style: TextStyle(color: Colors.grey),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: List.generate(
//                 6,
//                 (index) => Expanded(
//                   child: Padding(  
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: TextField(
//                       controller: controllers[index],
//                       keyboardType: TextInputType.number,
//                       maxLength: 1,
//                       textAlign: TextAlign.center,
//                       decoration: InputDecoration(
//                         counter: Offstage(),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.blue),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 1 && index < 5) {
//                           FocusScope.of(context).nextFocus();
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(height: 20),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20.0),
//             child: SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: () {
//                   otpverify();
//                   // Uncomment the line below if you want to navigate to another page
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => changepassword()));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Confirm',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:convert';

import 'package:bepocart/changepassword.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
var email;
  OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  var url = "https://c05e-59-92-206-153.ngrok-free.app/otp-verify/";
  TextEditingController otpController = TextEditingController();

  Future<void> sendOtp() async {
    try {
       print("haiiiiiii");
      var response = await http.post(
        Uri.parse(url),
        headers: {
        
        'Content-Type': 'application/json; charset=UTF-8',

       },
        body: jsonEncode({
          "otp": otpController.text,
          "email":widget.email
          }),
      );
      print("${response.body}");

      print(response.statusCode);
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => changepassword(email:widget.email)),
        );
      } else {
        var responseData = jsonDecode(response.body);
        print("Error: ${responseData['message']}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid OTP. Please try again."),
        ));
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An unexpected error occurred. Please try again later."),
      ));
    }
// print(widget.otp.toString());
// print(otpController.text);
//     if(widget.otp.toString()==otpController.text){

//       Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => changepassword()),
//         );

//     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Reset Password!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                           children: [
                                SizedBox(height: 15),
                                TextField(
                                  controller: otpController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'OTP',
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: const Color.fromARGB(
                                              255, 165, 165, 165)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                                  255, 170, 170, 170)
                                              .withOpacity(0.5)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 188, 2, 2)),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 16.0),
                                  ),
                                ),
                                SizedBox(height: 15),
                              ],
                            ),


                
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            child: TextButton(
                              onPressed: () async {
                                sendOtp();
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

