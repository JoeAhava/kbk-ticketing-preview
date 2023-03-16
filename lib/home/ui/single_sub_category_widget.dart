import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticketing/home/bloc/category_bloc/event_list_bloc.dart';
import 'package:ticketing/home/bloc/schedule_cubit/schedule_cubit.dart';
import 'package:ticketing/home/bloc/schedule_cubit/schedule_state.dart';
import 'package:ticketing/home/bloc/sub_category_bloc/sub_category_bloc.dart';
import 'package:ticketing/home/models/category.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/home/ui/event_list_page.dart';
import 'package:ticketing/home/ui/single_event_page.dart';

class SingleSubCategory extends StatefulWidget {
  const SingleSubCategory({this.subCategory, this.category});

  final SubCategory subCategory;
  final Category category;

  @override
  _SingleSubCategoryState createState() => _SingleSubCategoryState();
}

class _SingleSubCategoryState extends State<SingleSubCategory> {
  DateTime _dateTime = DateTime.now();
  _selectDate(BuildContext context, {List<DateTime> dates = const []}) async {
    print("Dates:");
    print(dates);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: dates.length > 0 ? dates.first : _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(9999),
      selectableDayPredicate: (DateTime date) => dates.contains(date),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.dark(
      //         primary: Colors.blueAccent,
      //         onPrimary: Colors.white,
      //         surface: Colors.blue,
      //         onSurface: Colors.white,
      //         secondaryVariant: Colors.red,
      //       ),
      //       dialogBackgroundColor: Colors.grey[850],
      //     ),
      //     child: child,
      //   );
      // },
    );
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = picked;
      });
      context.read<ScheduleCubit>().pickDate(this._dateTime);
      // Navigator.of(context).push(EventListPage.route(widget.category.title,));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleCubit, ScheduleState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _selectDate(context,
              dates: (this
                  .widget
                  .subCategory
                  .schedule
                  .map((e) => e.movieStartTime)
                  .toList())[0]),
          child: Container(
            height: 60,
            margin: EdgeInsets.only(bottom: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.lightBlueAccent.withOpacity(1),
                image: widget.subCategory.imageUrl != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.subCategory.imageUrl))
                    : null),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.black.withOpacity(0.5),
              ),
              child: Text(
                widget.subCategory.name,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SingleItem extends StatelessWidget {
  const SingleItem({this.subCategory});

  final SubCategory subCategory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(EventListPage.route(subCategory));
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.only(bottom: 15),
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.lightBlueAccent.withOpacity(1),
            image: subCategory.imageUrl != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(subCategory.imageUrl))
                : null),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.black.withOpacity(0.5),
          ),
          child: Text(
            subCategory.name ?? '',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
