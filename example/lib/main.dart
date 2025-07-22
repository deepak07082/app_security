import 'package:app_security/app_security.dart';
import 'package:app_security/window_flags.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> results = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      var res = await AppSecurity.isUseJailBrokenOrRoot() ?? 'Unknown';
      results['ROOTED'] = res;
      var res1 = await AppSecurity.isDeviceUseVPN() ?? 'Unknown';
      results['VPN'] = res1;
      var res2 = await AppSecurity.isItRealDevice() ?? 'Unknown';
      results['REAL DEVICE'] = res2;
      var res3 = await AppSecurity.checkIsTheDeveloperModeOn() ?? 'Unknown';
      results['DEVOLPER MODE ON'] = res3;
      var res4 = await AppSecurity.isRunningInTestFlight() ?? 'Unknown';
      results['RUNNING ON TESTFLIGHT'] = res4;
      var res5 = await AppSecurity.getIMEI() ?? 'Unknown';
      results['IMEI'] = res5;
      var res6 = await AppSecurity.getDeviceId() ?? 'Unknown';
      results['DEVICE ID'] = res6;
      var res7 = await AppSecurity.installedSource() ?? 'Unknown';
      results['INSTALL SOURCE'] = res7;
      var res8 =
          await AppSecurity.installedFromValidSource(['pc']) ?? 'Unknown';
      results['SOURCE VALID'] = res8;
      var res9 = await AppSecurity.isClonedApp();
      results['IS CLONED APP'] = res9;
    } catch (e) {
      debugPrint('e: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var keys = results.keys.toList();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'APP SECURITY',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 40),
              ListView.separated(
                itemCount: keys.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text(
                          keys[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Expanded(child: Text(results[keys[index]].toString())),
                    ],
                  );
                },
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Open developer settings',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey),
                      ),
                      onPressed: () {
                        AppSecurity.openDeveloperSettings();
                      },
                      child: Text('Open'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Set Flag(Secure)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey),
                      ),
                      onPressed: () {
                        AppSecurity.addFlags(WindowFlags.flagSecure);
                      },
                      child: Text('Set'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Clear Flag(Secure)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(':', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey),
                      ),
                      onPressed: () {
                        AppSecurity.clearFlags(WindowFlags.flagSecure);
                      },
                      child: Text('Clear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
