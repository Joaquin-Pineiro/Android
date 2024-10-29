import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/breeds_info_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/breeds_detail_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/breeds_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/config_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/login_detail_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/notifiers/login_notifier.dart';
import 'package:parcial_1_pineiro/viewmodels/states/breed_info_state.dart';
import 'package:parcial_1_pineiro/viewmodels/states/breeds_detail_state.dart';
import 'package:parcial_1_pineiro/viewmodels/states/breeds_state.dart';
import 'package:parcial_1_pineiro/viewmodels/states/config_state.dart';
import 'package:parcial_1_pineiro/viewmodels/states/login_detail_state.dart';
import 'package:parcial_1_pineiro/viewmodels/states/login_state.dart';

final loginViewModelProvider =
    NotifierProvider<LoginNotifier, LoginState>(LoginNotifier.new);
final loginDetailViewModelProvider =
    NotifierProvider<LoginDetailNotifier, LoginDetailState>(
        LoginDetailNotifier.new);
final breedsViewModelProvider =
    NotifierProvider<BreedsNotifier, BreedsState>(BreedsNotifier.new);

final breedsDetailViewModelProvider =
    NotifierProvider<BreedsDetailNotifier, BreedsDetailState>(
        BreedsDetailNotifier.new);
final breedsInfoViewModelProvider =
    NotifierProvider<BreedsInfoNotifier, BreedsInfoState>(
        BreedsInfoNotifier.new);

final configViewModelProvider =
    NotifierProvider<ConfigNotifier, ConfigState>(ConfigNotifier.new);
