import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:taxi_driver/common/color_extension.dart';
import 'package:taxi_driver/common/common_extension.dart';
import 'package:taxi_driver/common/globs.dart';
import 'package:taxi_driver/common/service_call.dart';

class UserMyRidesView extends StatefulWidget {
  const UserMyRidesView({super.key});

  @override
  State<UserMyRidesView> createState() => _UserMyRidesViewState();
}

class _UserMyRidesViewState extends State<UserMyRidesView> {
  List ridesArr = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiAllRidesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          "My Rides",
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          itemBuilder: (context, index) {
            var rObj = ridesArr[index] as Map? ?? {};
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 2)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: rObj["icon"] as String? ?? "",
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rObj["service_name"] as String? ?? "",
                            style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 17,
                                fontWeight: FontWeight.w800),
                          ),
                          Text(
                            statusWiseDateTime(rObj),
                            style: TextStyle(
                                color: TColor.secondaryText, fontSize: 12),
                          )
                        ],
                      )),
                      Text(
                        statusText(rObj),
                        style: TextStyle(
                            color: statusColor(rObj),
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                  const Divider(),

                 const SizedBox(height: 8,),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: TColor.secondary,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          rObj["pickup_address"] as String? ?? "" ,
                          maxLines: 2,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            color: TColor.primary,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Text(
                          rObj["drop_address"] as String? ?? "",
                          maxLines: 2,
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
          itemCount: ridesArr.length),
    );
  }

  //TODO: ApiCalling

  void apiAllRidesList() {
    Globs.showHUD();
    ServiceCall.post({}, SVKey.svUserAllRides, isTokenApi: true,
        withSuccess: (responseObj) async {
      Globs.hideHUD();
      if (responseObj[KKey.status] == "1") {
        ridesArr = responseObj[KKey.payload] as List? ?? [];

        if (mounted) {
          setState(() {});
        }
      } else {
        mdShowAlert(
            "Error", responseObj[KKey.message] as String? ?? MSG.fail, () {});
      }
    }, failure: (err) async {
      Globs.hideHUD();
      debugPrint(err.toString());
    });
  }

  String statusText(Map rideObj) {
    switch (rideObj["booking_status"]) {
      case 2:
        return "On Way";
      case 3:
        return "Waiting";
      case 4:
        return "Started";
      case 5:
        return "Completed";
      case 6:
        return "Cancel";
      case 7:
        return "No Drivers";
      default:
        return "Pending";
    }
  }

  Color statusColor(Map rideObj) {
    switch (rideObj["booking_status"]) {
      case 2:
        return Colors.green;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.green;
      case 5:
        return Colors.green;
      case 6:
        return Colors.red;
      case 7:
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String statusWiseDateTime(Map rideObj) {
    switch (rideObj["booking_status"]) {
      case 2:
        return (rideObj["accpet_time"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 3:
        return (rideObj["start_time"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 4:
        return (rideObj["start_time"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 5:
        return (rideObj["stop_time"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 6:
        return (rideObj["stop_time"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      case 7:
        return (rideObj["stop_time"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
      default:
        return (rideObj["pickup_date"] as String?)
                ?.dataFormat()
                .stringFormat(format: "dd MMM, yyyy hh:mm a") ??
            "";
    }
  }
}
