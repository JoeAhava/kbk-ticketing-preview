import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:ticketing/formz/date.dart';
import 'package:ticketing/formz/required_number.dart';
import 'package:ticketing/formz/required_text.dart';
import 'package:ticketing/formz/time.dart';

enum CreateEventNetworkStatus { loading, created, error }

enum TicketType { free, paid }

class CreateEventState extends Equatable {
  final RequiredText title;
  final RequiredText description;
  final FormzStatus status;
  final Date dateFrom;
  final Time timeFrom;
  final Date dateTo;
  final Time timeTo;
  final Map<String, double> location;
  final List<String> eventCategories;
  final TicketType ticketType;
  final RequiredNumber eventPrice;
  final RequiredText eventCurrency;
  final File image;
  final CreateEventNetworkStatus networkStatus;
  final String error;

  CreateEventState(
      {this.title = const RequiredText.pure(),
      this.description = const RequiredText.pure(),
      this.dateFrom = const Date.pure(),
      this.dateTo = const Date.pure(),
      this.timeFrom = const Time.pure(),
      this.timeTo = const Time.pure(),
      this.location,
      this.eventCategories = const [],
      this.eventPrice = const RequiredNumber.pure(),
      this.eventCurrency = const RequiredText.pure(),
      this.ticketType = TicketType.free,
      this.image,
      this.status,
      this.networkStatus,
      this.error});

  @override
  List<Object> get props => [
        title,
        description,
        dateFrom,
        timeFrom,
        dateTo,
        timeTo,
        networkStatus,
        status,
        location,
        eventCategories,
        eventPrice,
        eventCurrency,
        image,
        ticketType,
        error
      ];

  CreateEventState copyWith(
      {RequiredText title,
      RequiredText description,
      Date dateFrom,
      Time timeFrom,
      Date dateTo,
      Time timeTo,
      Map<String, double> location,
      List<String> eventCategories,
      RequiredNumber eventPrice,
      RequiredText eventCurrency,
      TicketType ticketType,
      File image,
      FormzStatus status,
      CreateEventNetworkStatus networkStatus,
      String error}) {
    return CreateEventState(
      title: title ?? this.title,
      description: description ?? this.description,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      timeFrom: timeFrom ?? this.timeFrom,
      timeTo: timeTo ?? this.timeTo,
      location: location ?? this.location,
      eventCategories: eventCategories ?? this.eventCategories,
      eventPrice: eventPrice ?? this.eventPrice,
      eventCurrency: eventCurrency ?? this.eventCurrency,
      ticketType: ticketType ?? this.ticketType,
      image: image ?? this.image,
      status: status ?? this.status,
      networkStatus: networkStatus ?? this.networkStatus,
      error: error ?? this.error,
    );
  }
}
