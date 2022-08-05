// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../constant.dart';

import '../../login/login_page.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? username = "", email = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  ambildata() async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            insetPadding: const EdgeInsets.only(
                left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
            title: Text("Tentang Aplikasi",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                )),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Sistem Pakar ini merupakan hasil penelitian dosen Universitas Teknologi Mataram yang didanai oleh dana hibah Penelitian Dosen Pemula - Kemdikbudristek tahun 2022.",
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87)),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            actions: [
              SizedBox(
                height: 50.0,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      primary: kblue, // background
                      onPrimary: Colors.white, // foreground
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.close),
                        Center(
                          child: Text('Tutup',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                        ),
                      ],
                    )),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.sp,
          backgroundColor: kblue,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10.sp,
              ),
              Text(
                "Profile,",
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                "Data pribadi anda!",
                style: TextStyle(fontSize: 14.sp),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircleAvatar(
              radius: 65,
              backgroundImage: AssetImage('assets/user.webp'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("$username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: kblue,
                )),
            const SizedBox(
              height: 2,
            ),
            Text("$email",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: kblue,
                )),
            const SizedBox(
              height: 40.0,
              width: 150,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ))),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return UpdateProfile();
                      },
                    ),
                  );
                },
                child: const ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  title: Text('Edit Profile',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(20.0),
            //   child: ElevatedButton(
            //     onPressed: () {},
            //     child: ListTile(
            //       leading: Icon(
            //         Icons.book,
            //         color: Colors.white,
            //       ),
            //       title: Text('Tentang Aplikasi',
            //           style:
            //               TextStyle(color: Colors.white, fontSize: (20.0))),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20.0),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(kred),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ))),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('username');
                  prefs.remove('idUser');
                  prefs.remove('email');
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext ctx) => const LoginPage()));
                },
                child: const ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text('Keluar',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ))),
              ),
            ),
            const SizedBox(height: 20.0),
            TextButton(
                onPressed: ambildata,
                child: Text("SiGis Tetebatu Versi 1.0 ",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: kblue,
                    )))
          ],
        ),
      ),
    );
  }
}
