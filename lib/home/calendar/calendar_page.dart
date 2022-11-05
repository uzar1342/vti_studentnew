import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vti_student/configs/globals.dart';
import 'package:vti_student/configs/urls.dart';
import 'package:vti_student/home/calendar/attendance/attendance_page.dart';

class CalendarPage extends StatefulWidget {
  final List lecutres;
  const CalendarPage({Key? key, required this.lecutres}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat calendarFormat = CalendarFormat.twoWeeks;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final DateFormat formatter = DateFormat('dd-MM-yyy');
  bool isLoading = true;

  List<dynamic> calevents = [];
  Map<String, List<dynamic>> events = {};
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  // fetchLectures() async {
  //   final url = Uri.parse(Urls().lectureScheduleUrl);

  //   var body = json.encode([
  //     {
  //       "mobile_number": userPhone,
  //       "student_id": userId,
  //       "course_id": widget.courseId,
  //     }
  //   ]);
  // }

  fetchLectures() async {
    for (int i = 0; i < widget.lecutres.length; i++) {
      events[widget.lecutres[i]['lecture_date']] = [widget.lecutres[i]];
      _selectedEvents.value =
          _getEventsForDay(formatter.parse(widget.lecutres[i]['lecture_date']));
      _getEventsForDay(formatter.parse(widget.lecutres[i]['lecture_date']));
    }
    setState(() {
      isLoading = false;
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final formatted = formatter.format(day);
    return events[formatted] ?? [];
  }

  @override
  void initState() {
    final selectedDayFormattedDate = formatter.format(selectedDay);
    _selectedEvents = ValueNotifier(
        _getEventsForDay(formatter.parse(selectedDayFormattedDate)));
    fetchLectures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Container(
              padding: const EdgeInsets.only(top: 0.0),
              height: h * 0.09,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        // top: 10.0,
                        left: 15.0,
                      ),
                      //padding: const EdgeInsets.only(left: 5.0),
                      height: h * 0.05,
                      width: h * 0.05,
                      decoration: BoxDecoration(
                          // color: primaryColor,
                          border: Border.all(color: Colors.black26, width: 1.0),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12.0))),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                        size: 18.0,
                      ),
                    ),
                  ),
                  Text(
                    "Time table",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AttendancePage()));
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.chartArea,
                      color: primaryColor,
                      size: 25,
                    ),
                  ),
                ],
              )),
          //SizedBox(height: h * 0.02),
          Expanded(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              (isLoading == false)
                  ? TableCalendar(
                      focusedDay: focusedDay,
                      firstDay: DateTime.utc(2018),
                      lastDay: DateTime.utc(2030),
                      rowHeight: 60,
                      eventLoader: _getEventsForDay,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: true,
                        todayDecoration: BoxDecoration(
                            color: Colors.orange.shade200,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10)),
                        selectedDecoration: BoxDecoration(
                            color: primaryColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10)),
                        defaultDecoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10)),
                        weekendDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        disabledDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        holidayDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10)),
                        outsideDecoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10)),
                        markersAnchor: 1.2,
                        markersMaxCount: 5,
                      ),
                      calendarBuilders: CalendarBuilders(
                          singleMarkerBuilder: (context, date, event) {
                        return Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        );
                      }),
                      //Day Change and focus change
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDay, day);
                      },
                      onDaySelected: (DateTime selectday, DateTime focusDay) {
                        setState(() {
                          selectedDay = selectday;

                          focusedDay = focusDay;
                        });
                        _selectedEvents.value = _getEventsForDay(selectday);
                      },
                      daysOfWeekVisible: true,
                      headerStyle: HeaderStyle(
                          formatButtonDecoration: BoxDecoration(
                              border: Border.all(color: primaryColor, width: 1),
                              borderRadius: BorderRadius.circular(15)),
                          formatButtonTextStyle: TextStyle(
                              color: primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 18),
                          leftChevronIcon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: const Icon(
                                Icons.chevron_left_outlined,
                                color: Colors.grey,
                                size: 26,
                              )),
                          rightChevronIcon: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(8)),
                              ),
                              child: const Icon(Icons.chevron_right_outlined,
                                  color: Colors.grey, size: 26)),
                          formatButtonVisible: true),
                      onPageChanged: (focusedDay) {
                        focusedDay = focusedDay;
                      },
                      //Format of Calendar week month 2weeks
                      calendarFormat: calendarFormat,
                      onFormatChanged: (CalendarFormat format) {
                        setState(() {
                          calendarFormat = format;
                        });
                      },
                    )
                  : Center(
                      child: SpinKitFadingCube(
                        color: primaryColor,
                      ),
                    ),
              SizedBox(
                height: h * 0.02,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Container(
                    child: ValueListenableBuilder<List<dynamic>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return (value.isEmpty && isLoading == false)
                            ? Center(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/no_data.png",
                                    width: 300,
                                    height: 300,
                                  ),
                                  Text(
                                    "No Lectures Scheduled",
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ))
                            : MediaQuery.removePadding(
                                removeTop: true,
                                context: context,
                                child: ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    itemCount: value.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        width: w,
                                        margin: const EdgeInsets.all(5.0),
                                        child: Card(
                                          elevation: 3.0,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(14.0))),
                                          child: Container(
                                            padding: const EdgeInsets.all(10.0),
                                            decoration: BoxDecoration(
                                              color: index % 2 == 0
                                                  ? Colors.green
                                                      .withOpacity(0.1)
                                                  : Colors.amber
                                                      .withOpacity(0.1),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(14.0),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Image.asset(
                                                          "assets/images/python_logo.png",
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.02,
                                                        ),
                                                        const Text(
                                                          "Django Framework",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16.0),
                                                        )
                                                      ],
                                                    ),
                                                    value[index][
                                                                'training_mode'] ==
                                                            "Online"
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            height: h * 0.04,
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .green,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20.0))),
                                                            child: Row(
                                                              children: [
                                                                const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .globe,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20.0,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      w * 0.01,
                                                                ),
                                                                const Text(
                                                                  "Online",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            height: h * 0.04,
                                                            decoration: const BoxDecoration(
                                                                color:
                                                                    Colors.blue,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20.0))),
                                                            child: Row(
                                                              children: [
                                                                const FaIcon(
                                                                  FontAwesomeIcons
                                                                      .school,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 20.0,
                                                                ),
                                                                SizedBox(
                                                                  width:
                                                                      w * 0.01,
                                                                ),
                                                                const Text(
                                                                  "Offline",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                  ],
                                                ),
                                                const Divider(),
                                                Row(
                                                  children: [
                                                    const Text(
                                                      "Chapter : ",
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Learning the basic",
                                                      style: TextStyle(
                                                          color: primaryColor,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Instructor : ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 13.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(
                                                          value[index]
                                                              ['faculty_name'],
                                                          style: TextStyle(
                                                              color:
                                                                  primaryColor,
                                                              fontSize: 15.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.date_range,
                                                          color: Colors
                                                              .purple.shade200,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.02,
                                                        ),
                                                        Text(
                                                          "${value[index]['day']} | ${value[index]['lecture_date']}",
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const Divider(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_filled,
                                                          color: Colors
                                                              .green.shade200,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.01,
                                                        ),
                                                        Text(
                                                            value[index]
                                                                ['start_time'],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black54)),
                                                      ],
                                                    ),
                                                    const Text(
                                                      "To",
                                                      style: TextStyle(
                                                          color: Colors.black38,
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .access_time_filled,
                                                          color: Colors
                                                              .red.shade200,
                                                        ),
                                                        SizedBox(
                                                          width: w * 0.01,
                                                        ),
                                                        Text(
                                                            value[index]
                                                                ['end_time'],
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black54)),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              );
                      },
                    ),
                  ),
                ),
              )
            ],
          )),
        ],
      )),
    );
  }
}
