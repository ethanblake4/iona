// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'package:flutter/widgets.dart';

/// Identifiers for the supported material design icons.
///
/// Use with the [Icon] class to show specific icons.
///
/// Icons are identified by their name as listed below.
///
/// To use this class, make sure you set `uses-material-design: true` in your
/// project's `pubspec.yaml` file in the `flutter` section. This ensures that
/// the MaterialIcons font is included in your application. This font is used to
/// display the icons. For example:
///
/// ```yaml
/// name: my_awesome_application
/// flutter:
///   uses-material-design: true
/// ```
///
/// {@tool snippet}
/// This example shows how to create a [Row] of [Icon]s in different colors and
/// sizes. The first [Icon] uses a [Icon.semanticLabel] to announce in accessibility
/// modes like TalkBack and VoiceOver.
///
/// ![A row of icons representing a pink heart, a green musical note, and a blue umbrella](https://flutter.github.io/assets-for-api-docs/assets/widgets/icon.png)
///
/// ```dart
/// Row(
///   mainAxisAlignment: MainAxisAlignment.spaceAround,
///   children: const <Widget>[
///     Icon(
///       Icons.favorite,
///       color: Colors.pink,
///       size: 24.0,
///       semanticLabel: 'Text to announce in accessibility modes',
///     ),
///     Icon(
///       Icons.audiotrack,
///       color: Colors.green,
///       size: 30.0,
///     ),
///     Icon(
///       Icons.beach_access,
///       color: Colors.blue,
///       size: 36.0,
///     ),
///   ],
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [Icon]
///  * [IconButton]
///  * <https://design.google.com/icons/>

// This class is not meant to be instantiated or extended; this constructor
// prevents instantiation and extension.
// ignore: unused_element
const Map<String, IconData> indexedIcons = {
  // Generated code: do not hand-edit.
  // See https://github.com/flutter/flutter/wiki/Updating-Material-Design-Fonts
  // BEGIN GENERATED

  /// <i class="material-icons md-36">360</i> &#x2014; material icon named "360".
  'threesixty': const IconData(0xe577, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">3d_rotation</i> &#x2014; material icon named "3d rotation".

  /// <i class="material-icons md-36">4k</i> &#x2014, material icon named "4k".
  'four_k': const IconData(0xe072, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">ac_unit</i> &#x2014; material icon named "ac unit".
  'ac_unit': const IconData(0xeb3b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">access_alarm</i> &#x2014; material icon named "access alarm".
  'access_alarm': const IconData(0xe190, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">access_alarms</i> &#x2014; material icon named "access alarms".
  'access_alarms': const IconData(0xe191, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">access_time</i> &#x2014; material icon named "access time".
  'access_time': const IconData(0xe192, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">accessibility</i> &#x2014; material icon named "accessibility".
  'accessibility': const IconData(0xe84e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">accessibility_new</i> &#x2014; material icon named "accessibility new".
  'accessibility_new': const IconData(0xe92c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">accessible</i> &#x2014; material icon named "accessible".
  'accessible': const IconData(0xe914, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">accessible_forward</i> &#x2014; material icon named "accessible forward".
  'accessible_forward': const IconData(0xe934, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">account_balance</i> &#x2014; material icon named "account balance".
  'account_balance': const IconData(0xe84f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">account_balance_wallet</i> &#x2014; material icon named "account balance wallet".
  'account_balance_wallet': const IconData(0xe850, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">account_box</i> &#x2014; material icon named "account box".
  'account_box': const IconData(0xe851, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">account_circle</i> &#x2014; material icon named "account circle".
  'account_circle': const IconData(0xe853, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">adb</i> &#x2014; material icon named "adb".
  'adb': const IconData(0xe60e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add</i> &#x2014; material icon named "add".
  'add': const IconData(0xe145, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_a_photo</i> &#x2014; material icon named "add a photo".
  'add_a_photo': const IconData(0xe439, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_alarm</i> &#x2014; material icon named "add alarm".
  'add_alarm': const IconData(0xe193, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_alert</i> &#x2014; material icon named "add alert".
  'add_alert': const IconData(0xe003, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_box</i> &#x2014; material icon named "add box".
  'add_box': const IconData(0xe146, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_call</i> &#x2014; material icon named "add call".
  'add_call': const IconData(0xe0e8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_circle</i> &#x2014; material icon named "add circle".
  'add_circle': const IconData(0xe147, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_circle_outline</i> &#x2014; material icon named "add circle outline".
  'add_circle_outline': const IconData(0xe148, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_comment</i> &#x2014; material icon named "add comment".
  'add_comment': const IconData(0xe266, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_location</i> &#x2014; material icon named "add location".
  'add_location': const IconData(0xe567, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_photo_alternate</i> &#x2014; material icon named "add photo alternate".
  'add_photo_alternate': const IconData(0xe43e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_shopping_cart</i> &#x2014; material icon named "add shopping cart".
  'add_shopping_cart': const IconData(0xe854, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_to_home_screen</i> &#x2014; material icon named "add to home screen".
  'add_to_home_screen': const IconData(0xe1fe, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_to_photos</i> &#x2014; material icon named "add to photos".
  'add_to_photos': const IconData(0xe39d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">add_to_queue</i> &#x2014; material icon named "add to queue".
  'add_to_queue': const IconData(0xe05c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">adjust</i> &#x2014; material icon named "adjust".
  'adjust': const IconData(0xe39e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_flat</i> &#x2014; material icon named "airline seat flat".
  'airline_seat_flat': const IconData(0xe630, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_flat_angled</i> &#x2014; material icon named "airline seat flat angled".
  'airline_seat_flat_angled': const IconData(0xe631, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_individual_suite</i> &#x2014; material icon named "airline seat individual suite".
  'airline_seat_individual_suite': const IconData(0xe632, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_legroom_extra</i> &#x2014; material icon named "airline seat legroom extra".
  'airline_seat_legroom_extra': const IconData(0xe633, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_legroom_normal</i> &#x2014; material icon named "airline seat legroom normal".
  'airline_seat_legroom_normal': const IconData(0xe634, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_legroom_reduced</i> &#x2014; material icon named "airline seat legroom reduced".
  'airline_seat_legroom_reduced': const IconData(0xe635, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_recline_extra</i> &#x2014; material icon named "airline seat recline extra".
  'airline_seat_recline_extra': const IconData(0xe636, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airline_seat_recline_normal</i> &#x2014; material icon named "airline seat recline normal".
  'airline_seat_recline_normal': const IconData(0xe637, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airplanemode_active</i> &#x2014; material icon named "airplanemode active".
  'airplanemode_active': const IconData(0xe195, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airplanemode_inactive</i> &#x2014; material icon named "airplanemode inactive".
  'airplanemode_inactive': const IconData(0xe194, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airplay</i> &#x2014; material icon named "airplay".
  'airplay': const IconData(0xe055, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">airport_shuttle</i> &#x2014; material icon named "airport shuttle".
  'airport_shuttle': const IconData(0xeb3c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">alarm</i> &#x2014; material icon named "alarm".
  'alarm': const IconData(0xe855, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">alarm_add</i> &#x2014; material icon named "alarm add".
  'alarm_add': const IconData(0xe856, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">alarm_off</i> &#x2014; material icon named "alarm off".
  'alarm_off': const IconData(0xe857, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">alarm_on</i> &#x2014; material icon named "alarm on".
  'alarm_on': const IconData(0xe858, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">album</i> &#x2014; material icon named "album".
  'album': const IconData(0xe019, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">all_inclusive</i> &#x2014; material icon named "all inclusive".
  'all_inclusive': const IconData(0xeb3d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">all_out</i> &#x2014; material icon named "all out".
  'all_out': const IconData(0xe90b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">alternate_email</i> &#x2014; material icon named "alternate email".
  'alternate_email': const IconData(0xe0e6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">android</i> &#x2014; material icon named "android".
  'android': const IconData(0xe859, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">announcement</i> &#x2014; material icon named "announcement".
  'announcement': const IconData(0xe85a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">apps</i> &#x2014; material icon named "apps".
  'apps': const IconData(0xe5c3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">archive</i> &#x2014; material icon named "archive".
  'archive': const IconData(0xe149, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">arrow_back</i> &#x2014; material icon named "arrow back".
  'arrow_back': const IconData(0xe5c4, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">arrow_back_ios</i> &#x2014; material icon named "arrow back ios".
  'arrow_back_ios': const IconData(0xe5e0, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">arrow_downward</i> &#x2014; material icon named "arrow downward".
  'arrow_downward': const IconData(0xe5db, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">arrow_drop_down</i> &#x2014; material icon named "arrow drop down".
  'arrow_drop_down': const IconData(0xe5c5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">arrow_drop_down_circle</i> &#x2014; material icon named "arrow drop down circle".
  'arrow_drop_down_circle': const IconData(0xe5c6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">arrow_drop_up</i> &#x2014; material icon named "arrow drop up".
  'arrow_drop_up': const IconData(0xe5c7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">arrow_forward</i> &#x2014; material icon named "arrow forward".
  'arrow_forward': const IconData(0xe5c8, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">arrow_forward_ios</i> &#x2014; material icon named "arrow forward ios".
  'arrow_forward_ios': const IconData(0xe5e1, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">arrow_left</i> &#x2014; material icon named "arrow left".
  'arrow_left': const IconData(0xe5de, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">arrow_right</i> &#x2014; material icon named "arrow right".
  'arrow_right': const IconData(0xe5df, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">arrow_upward</i> &#x2014; material icon named "arrow upward".
  'arrow_upward': const IconData(0xe5d8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">art_track</i> &#x2014; material icon named "art track".
  'art_track': const IconData(0xe060, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">aspect_ratio</i> &#x2014; material icon named "aspect ratio".
  'aspect_ratio': const IconData(0xe85b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assessment</i> &#x2014; material icon named "assessment".
  'assessment': const IconData(0xe85c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assignment</i> &#x2014; material icon named "assignment".
  'assignment': const IconData(0xe85d, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">assignment_ind</i> &#x2014; material icon named "assignment ind".
  'assignment_ind': const IconData(0xe85e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assignment_late</i> &#x2014; material icon named "assignment late".
  'assignment_late': const IconData(0xe85f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assignment_return</i> &#x2014; material icon named "assignment return".
  'assignment_return': const IconData(0xe860, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">assignment_returned</i> &#x2014; material icon named "assignment returned".
  'assignment_returned': const IconData(0xe861, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assignment_turned_in</i> &#x2014; material icon named "assignment turned in".
  'assignment_turned_in': const IconData(0xe862, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assistant</i> &#x2014; material icon named "assistant".
  'assistant': const IconData(0xe39f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">assistant_photo</i> &#x2014; material icon named "assistant photo".
  'assistant_photo': const IconData(0xe3a0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">atm</i> &#x2014; material icon named "atm".
  'atm': const IconData(0xe573, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">attach_file</i> &#x2014; material icon named "attach file".
  'attach_file': const IconData(0xe226, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">attach_money</i> &#x2014; material icon named "attach money".
  'attach_money': const IconData(0xe227, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">attachment</i> &#x2014; material icon named "attachment".
  'attachment': const IconData(0xe2bc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">audiotrack</i> &#x2014; material icon named "audiotrack".
  'audiotrack': const IconData(0xe3a1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">autorenew</i> &#x2014; material icon named "autorenew".
  'autorenew': const IconData(0xe863, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">av_timer</i> &#x2014; material icon named "av timer".
  'av_timer': const IconData(0xe01b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">backspace</i> &#x2014; material icon named "backspace".
  'backspace': const IconData(0xe14a, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">backup</i> &#x2014; material icon named "backup".
  'backup': const IconData(0xe864, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">battery_alert</i> &#x2014; material icon named "battery alert".
  'battery_alert': const IconData(0xe19c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">battery_charging_full</i> &#x2014; material icon named "battery charging full".
  'battery_charging_full': const IconData(0xe1a3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">battery_full</i> &#x2014; material icon named "battery full".
  'battery_full': const IconData(0xe1a4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">battery_std</i> &#x2014; material icon named "battery std".
  'battery_std': const IconData(0xe1a5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">battery_unknown</i> &#x2014; material icon named "battery unknown".
  'battery_unknown': const IconData(0xe1a6, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">beach_access</i> &#x2014; material icon named "beach access".
  'beach_access': const IconData(0xeb3e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">beenhere</i> &#x2014; material icon named "beenhere".
  'beenhere': const IconData(0xe52d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">block</i> &#x2014; material icon named "block".
  'block': const IconData(0xe14b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bluetooth</i> &#x2014; material icon named "bluetooth".
  'bluetooth': const IconData(0xe1a7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bluetooth_audio</i> &#x2014; material icon named "bluetooth audio".
  'bluetooth_audio': const IconData(0xe60f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bluetooth_connected</i> &#x2014; material icon named "bluetooth connected".
  'bluetooth_connected': const IconData(0xe1a8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bluetooth_disabled</i> &#x2014; material icon named "bluetooth disabled".
  'bluetooth_disabled': const IconData(0xe1a9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bluetooth_searching</i> &#x2014; material icon named "bluetooth searching".
  'bluetooth_searching': const IconData(0xe1aa, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">blur_circular</i> &#x2014; material icon named "blur circular".
  'blur_circular': const IconData(0xe3a2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">blur_linear</i> &#x2014; material icon named "blur linear".
  'blur_linear': const IconData(0xe3a3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">blur_off</i> &#x2014; material icon named "blur off".
  'blur_off': const IconData(0xe3a4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">blur_on</i> &#x2014; material icon named "blur on".
  'blur_on': const IconData(0xe3a5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">book</i> &#x2014; material icon named "book".
  'book': const IconData(0xe865, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bookmark</i> &#x2014; material icon named "bookmark".
  'bookmark': const IconData(0xe866, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bookmark_border</i> &#x2014; material icon named "bookmark border".
  'bookmark_border': const IconData(0xe867, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_all</i> &#x2014; material icon named "border all".
  'border_all': const IconData(0xe228, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_bottom</i> &#x2014; material icon named "border bottom".
  'border_bottom': const IconData(0xe229, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_clear</i> &#x2014; material icon named "border clear".
  'border_clear': const IconData(0xe22a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_color</i> &#x2014; material icon named "border color".
  'border_color': const IconData(0xe22b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_horizontal</i> &#x2014; material icon named "border horizontal".
  'border_horizontal': const IconData(0xe22c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_inner</i> &#x2014; material icon named "border inner".
  'border_inner': const IconData(0xe22d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_left</i> &#x2014; material icon named "border left".
  'border_left': const IconData(0xe22e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_outer</i> &#x2014; material icon named "border outer".
  'border_outer': const IconData(0xe22f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_right</i> &#x2014; material icon named "border right".
  'border_right': const IconData(0xe230, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_style</i> &#x2014; material icon named "border style".
  'border_style': const IconData(0xe231, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_top</i> &#x2014; material icon named "border top".
  'border_top': const IconData(0xe232, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">border_vertical</i> &#x2014; material icon named "border vertical".
  'border_vertical': const IconData(0xe233, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">branding_watermark</i> &#x2014; material icon named "branding watermark".
  'branding_watermark': const IconData(0xe06b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_1</i> &#x2014; material icon named "brightness 1".
  'brightness_1': const IconData(0xe3a6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_2</i> &#x2014; material icon named "brightness 2".
  'brightness_2': const IconData(0xe3a7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_3</i> &#x2014; material icon named "brightness 3".
  'brightness_3': const IconData(0xe3a8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_4</i> &#x2014; material icon named "brightness 4".
  'brightness_4': const IconData(0xe3a9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_5</i> &#x2014; material icon named "brightness 5".
  'brightness_5': const IconData(0xe3aa, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_6</i> &#x2014; material icon named "brightness 6".
  'brightness_6': const IconData(0xe3ab, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_7</i> &#x2014; material icon named "brightness 7".
  'brightness_7': const IconData(0xe3ac, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_auto</i> &#x2014; material icon named "brightness auto".
  'brightness_auto': const IconData(0xe1ab, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_high</i> &#x2014; material icon named "brightness high".
  'brightness_high': const IconData(0xe1ac, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_low</i> &#x2014; material icon named "brightness low".
  'brightness_low': const IconData(0xe1ad, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brightness_medium</i> &#x2014; material icon named "brightness medium".
  'brightness_medium': const IconData(0xe1ae, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">broken_image</i> &#x2014; material icon named "broken image".
  'broken_image': const IconData(0xe3ad, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">brush</i> &#x2014; material icon named "brush".
  'brush': const IconData(0xe3ae, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bubble_chart</i> &#x2014; material icon named "bubble chart".
  'bubble_chart': const IconData(0xe6dd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">bug_report</i> &#x2014; material icon named "bug report".
  'bug_report': const IconData(0xe868, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">build</i> &#x2014; material icon named "build".
  'build': const IconData(0xe869, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">burst_mode</i> &#x2014; material icon named "burst mode".
  'burst_mode': const IconData(0xe43c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">business</i> &#x2014; material icon named "business".
  'business': const IconData(0xe0af, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">business_center</i> &#x2014; material icon named "business center".
  'business_center': const IconData(0xeb3f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cached</i> &#x2014; material icon named "cached".
  'cached': const IconData(0xe86a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cake</i> &#x2014; material icon named "cake".
  'cake': const IconData(0xe7e9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">calendar_today</i> &#x2014; material icon named "calendar today".
  'calendar_today': const IconData(0xe935, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">calendar_view_day</i> &#x2014; material icon named "calendar view day".
  'calendar_view_day': const IconData(0xe936, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">call</i> &#x2014; material icon named "call".
  'call': const IconData(0xe0b0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">call_end</i> &#x2014; material icon named "call end".
  'call_end': const IconData(0xe0b1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">call_made</i> &#x2014; material icon named "call made".
  'call_made': const IconData(0xe0b2, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">call_merge</i> &#x2014; material icon named "call merge".
  'call_merge': const IconData(0xe0b3, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">call_missed</i> &#x2014; material icon named "call missed".
  'call_missed': const IconData(0xe0b4, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">call_missed_outgoing</i> &#x2014; material icon named "call missed outgoing".
  'call_missed_outgoing': const IconData(0xe0e4, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">call_received</i> &#x2014; material icon named "call received".
  'call_received': const IconData(0xe0b5, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">call_split</i> &#x2014; material icon named "call split".
  'call_split': const IconData(0xe0b6, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">call_to_action</i> &#x2014; material icon named "call to action".
  'call_to_action': const IconData(0xe06c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">camera</i> &#x2014; material icon named "camera".
  'camera': const IconData(0xe3af, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">camera_alt</i> &#x2014; material icon named "camera alt".
  'camera_alt': const IconData(0xe3b0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">camera_enhance</i> &#x2014; material icon named "camera enhance".
  'camera_enhance': const IconData(0xe8fc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">camera_front</i> &#x2014; material icon named "camera front".
  'camera_front': const IconData(0xe3b1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">camera_rear</i> &#x2014; material icon named "camera rear".
  'camera_rear': const IconData(0xe3b2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">camera_roll</i> &#x2014; material icon named "camera roll".
  'camera_roll': const IconData(0xe3b3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cancel</i> &#x2014; material icon named "cancel".
  'cancel': const IconData(0xe5c9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">card_giftcard</i> &#x2014; material icon named "card giftcard".
  'card_giftcard': const IconData(0xe8f6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">card_membership</i> &#x2014; material icon named "card membership".
  'card_membership': const IconData(0xe8f7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">card_travel</i> &#x2014; material icon named "card travel".
  'card_travel': const IconData(0xe8f8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">casino</i> &#x2014; material icon named "casino".
  'casino': const IconData(0xeb40, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cast</i> &#x2014; material icon named "cast".
  'cast': const IconData(0xe307, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cast_connected</i> &#x2014; material icon named "cast connected".
  'cast_connected': const IconData(0xe308, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">category</i> &#x2014; material icon named "category".
  'category': const IconData(0xe574, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">center_focus_strong</i> &#x2014; material icon named "center focus strong".
  'center_focus_strong': const IconData(0xe3b4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">center_focus_weak</i> &#x2014; material icon named "center focus weak".
  'center_focus_weak': const IconData(0xe3b5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">change_history</i> &#x2014; material icon named "change history".
  'change_history': const IconData(0xe86b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">chat</i> &#x2014; material icon named "chat".
  'chat': const IconData(0xe0b7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">chat_bubble</i> &#x2014; material icon named "chat bubble".
  'chat_bubble': const IconData(0xe0ca, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">chat_bubble_outline</i> &#x2014; material icon named "chat bubble outline".
  'chat_bubble_outline': const IconData(0xe0cb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">check</i> &#x2014; material icon named "check".
  'check': const IconData(0xe5ca, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">check_box</i> &#x2014; material icon named "check box".
  'check_box': const IconData(0xe834, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">check_box_outline_blank</i> &#x2014; material icon named "check box outline blank".
  'check_box_outline_blank': const IconData(0xe835, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">check_circle</i> &#x2014; material icon named "check circle".
  'check_circle': const IconData(0xe86c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">check_circle_outline</i> &#x2014; material icon named "check circle outline".
  'check_circle_outline': const IconData(0xe92d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">chevron_left</i> &#x2014; material icon named "chevron left".
  'chevron_left': const IconData(0xe5cb, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">chevron_right</i> &#x2014; material icon named "chevron right".
  'chevron_right': const IconData(0xe5cc, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">child_care</i> &#x2014; material icon named "child care".
  'child_care': const IconData(0xeb41, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">child_friendly</i> &#x2014; material icon named "child friendly".
  'child_friendly': const IconData(0xeb42, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">chrome_reader_mode</i> &#x2014; material icon named "chrome reader mode".
  'chrome_reader_mode': const IconData(0xe86d, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">class</i> &#x2014; material icon named "class".
  'class_': const IconData(0xe86e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">clear</i> &#x2014; material icon named "clear".
  'clear': const IconData(0xe14c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">clear_all</i> &#x2014; material icon named "clear all".
  'clear_all': const IconData(0xe0b8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">close</i> &#x2014; material icon named "close".
  'close': const IconData(0xe5cd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">closed_caption</i> &#x2014; material icon named "closed caption".
  'closed_caption': const IconData(0xe01c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud</i> &#x2014; material icon named "cloud".
  'cloud': const IconData(0xe2bd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud_circle</i> &#x2014; material icon named "cloud circle".
  'cloud_circle': const IconData(0xe2be, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud_done</i> &#x2014; material icon named "cloud done".
  'cloud_done': const IconData(0xe2bf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud_download</i> &#x2014; material icon named "cloud download".
  'cloud_download': const IconData(0xe2c0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud_off</i> &#x2014; material icon named "cloud off".
  'cloud_off': const IconData(0xe2c1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud_queue</i> &#x2014; material icon named "cloud queue".
  'cloud_queue': const IconData(0xe2c2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">cloud_upload</i> &#x2014; material icon named "cloud upload".
  'cloud_upload': const IconData(0xe2c3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">code</i> &#x2014; material icon named "code".
  'code': const IconData(0xe86f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">collections</i> &#x2014; material icon named "collections".
  'collections': const IconData(0xe3b6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">collections_bookmark</i> &#x2014; material icon named "collections bookmark".
  'collections_bookmark': const IconData(0xe431, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">color_lens</i> &#x2014; material icon named "color lens".
  'color_lens': const IconData(0xe3b7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">colorize</i> &#x2014; material icon named "colorize".
  'colorize': const IconData(0xe3b8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">comment</i> &#x2014; material icon named "comment".
  'comment': const IconData(0xe0b9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">compare</i> &#x2014; material icon named "compare".
  'compare': const IconData(0xe3b9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">compare_arrows</i> &#x2014; material icon named "compare arrows".
  'compare_arrows': const IconData(0xe915, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">computer</i> &#x2014; material icon named "computer".
  'computer': const IconData(0xe30a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">confirmation_number</i> &#x2014; material icon named "confirmation number".
  'confirmation_number': const IconData(0xe638, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">contact_mail</i> &#x2014; material icon named "contact mail".
  'contact_mail': const IconData(0xe0d0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">contact_phone</i> &#x2014; material icon named "contact phone".
  'contact_phone': const IconData(0xe0cf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">contacts</i> &#x2014; material icon named "contacts".
  'contacts': const IconData(0xe0ba, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">content_copy</i> &#x2014; material icon named "content copy".
  'content_copy': const IconData(0xe14d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">content_cut</i> &#x2014; material icon named "content cut".
  'content_cut': const IconData(0xe14e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">content_paste</i> &#x2014; material icon named "content paste".
  'content_paste': const IconData(0xe14f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">control_point</i> &#x2014; material icon named "control point".
  'control_point': const IconData(0xe3ba, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">control_point_duplicate</i> &#x2014; material icon named "control point duplicate".
  'control_point_duplicate': const IconData(0xe3bb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">copyright</i> &#x2014; material icon named "copyright".
  'copyright': const IconData(0xe90c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">create</i> &#x2014; material icon named "create".
  'create': const IconData(0xe150, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">create_new_folder</i> &#x2014; material icon named "create new folder".
  'create_new_folder': const IconData(0xe2cc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">credit_card</i> &#x2014; material icon named "credit card".
  'credit_card': const IconData(0xe870, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop</i> &#x2014; material icon named "crop".
  'crop': const IconData(0xe3be, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_16_9</i> &#x2014; material icon named "crop 16 9".
  'crop_16_9': const IconData(0xe3bc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_3_2</i> &#x2014; material icon named "crop 3 2".
  'crop_3_2': const IconData(0xe3bd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_5_4</i> &#x2014; material icon named "crop 5 4".
  'crop_5_4': const IconData(0xe3bf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_7_5</i> &#x2014; material icon named "crop 7 5".
  'crop_7_5': const IconData(0xe3c0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_din</i> &#x2014; material icon named "crop din".
  'crop_din': const IconData(0xe3c1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_free</i> &#x2014; material icon named "crop free".
  'crop_free': const IconData(0xe3c2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_landscape</i> &#x2014; material icon named "crop landscape".
  'crop_landscape': const IconData(0xe3c3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_original</i> &#x2014; material icon named "crop original".
  'crop_original': const IconData(0xe3c4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_portrait</i> &#x2014; material icon named "crop portrait".
  'crop_portrait': const IconData(0xe3c5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_rotate</i> &#x2014; material icon named "crop rotate".
  'crop_rotate': const IconData(0xe437, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">crop_square</i> &#x2014; material icon named "crop square".
  'crop_square': const IconData(0xe3c6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dashboard</i> &#x2014; material icon named "dashboard".
  'dashboard': const IconData(0xe871, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">data_usage</i> &#x2014; material icon named "data usage".
  'data_usage': const IconData(0xe1af, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">date_range</i> &#x2014; material icon named "date range".
  'date_range': const IconData(0xe916, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dehaze</i> &#x2014; material icon named "dehaze".
  'dehaze': const IconData(0xe3c7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">delete</i> &#x2014; material icon named "delete".
  'delete': const IconData(0xe872, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">delete_forever</i> &#x2014; material icon named "delete forever".
  'delete_forever': const IconData(0xe92b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">delete_outline</i> &#x2014; material icon named "delete outline".
  'delete_outline': const IconData(0xe92e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">delete_sweep</i> &#x2014; material icon named "delete sweep".
  'delete_sweep': const IconData(0xe16c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">departure_board</i> &#x2014; material icon named "departure board".
  'departure_board': const IconData(0xe576, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">description</i> &#x2014; material icon named "description".
  'description': const IconData(0xe873, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">desktop_mac</i> &#x2014; material icon named "desktop mac".
  'desktop_mac': const IconData(0xe30b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">desktop_windows</i> &#x2014; material icon named "desktop windows".
  'desktop_windows': const IconData(0xe30c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">details</i> &#x2014; material icon named "details".
  'details': const IconData(0xe3c8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">developer_board</i> &#x2014; material icon named "developer board".
  'developer_board': const IconData(0xe30d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">developer_mode</i> &#x2014; material icon named "developer mode".
  'developer_mode': const IconData(0xe1b0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">device_hub</i> &#x2014; material icon named "device hub".
  'device_hub': const IconData(0xe335, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">device_unknown</i> &#x2014; material icon named "device unknown".
  'device_unknown': const IconData(0xe339, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">devices</i> &#x2014; material icon named "devices".
  'devices': const IconData(0xe1b1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">devices_other</i> &#x2014; material icon named "devices other".
  'devices_other': const IconData(0xe337, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dialer_sip</i> &#x2014; material icon named "dialer sip".
  'dialer_sip': const IconData(0xe0bb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dialpad</i> &#x2014; material icon named "dialpad".
  'dialpad': const IconData(0xe0bc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions</i> &#x2014; material icon named "directions".
  'directions': const IconData(0xe52e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_bike</i> &#x2014; material icon named "directions bike".
  'directions_bike': const IconData(0xe52f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_boat</i> &#x2014; material icon named "directions boat".
  'directions_boat': const IconData(0xe532, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_bus</i> &#x2014; material icon named "directions bus".
  'directions_bus': const IconData(0xe530, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_car</i> &#x2014; material icon named "directions car".
  'directions_car': const IconData(0xe531, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_railway</i> &#x2014; material icon named "directions railway".
  'directions_railway': const IconData(0xe534, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_run</i> &#x2014; material icon named "directions run".
  'directions_run': const IconData(0xe566, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_subway</i> &#x2014; material icon named "directions subway".
  'directions_subway': const IconData(0xe533, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_transit</i> &#x2014; material icon named "directions transit".
  'directions_transit': const IconData(0xe535, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">directions_walk</i> &#x2014; material icon named "directions walk".
  'directions_walk': const IconData(0xe536, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">disc_full</i> &#x2014; material icon named "disc full".
  'disc_full': const IconData(0xe610, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dns</i> &#x2014; material icon named "dns".
  'dns': const IconData(0xe875, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">do_not_disturb</i> &#x2014; material icon named "do not disturb".
  'do_not_disturb': const IconData(0xe612, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">do_not_disturb_alt</i> &#x2014; material icon named "do not disturb alt".
  'do_not_disturb_alt': const IconData(0xe611, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">do_not_disturb_off</i> &#x2014; material icon named "do not disturb off".
  'do_not_disturb_off': const IconData(0xe643, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">do_not_disturb_on</i> &#x2014; material icon named "do not disturb on".
  'do_not_disturb_on': const IconData(0xe644, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dock</i> &#x2014; material icon named "dock".
  'dock': const IconData(0xe30e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">domain</i> &#x2014; material icon named "domain".
  'domain': const IconData(0xe7ee, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">done</i> &#x2014; material icon named "done".
  'done': const IconData(0xe876, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">done_all</i> &#x2014; material icon named "done all".
  'done_all': const IconData(0xe877, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">done_outline</i> &#x2014; material icon named "done outline".
  'done_outline': const IconData(0xe92f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">donut_large</i> &#x2014; material icon named "donut large".
  'donut_large': const IconData(0xe917, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">donut_small</i> &#x2014; material icon named "donut small".
  'donut_small': const IconData(0xe918, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">drafts</i> &#x2014; material icon named "drafts".
  'drafts': const IconData(0xe151, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">drag_handle</i> &#x2014; material icon named "drag handle".
  'drag_handle': const IconData(0xe25d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">drive_eta</i> &#x2014; material icon named "drive eta".
  'drive_eta': const IconData(0xe613, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">dvr</i> &#x2014; material icon named "dvr".
  'dvr': const IconData(0xe1b2, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">edit</i> &#x2014; material icon named "edit".
  'edit': const IconData(0xe3c9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">edit_attributes</i> &#x2014; material icon named "edit attributes".
  'edit_attributes': const IconData(0xe578, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">edit_location</i> &#x2014; material icon named "edit location".
  'edit_location': const IconData(0xe568, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">eject</i> &#x2014; material icon named "eject".
  'eject': const IconData(0xe8fb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">email</i> &#x2014; material icon named "email".
  'email': const IconData(0xe0be, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">enhanced_encryption</i> &#x2014; material icon named "enhanced encryption".
  'enhanced_encryption': const IconData(0xe63f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">equalizer</i> &#x2014; material icon named "equalizer".
  'equalizer': const IconData(0xe01d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">error</i> &#x2014; material icon named "error".
  'error': const IconData(0xe000, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">error_outline</i> &#x2014; material icon named "error outline".
  'error_outline': const IconData(0xe001, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">euro_symbol</i> &#x2014; material icon named "euro symbol".
  'euro_symbol': const IconData(0xe926, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">ev_station</i> &#x2014; material icon named "ev station".
  'ev_station': const IconData(0xe56d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">event</i> &#x2014; material icon named "event".
  'event': const IconData(0xe878, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">event_available</i> &#x2014; material icon named "event available".
  'event_available': const IconData(0xe614, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">event_busy</i> &#x2014; material icon named "event busy".
  'event_busy': const IconData(0xe615, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">event_note</i> &#x2014; material icon named "event note".
  'event_note': const IconData(0xe616, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">event_seat</i> &#x2014; material icon named "event seat".
  'event_seat': const IconData(0xe903, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exit_to_app</i> &#x2014; material icon named "exit to app".
  'exit_to_app': const IconData(0xe879, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">expand_less</i> &#x2014; material icon named "expand less".
  'expand_less': const IconData(0xe5ce, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">expand_more</i> &#x2014; material icon named "expand more".
  'expand_more': const IconData(0xe5cf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">explicit</i> &#x2014; material icon named "explicit".
  'explicit': const IconData(0xe01e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">explore</i> &#x2014; material icon named "explore".
  'explore': const IconData(0xe87a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exposure</i> &#x2014; material icon named "exposure".
  'exposure': const IconData(0xe3ca, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exposure_neg_1</i> &#x2014; material icon named "exposure neg 1".
  'exposure_neg_1': const IconData(0xe3cb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exposure_neg_2</i> &#x2014; material icon named "exposure neg 2".
  'exposure_neg_2': const IconData(0xe3cc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exposure_plus_1</i> &#x2014; material icon named "exposure plus 1".
  'exposure_plus_1': const IconData(0xe3cd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exposure_plus_2</i> &#x2014; material icon named "exposure plus 2".
  'exposure_plus_2': const IconData(0xe3ce, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">exposure_zero</i> &#x2014; material icon named "exposure zero".
  'exposure_zero': const IconData(0xe3cf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">extension</i> &#x2014; material icon named "extension".
  'extension': const IconData(0xe87b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">face</i> &#x2014; material icon named "face".
  'face': const IconData(0xe87c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fast_forward</i> &#x2014; material icon named "fast forward".
  'fast_forward': const IconData(0xe01f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fast_rewind</i> &#x2014; material icon named "fast rewind".
  'fast_rewind': const IconData(0xe020, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fastfood</i> &#x2014; material icon named "fastfood".
  'fastfood': const IconData(0xe57a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">favorite</i> &#x2014; material icon named "favorite".
  'favorite': const IconData(0xe87d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">favorite_border</i> &#x2014; material icon named "favorite border".
  'favorite_border': const IconData(0xe87e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">featured_play_list</i> &#x2014; material icon named "featured play list".
  'featured_play_list': const IconData(0xe06d, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">featured_video</i> &#x2014; material icon named "featured video".
  'featured_video': const IconData(0xe06e, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">feedback</i> &#x2014; material icon named "feedback".
  'feedback': const IconData(0xe87f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fiber_dvr</i> &#x2014; material icon named "fiber dvr".
  'fiber_dvr': const IconData(0xe05d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fiber_manual_record</i> &#x2014; material icon named "fiber manual record".
  'fiber_manual_record': const IconData(0xe061, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fiber_new</i> &#x2014; material icon named "fiber new".
  'fiber_new': const IconData(0xe05e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fiber_pin</i> &#x2014; material icon named "fiber pin".
  'fiber_pin': const IconData(0xe06a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fiber_smart_record</i> &#x2014; material icon named "fiber smart record".
  'fiber_smart_record': const IconData(0xe062, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">file_download</i> &#x2014; material icon named "file download".
  'file_download': const IconData(0xe2c4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">file_upload</i> &#x2014; material icon named "file upload".
  'file_upload': const IconData(0xe2c6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter</i> &#x2014; material icon named "filter".
  'filter': const IconData(0xe3d3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_1</i> &#x2014; material icon named "filter 1".
  'filter_1': const IconData(0xe3d0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_2</i> &#x2014; material icon named "filter 2".
  'filter_2': const IconData(0xe3d1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_3</i> &#x2014; material icon named "filter 3".
  'filter_3': const IconData(0xe3d2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_4</i> &#x2014; material icon named "filter 4".
  'filter_4': const IconData(0xe3d4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_5</i> &#x2014; material icon named "filter 5".
  'filter_5': const IconData(0xe3d5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_6</i> &#x2014; material icon named "filter 6".
  'filter_6': const IconData(0xe3d6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_7</i> &#x2014; material icon named "filter 7".
  'filter_7': const IconData(0xe3d7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_8</i> &#x2014; material icon named "filter 8".
  'filter_8': const IconData(0xe3d8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_9</i> &#x2014; material icon named "filter 9".
  'filter_9': const IconData(0xe3d9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_9_plus</i> &#x2014; material icon named "filter 9 plus".
  'filter_9_plus': const IconData(0xe3da, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_b_and_w</i> &#x2014; material icon named "filter b and w".
  'filter_b_and_w': const IconData(0xe3db, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_center_focus</i> &#x2014; material icon named "filter center focus".
  'filter_center_focus': const IconData(0xe3dc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_drama</i> &#x2014; material icon named "filter drama".
  'filter_drama': const IconData(0xe3dd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_frames</i> &#x2014; material icon named "filter frames".
  'filter_frames': const IconData(0xe3de, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_hdr</i> &#x2014; material icon named "filter hdr".
  'filter_hdr': const IconData(0xe3df, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_list</i> &#x2014; material icon named "filter list".
  'filter_list': const IconData(0xe152, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_none</i> &#x2014; material icon named "filter none".
  'filter_none': const IconData(0xe3e0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_tilt_shift</i> &#x2014; material icon named "filter tilt shift".
  'filter_tilt_shift': const IconData(0xe3e2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">filter_vintage</i> &#x2014; material icon named "filter vintage".
  'filter_vintage': const IconData(0xe3e3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">find_in_page</i> &#x2014; material icon named "find in page".
  'find_in_page': const IconData(0xe880, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">find_replace</i> &#x2014; material icon named "find replace".
  'find_replace': const IconData(0xe881, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fingerprint</i> &#x2014; material icon named "fingerprint".
  'fingerprint': const IconData(0xe90d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">first_page</i> &#x2014; material icon named "first page".
  'first_page': const IconData(0xe5dc, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">fitness_center</i> &#x2014; material icon named "fitness center".
  'fitness_center': const IconData(0xeb43, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flag</i> &#x2014; material icon named "flag".
  'flag': const IconData(0xe153, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flare</i> &#x2014; material icon named "flare".
  'flare': const IconData(0xe3e4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flash_auto</i> &#x2014; material icon named "flash auto".
  'flash_auto': const IconData(0xe3e5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flash_off</i> &#x2014; material icon named "flash off".
  'flash_off': const IconData(0xe3e6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flash_on</i> &#x2014; material icon named "flash on".
  'flash_on': const IconData(0xe3e7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flight</i> &#x2014; material icon named "flight".
  'flight': const IconData(0xe539, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flight_land</i> &#x2014; material icon named "flight land".
  'flight_land': const IconData(0xe904, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">flight_takeoff</i> &#x2014; material icon named "flight takeoff".
  'flight_takeoff': const IconData(0xe905, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">flip</i> &#x2014; material icon named "flip".
  'flip': const IconData(0xe3e8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flip_to_back</i> &#x2014; material icon named "flip to back".
  'flip_to_back': const IconData(0xe882, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">flip_to_front</i> &#x2014; material icon named "flip to front".
  'flip_to_front': const IconData(0xe883, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">folder</i> &#x2014; material icon named "folder".
  'folder': const IconData(0xe2c7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">folder_open</i> &#x2014; material icon named "folder open".
  'folder_open': const IconData(0xe2c8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">folder_shared</i> &#x2014; material icon named "folder shared".
  'folder_shared': const IconData(0xe2c9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">folder_special</i> &#x2014; material icon named "folder special".
  'folder_special': const IconData(0xe617, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">font_download</i> &#x2014; material icon named "font download".
  'font_download': const IconData(0xe167, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_align_center</i> &#x2014; material icon named "format align center".
  'format_align_center': const IconData(0xe234, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_align_justify</i> &#x2014; material icon named "format align justify".
  'format_align_justify': const IconData(0xe235, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_align_left</i> &#x2014; material icon named "format align left".
  'format_align_left': const IconData(0xe236, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_align_right</i> &#x2014; material icon named "format align right".
  'format_align_right': const IconData(0xe237, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_bold</i> &#x2014; material icon named "format bold".
  'format_bold': const IconData(0xe238, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_clear</i> &#x2014; material icon named "format clear".
  'format_clear': const IconData(0xe239, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_color_fill</i> &#x2014; material icon named "format color fill".
  'format_color_fill': const IconData(0xe23a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_color_reset</i> &#x2014; material icon named "format color reset".
  'format_color_reset': const IconData(0xe23b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_color_text</i> &#x2014; material icon named "format color text".
  'format_color_text': const IconData(0xe23c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_indent_decrease</i> &#x2014; material icon named "format indent decrease".
  'format_indent_decrease': const IconData(0xe23d, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">format_indent_increase</i> &#x2014; material icon named "format indent increase".
  'format_indent_increase': const IconData(0xe23e, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">format_italic</i> &#x2014; material icon named "format italic".
  'format_italic': const IconData(0xe23f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_line_spacing</i> &#x2014; material icon named "format line spacing".
  'format_line_spacing': const IconData(0xe240, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_list_bulleted</i> &#x2014; material icon named "format list bulleted".
  'format_list_bulleted': const IconData(0xe241, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">format_list_numbered</i> &#x2014; material icon named "format list numbered".
  'format_list_numbered': const IconData(0xe242, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_list_numbered_rtl</i> &#x2014; material icon named "format list numbered rtl".
  'format_list_numbered_rtl': const IconData(0xe267, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_paint</i> &#x2014; material icon named "format paint".
  'format_paint': const IconData(0xe243, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_quote</i> &#x2014; material icon named "format quote".
  'format_quote': const IconData(0xe244, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_shapes</i> &#x2014; material icon named "format shapes".
  'format_shapes': const IconData(0xe25e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_size</i> &#x2014; material icon named "format size".
  'format_size': const IconData(0xe245, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_strikethrough</i> &#x2014; material icon named "format strikethrough".
  'format_strikethrough': const IconData(0xe246, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_textdirection_l_to_r</i> &#x2014; material icon named "format textdirection l to r".
  'format_textdirection_l_to_r': const IconData(0xe247, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_textdirection_r_to_l</i> &#x2014; material icon named "format textdirection r to l".
  'format_textdirection_r_to_l': const IconData(0xe248, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">format_underlined</i> &#x2014; material icon named "format underlined".
  'format_underlined': const IconData(0xe249, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">forum</i> &#x2014; material icon named "forum".
  'forum': const IconData(0xe0bf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">forward</i> &#x2014; material icon named "forward".
  'forward': const IconData(0xe154, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">forward_10</i> &#x2014; material icon named "forward 10".
  'forward_10': const IconData(0xe056, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">forward_30</i> &#x2014; material icon named "forward 30".
  'forward_30': const IconData(0xe057, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">forward_5</i> &#x2014; material icon named "forward 5".
  'forward_5': const IconData(0xe058, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">free_breakfast</i> &#x2014; material icon named "free breakfast".
  'free_breakfast': const IconData(0xeb44, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fullscreen</i> &#x2014; material icon named "fullscreen".
  'fullscreen': const IconData(0xe5d0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">fullscreen_exit</i> &#x2014; material icon named "fullscreen exit".
  'fullscreen_exit': const IconData(0xe5d1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">functions</i> &#x2014; material icon named "functions".
  'functions': const IconData(0xe24a, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">g_translate</i> &#x2014; material icon named "g translate".
  'g_translate': const IconData(0xe927, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gamepad</i> &#x2014; material icon named "gamepad".
  'gamepad': const IconData(0xe30f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">games</i> &#x2014; material icon named "games".
  'games': const IconData(0xe021, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gavel</i> &#x2014; material icon named "gavel".
  'gavel': const IconData(0xe90e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gesture</i> &#x2014; material icon named "gesture".
  'gesture': const IconData(0xe155, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">get_app</i> &#x2014; material icon named "get app".
  'get_app': const IconData(0xe884, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gif</i> &#x2014; material icon named "gif".
  'gif': const IconData(0xe908, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">golf_course</i> &#x2014; material icon named "golf course".
  'golf_course': const IconData(0xeb45, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gps_fixed</i> &#x2014; material icon named "gps fixed".
  'gps_fixed': const IconData(0xe1b3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gps_not_fixed</i> &#x2014; material icon named "gps not fixed".
  'gps_not_fixed': const IconData(0xe1b4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gps_off</i> &#x2014; material icon named "gps off".
  'gps_off': const IconData(0xe1b5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">grade</i> &#x2014; material icon named "grade".
  'grade': const IconData(0xe885, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">gradient</i> &#x2014; material icon named "gradient".
  'gradient': const IconData(0xe3e9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">grain</i> &#x2014; material icon named "grain".
  'grain': const IconData(0xe3ea, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">graphic_eq</i> &#x2014; material icon named "graphic eq".
  'graphic_eq': const IconData(0xe1b8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">grid_off</i> &#x2014; material icon named "grid off".
  'grid_off': const IconData(0xe3eb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">grid_on</i> &#x2014; material icon named "grid on".
  'grid_on': const IconData(0xe3ec, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">group</i> &#x2014; material icon named "group".
  'group': const IconData(0xe7ef, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">group_add</i> &#x2014; material icon named "group add".
  'group_add': const IconData(0xe7f0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">group_work</i> &#x2014; material icon named "group work".
  'group_work': const IconData(0xe886, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hd</i> &#x2014; material icon named "hd".
  'hd': const IconData(0xe052, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hdr_off</i> &#x2014; material icon named "hdr off".
  'hdr_off': const IconData(0xe3ed, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hdr_on</i> &#x2014; material icon named "hdr on".
  'hdr_on': const IconData(0xe3ee, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hdr_strong</i> &#x2014; material icon named "hdr strong".
  'hdr_strong': const IconData(0xe3f1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hdr_weak</i> &#x2014; material icon named "hdr weak".
  'hdr_weak': const IconData(0xe3f2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">headset</i> &#x2014; material icon named "headset".
  'headset': const IconData(0xe310, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">headset_mic</i> &#x2014; material icon named "headset mic".
  'headset_mic': const IconData(0xe311, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">headset_off</i> &#x2014; material icon named "headset off".
  'headset_off': const IconData(0xe33a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">healing</i> &#x2014; material icon named "healing".
  'healing': const IconData(0xe3f3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hearing</i> &#x2014; material icon named "hearing".
  'hearing': const IconData(0xe023, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">help</i> &#x2014; material icon named "help".
  'help': const IconData(0xe887, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">help_outline</i> &#x2014; material icon named "help outline".
  'help_outline': const IconData(0xe8fd, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">high_quality</i> &#x2014; material icon named "high quality".
  'high_quality': const IconData(0xe024, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">highlight</i> &#x2014; material icon named "highlight".
  'highlight': const IconData(0xe25f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">highlight_off</i> &#x2014; material icon named "highlight off".
  'highlight_off': const IconData(0xe888, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">history</i> &#x2014; material icon named "history".
  'history': const IconData(0xe889, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">home</i> &#x2014; material icon named "home".
  'home': const IconData(0xe88a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hot_tub</i> &#x2014; material icon named "hot tub".
  'hot_tub': const IconData(0xeb46, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hotel</i> &#x2014; material icon named "hotel".
  'hotel': const IconData(0xe53a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hourglass_empty</i> &#x2014; material icon named "hourglass empty".
  'hourglass_empty': const IconData(0xe88b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">hourglass_full</i> &#x2014; material icon named "hourglass full".
  'hourglass_full': const IconData(0xe88c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">http</i> &#x2014; material icon named "http".
  'http': const IconData(0xe902, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">https</i> &#x2014; material icon named "https".
  'https': const IconData(0xe88d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">image</i> &#x2014; material icon named "image".
  'image': const IconData(0xe3f4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">image_aspect_ratio</i> &#x2014; material icon named "image aspect ratio".
  'image_aspect_ratio': const IconData(0xe3f5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">import_contacts</i> &#x2014; material icon named "import contacts".
  'import_contacts': const IconData(0xe0e0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">import_export</i> &#x2014; material icon named "import export".
  'import_export': const IconData(0xe0c3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">important_devices</i> &#x2014; material icon named "important devices".
  'important_devices': const IconData(0xe912, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">inbox</i> &#x2014; material icon named "inbox".
  'inbox': const IconData(0xe156, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">indeterminate_check_box</i> &#x2014; material icon named "indeterminate check box".
  'indeterminate_check_box': const IconData(0xe909, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">info</i> &#x2014; material icon named "info".
  'info': const IconData(0xe88e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">info_outline</i> &#x2014; material icon named "info outline".
  'info_outline': const IconData(0xe88f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">input</i> &#x2014; material icon named "input".
  'input': const IconData(0xe890, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">insert_chart</i> &#x2014; material icon named "insert chart".
  'insert_chart': const IconData(0xe24b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">insert_comment</i> &#x2014; material icon named "insert comment".
  'insert_comment': const IconData(0xe24c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">insert_drive_file</i> &#x2014; material icon named "insert drive file".
  'insert_drive_file': const IconData(0xe24d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">insert_emoticon</i> &#x2014; material icon named "insert emoticon".
  'insert_emoticon': const IconData(0xe24e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">insert_invitation</i> &#x2014; material icon named "insert invitation".
  'insert_invitation': const IconData(0xe24f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">insert_link</i> &#x2014; material icon named "insert link".
  'insert_link': const IconData(0xe250, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">insert_photo</i> &#x2014; material icon named "insert photo".
  'insert_photo': const IconData(0xe251, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">invert_colors</i> &#x2014; material icon named "invert colors".
  'invert_colors': const IconData(0xe891, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">invert_colors_off</i> &#x2014; material icon named "invert colors off".
  'invert_colors_off': const IconData(0xe0c4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">iso</i> &#x2014; material icon named "iso".
  'iso': const IconData(0xe3f6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard</i> &#x2014; material icon named "keyboard".
  'keyboard': const IconData(0xe312, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_arrow_down</i> &#x2014; material icon named "keyboard arrow down".
  'keyboard_arrow_down': const IconData(0xe313, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_arrow_left</i> &#x2014; material icon named "keyboard arrow left".
  'keyboard_arrow_left': const IconData(0xe314, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_arrow_right</i> &#x2014; material icon named "keyboard arrow right".
  'keyboard_arrow_right': const IconData(0xe315, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_arrow_up</i> &#x2014; material icon named "keyboard arrow up".
  'keyboard_arrow_up': const IconData(0xe316, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_backspace</i> &#x2014; material icon named "keyboard backspace".
  'keyboard_backspace': const IconData(0xe317, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">keyboard_capslock</i> &#x2014; material icon named "keyboard capslock".
  'keyboard_capslock': const IconData(0xe318, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_hide</i> &#x2014; material icon named "keyboard hide".
  'keyboard_hide': const IconData(0xe31a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_return</i> &#x2014; material icon named "keyboard return".
  'keyboard_return': const IconData(0xe31b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">keyboard_tab</i> &#x2014; material icon named "keyboard tab".
  'keyboard_tab': const IconData(0xe31c, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">keyboard_voice</i> &#x2014; material icon named "keyboard voice".
  'keyboard_voice': const IconData(0xe31d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">kitchen</i> &#x2014; material icon named "kitchen".
  'kitchen': const IconData(0xeb47, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">label</i> &#x2014; material icon named "label".
  'label': const IconData(0xe892, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">label_important</i> &#x2014; material icon named "label important".
  'label_important': const IconData(0xe937, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">label_outline</i> &#x2014; material icon named "label outline".
  'label_outline': const IconData(0xe893, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">landscape</i> &#x2014; material icon named "landscape".
  'landscape': const IconData(0xe3f7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">language</i> &#x2014; material icon named "language".
  'language': const IconData(0xe894, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">laptop</i> &#x2014; material icon named "laptop".
  'laptop': const IconData(0xe31e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">laptop_chromebook</i> &#x2014; material icon named "laptop chromebook".
  'laptop_chromebook': const IconData(0xe31f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">laptop_mac</i> &#x2014; material icon named "laptop mac".
  'laptop_mac': const IconData(0xe320, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">laptop_windows</i> &#x2014; material icon named "laptop windows".
  'laptop_windows': const IconData(0xe321, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">last_page</i> &#x2014; material icon named "last page".
  'last_page': const IconData(0xe5dd, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">launch</i> &#x2014; material icon named "launch".
  'launch': const IconData(0xe895, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">layers</i> &#x2014; material icon named "layers".
  'layers': const IconData(0xe53b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">layers_clear</i> &#x2014; material icon named "layers clear".
  'layers_clear': const IconData(0xe53c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">leak_add</i> &#x2014; material icon named "leak add".
  'leak_add': const IconData(0xe3f8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">leak_remove</i> &#x2014; material icon named "leak remove".
  'leak_remove': const IconData(0xe3f9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">lens</i> &#x2014; material icon named "lens".
  'lens': const IconData(0xe3fa, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">library_add</i> &#x2014; material icon named "library add".
  'library_add': const IconData(0xe02e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">library_books</i> &#x2014; material icon named "library books".
  'library_books': const IconData(0xe02f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">library_music</i> &#x2014; material icon named "library music".
  'library_music': const IconData(0xe030, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">lightbulb_outline</i> &#x2014; material icon named "lightbulb outline".
  'lightbulb_outline': const IconData(0xe90f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">line_style</i> &#x2014; material icon named "line style".
  'line_style': const IconData(0xe919, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">line_weight</i> &#x2014; material icon named "line weight".
  'line_weight': const IconData(0xe91a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">linear_scale</i> &#x2014; material icon named "linear scale".
  'linear_scale': const IconData(0xe260, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">link</i> &#x2014; material icon named "link".
  'link': const IconData(0xe157, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">link_off</i> &#x2014; material icon named "link off".
  'link_off': const IconData(0xe16f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">linked_camera</i> &#x2014; material icon named "linked camera".
  'linked_camera': const IconData(0xe438, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">list</i> &#x2014; material icon named "list".
  'list': const IconData(0xe896, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">live_help</i> &#x2014; material icon named "live help".
  'live_help': const IconData(0xe0c6, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">live_tv</i> &#x2014; material icon named "live tv".
  'live_tv': const IconData(0xe639, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_activity</i> &#x2014; material icon named "local activity".
  'local_activity': const IconData(0xe53f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_airport</i> &#x2014; material icon named "local airport".
  'local_airport': const IconData(0xe53d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_atm</i> &#x2014; material icon named "local atm".
  'local_atm': const IconData(0xe53e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_bar</i> &#x2014; material icon named "local bar".
  'local_bar': const IconData(0xe540, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_cafe</i> &#x2014; material icon named "local cafe".
  'local_cafe': const IconData(0xe541, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_car_wash</i> &#x2014; material icon named "local car wash".
  'local_car_wash': const IconData(0xe542, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_convenience_store</i> &#x2014; material icon named "local convenience store".
  'local_convenience_store': const IconData(0xe543, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_dining</i> &#x2014; material icon named "local dining".
  'local_dining': const IconData(0xe556, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_drink</i> &#x2014; material icon named "local drink".
  'local_drink': const IconData(0xe544, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_florist</i> &#x2014; material icon named "local florist".
  'local_florist': const IconData(0xe545, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_gas_station</i> &#x2014; material icon named "local gas station".
  'local_gas_station': const IconData(0xe546, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_grocery_store</i> &#x2014; material icon named "local grocery store".
  'local_grocery_store': const IconData(0xe547, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_hospital</i> &#x2014; material icon named "local hospital".
  'local_hospital': const IconData(0xe548, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_hotel</i> &#x2014; material icon named "local hotel".
  'local_hotel': const IconData(0xe549, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_laundry_service</i> &#x2014; material icon named "local laundry service".
  'local_laundry_service': const IconData(0xe54a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_library</i> &#x2014; material icon named "local library".
  'local_library': const IconData(0xe54b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_mall</i> &#x2014; material icon named "local mall".
  'local_mall': const IconData(0xe54c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_movies</i> &#x2014; material icon named "local movies".
  'local_movies': const IconData(0xe54d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_offer</i> &#x2014; material icon named "local offer".
  'local_offer': const IconData(0xe54e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_parking</i> &#x2014; material icon named "local parking".
  'local_parking': const IconData(0xe54f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_pharmacy</i> &#x2014; material icon named "local pharmacy".
  'local_pharmacy': const IconData(0xe550, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_phone</i> &#x2014; material icon named "local phone".
  'local_phone': const IconData(0xe551, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_pizza</i> &#x2014; material icon named "local pizza".
  'local_pizza': const IconData(0xe552, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_play</i> &#x2014; material icon named "local play".
  'local_play': const IconData(0xe553, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_post_office</i> &#x2014; material icon named "local post office".
  'local_post_office': const IconData(0xe554, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_printshop</i> &#x2014; material icon named "local printshop".
  'local_printshop': const IconData(0xe555, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_see</i> &#x2014; material icon named "local see".
  'local_see': const IconData(0xe557, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_shipping</i> &#x2014; material icon named "local shipping".
  'local_shipping': const IconData(0xe558, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">local_taxi</i> &#x2014; material icon named "local taxi".
  'local_taxi': const IconData(0xe559, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">location_city</i> &#x2014; material icon named "location city".
  'location_city': const IconData(0xe7f1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">location_disabled</i> &#x2014; material icon named "location disabled".
  'location_disabled': const IconData(0xe1b6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">location_off</i> &#x2014; material icon named "location off".
  'location_off': const IconData(0xe0c7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">location_on</i> &#x2014; material icon named "location on".
  'location_on': const IconData(0xe0c8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">location_searching</i> &#x2014; material icon named "location searching".
  'location_searching': const IconData(0xe1b7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">lock</i> &#x2014; material icon named "lock".
  'lock': const IconData(0xe897, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">lock_open</i> &#x2014; material icon named "lock open".
  'lock_open': const IconData(0xe898, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">lock_outline</i> &#x2014; material icon named "lock outline".
  'lock_outline': const IconData(0xe899, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks</i> &#x2014; material icon named "looks".
  'looks': const IconData(0xe3fc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks_3</i> &#x2014; material icon named "looks 3".
  'looks_3': const IconData(0xe3fb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks_4</i> &#x2014; material icon named "looks 4".
  'looks_4': const IconData(0xe3fd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks_5</i> &#x2014; material icon named "looks 5".
  'looks_5': const IconData(0xe3fe, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks_6</i> &#x2014; material icon named "looks 6".
  'looks_6': const IconData(0xe3ff, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks_one</i> &#x2014; material icon named "looks one".
  'looks_one': const IconData(0xe400, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">looks_two</i> &#x2014; material icon named "looks two".
  'looks_two': const IconData(0xe401, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">loop</i> &#x2014; material icon named "loop".
  'loop': const IconData(0xe028, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">loupe</i> &#x2014; material icon named "loupe".
  'loupe': const IconData(0xe402, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">low_priority</i> &#x2014; material icon named "low priority".
  'low_priority': const IconData(0xe16d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">loyalty</i> &#x2014; material icon named "loyalty".
  'loyalty': const IconData(0xe89a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mail</i> &#x2014; material icon named "mail".
  'mail': const IconData(0xe158, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mail_outline</i> &#x2014; material icon named "mail outline".
  'mail_outline': const IconData(0xe0e1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">map</i> &#x2014; material icon named "map".
  'map': const IconData(0xe55b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">markunread</i> &#x2014; material icon named "markunread".
  'markunread': const IconData(0xe159, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">markunread_mailbox</i> &#x2014; material icon named "markunread mailbox".
  'markunread_mailbox': const IconData(0xe89b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">maximize</i> &#x2014; material icon named "maximize".
  'maximize': const IconData(0xe930, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">memory</i> &#x2014; material icon named "memory".
  'memory': const IconData(0xe322, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">menu</i> &#x2014; material icon named "menu".
  'menu': const IconData(0xe5d2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">merge_type</i> &#x2014; material icon named "merge type".
  'merge_type': const IconData(0xe252, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">message</i> &#x2014; material icon named "message".
  'message': const IconData(0xe0c9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mic</i> &#x2014; material icon named "mic".
  'mic': const IconData(0xe029, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mic_none</i> &#x2014; material icon named "mic none".
  'mic_none': const IconData(0xe02a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mic_off</i> &#x2014; material icon named "mic off".
  'mic_off': const IconData(0xe02b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">minimize</i> &#x2014; material icon named "minimize".
  'minimize': const IconData(0xe931, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">missed_video_call</i> &#x2014; material icon named "missed video call".
  'missed_video_call': const IconData(0xe073, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mms</i> &#x2014; material icon named "mms".
  'mms': const IconData(0xe618, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mobile_screen_share</i> &#x2014; material icon named "mobile screen share".
  'mobile_screen_share': const IconData(0xe0e7, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">mode_comment</i> &#x2014; material icon named "mode comment".
  'mode_comment': const IconData(0xe253, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mode_edit</i> &#x2014; material icon named "mode edit".
  'mode_edit': const IconData(0xe254, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">monetization_on</i> &#x2014; material icon named "monetization on".
  'monetization_on': const IconData(0xe263, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">money_off</i> &#x2014; material icon named "money off".
  'money_off': const IconData(0xe25c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">monochrome_photos</i> &#x2014; material icon named "monochrome photos".
  'monochrome_photos': const IconData(0xe403, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mood</i> &#x2014; material icon named "mood".
  'mood': const IconData(0xe7f2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mood_bad</i> &#x2014; material icon named "mood bad".
  'mood_bad': const IconData(0xe7f3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">more</i> &#x2014; material icon named "more".
  'more': const IconData(0xe619, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">more_horiz</i> &#x2014; material icon named "more horiz".
  'more_horiz': const IconData(0xe5d3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">more_vert</i> &#x2014; material icon named "more vert".
  'more_vert': const IconData(0xe5d4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">motorcycle</i> &#x2014; material icon named "motorcycle".
  'motorcycle': const IconData(0xe91b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">mouse</i> &#x2014; material icon named "mouse".
  'mouse': const IconData(0xe323, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">move_to_inbox</i> &#x2014; material icon named "move to inbox".
  'move_to_inbox': const IconData(0xe168, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">movie</i> &#x2014; material icon named "movie".
  'movie': const IconData(0xe02c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">movie_creation</i> &#x2014; material icon named "movie creation".
  'movie_creation': const IconData(0xe404, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">movie_filter</i> &#x2014; material icon named "movie filter".
  'movie_filter': const IconData(0xe43a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">multiline_chart</i> &#x2014; material icon named "multiline chart".
  'multiline_chart': const IconData(0xe6df, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">music_note</i> &#x2014; material icon named "music note".
  'music_note': const IconData(0xe405, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">music_video</i> &#x2014; material icon named "music video".
  'music_video': const IconData(0xe063, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">my_location</i> &#x2014; material icon named "my location".
  'my_location': const IconData(0xe55c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">nature</i> &#x2014; material icon named "nature".
  'nature': const IconData(0xe406, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">nature_people</i> &#x2014; material icon named "nature people".
  'nature_people': const IconData(0xe407, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">navigate_before</i> &#x2014; material icon named "navigate before".
  'navigate_before': const IconData(0xe408, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">navigate_next</i> &#x2014; material icon named "navigate next".
  'navigate_next': const IconData(0xe409, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">navigation</i> &#x2014; material icon named "navigation".
  'navigation': const IconData(0xe55d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">near_me</i> &#x2014; material icon named "near me".
  'near_me': const IconData(0xe569, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">network_cell</i> &#x2014; material icon named "network cell".
  'network_cell': const IconData(0xe1b9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">network_check</i> &#x2014; material icon named "network check".
  'network_check': const IconData(0xe640, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">network_locked</i> &#x2014; material icon named "network locked".
  'network_locked': const IconData(0xe61a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">network_wifi</i> &#x2014; material icon named "network wifi".
  'network_wifi': const IconData(0xe1ba, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">new_releases</i> &#x2014; material icon named "new releases".
  'new_releases': const IconData(0xe031, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">next_week</i> &#x2014; material icon named "next week".
  'next_week': const IconData(0xe16a, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">nfc</i> &#x2014; material icon named "nfc".
  'nfc': const IconData(0xe1bb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">no_encryption</i> &#x2014; material icon named "no encryption".
  'no_encryption': const IconData(0xe641, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">no_sim</i> &#x2014; material icon named "no sim".
  'no_sim': const IconData(0xe0cc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">not_interested</i> &#x2014; material icon named "not interested".
  'not_interested': const IconData(0xe033, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">not_listed_location</i> &#x2014; material icon named "not listed location".
  'not_listed_location': const IconData(0xe575, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">note</i> &#x2014; material icon named "note".
  'note': const IconData(0xe06f, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">note_add</i> &#x2014; material icon named "note add".
  'note_add': const IconData(0xe89c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">notification_important</i> &#x2014; material icon named "notification important".
  'notification_important': const IconData(0xe004, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">notifications</i> &#x2014; material icon named "notifications".
  'notifications': const IconData(0xe7f4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">notifications_active</i> &#x2014; material icon named "notifications active".
  'notifications_active': const IconData(0xe7f7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">notifications_none</i> &#x2014; material icon named "notifications none".
  'notifications_none': const IconData(0xe7f5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">notifications_off</i> &#x2014; material icon named "notifications off".
  'notifications_off': const IconData(0xe7f6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">notifications_paused</i> &#x2014; material icon named "notifications paused".
  'notifications_paused': const IconData(0xe7f8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">offline_bolt</i> &#x2014; material icon named "offline bolt".
  'offline_bolt': const IconData(0xe932, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">offline_pin</i> &#x2014; material icon named "offline pin".
  'offline_pin': const IconData(0xe90a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">ondemand_video</i> &#x2014; material icon named "ondemand video".
  'ondemand_video': const IconData(0xe63a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">opacity</i> &#x2014; material icon named "opacity".
  'opacity': const IconData(0xe91c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">open_in_browser</i> &#x2014; material icon named "open in browser".
  'open_in_browser': const IconData(0xe89d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">open_in_new</i> &#x2014; material icon named "open in new".
  'open_in_new': const IconData(0xe89e, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">open_with</i> &#x2014; material icon named "open with".
  'open_with': const IconData(0xe89f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">outlined_flag</i> &#x2014; material icon named "outlined flag".
  'outlined_flag': const IconData(0xe16e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pages</i> &#x2014; material icon named "pages".
  'pages': const IconData(0xe7f9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pageview</i> &#x2014; material icon named "pageview".
  'pageview': const IconData(0xe8a0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">palette</i> &#x2014; material icon named "palette".
  'palette': const IconData(0xe40a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pan_tool</i> &#x2014; material icon named "pan tool".
  'pan_tool': const IconData(0xe925, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">panorama</i> &#x2014; material icon named "panorama".
  'panorama': const IconData(0xe40b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">panorama_fish_eye</i> &#x2014; material icon named "panorama fish eye".
  'panorama_fish_eye': const IconData(0xe40c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">panorama_horizontal</i> &#x2014; material icon named "panorama horizontal".
  'panorama_horizontal': const IconData(0xe40d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">panorama_vertical</i> &#x2014; material icon named "panorama vertical".
  'panorama_vertical': const IconData(0xe40e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">panorama_wide_angle</i> &#x2014; material icon named "panorama wide angle".
  'panorama_wide_angle': const IconData(0xe40f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">party_mode</i> &#x2014; material icon named "party mode".
  'party_mode': const IconData(0xe7fa, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pause</i> &#x2014; material icon named "pause".
  'pause': const IconData(0xe034, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pause_circle_filled</i> &#x2014; material icon named "pause circle filled".
  'pause_circle_filled': const IconData(0xe035, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pause_circle_outline</i> &#x2014; material icon named "pause circle outline".
  'pause_circle_outline': const IconData(0xe036, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">payment</i> &#x2014; material icon named "payment".
  'payment': const IconData(0xe8a1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">people</i> &#x2014; material icon named "people".
  'people': const IconData(0xe7fb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">people_outline</i> &#x2014; material icon named "people outline".
  'people_outline': const IconData(0xe7fc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_camera_mic</i> &#x2014; material icon named "perm camera mic".
  'perm_camera_mic': const IconData(0xe8a2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_contact_calendar</i> &#x2014; material icon named "perm contact calendar".
  'perm_contact_calendar': const IconData(0xe8a3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_data_setting</i> &#x2014; material icon named "perm data setting".
  'perm_data_setting': const IconData(0xe8a4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_device_information</i> &#x2014; material icon named "perm device information".
  'perm_device_information': const IconData(0xe8a5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_identity</i> &#x2014; material icon named "perm identity".
  'perm_identity': const IconData(0xe8a6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_media</i> &#x2014; material icon named "perm media".
  'perm_media': const IconData(0xe8a7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_phone_msg</i> &#x2014; material icon named "perm phone msg".
  'perm_phone_msg': const IconData(0xe8a8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">perm_scan_wifi</i> &#x2014; material icon named "perm scan wifi".
  'perm_scan_wifi': const IconData(0xe8a9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">person</i> &#x2014; material icon named "person".
  'person': const IconData(0xe7fd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">person_add</i> &#x2014; material icon named "person add".
  'person_add': const IconData(0xe7fe, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">person_outline</i> &#x2014; material icon named "person outline".
  'person_outline': const IconData(0xe7ff, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">person_pin</i> &#x2014; material icon named "person pin".
  'person_pin': const IconData(0xe55a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">person_pin_circle</i> &#x2014; material icon named "person pin circle".
  'person_pin_circle': const IconData(0xe56a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">personal_video</i> &#x2014; material icon named "personal video".
  'personal_video': const IconData(0xe63b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pets</i> &#x2014; material icon named "pets".
  'pets': const IconData(0xe91d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone</i> &#x2014; material icon named "phone".
  'phone': const IconData(0xe0cd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_android</i> &#x2014; material icon named "phone android".
  'phone_android': const IconData(0xe324, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_bluetooth_speaker</i> &#x2014; material icon named "phone bluetooth speaker".
  'phone_bluetooth_speaker': const IconData(0xe61b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_forwarded</i> &#x2014; material icon named "phone forwarded".
  'phone_forwarded': const IconData(0xe61c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_in_talk</i> &#x2014; material icon named "phone in talk".
  'phone_in_talk': const IconData(0xe61d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_iphone</i> &#x2014; material icon named "phone iphone".
  'phone_iphone': const IconData(0xe325, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_locked</i> &#x2014; material icon named "phone locked".
  'phone_locked': const IconData(0xe61e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_missed</i> &#x2014; material icon named "phone missed".
  'phone_missed': const IconData(0xe61f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phone_paused</i> &#x2014; material icon named "phone paused".
  'phone_paused': const IconData(0xe620, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phonelink</i> &#x2014; material icon named "phonelink".
  'phonelink': const IconData(0xe326, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phonelink_erase</i> &#x2014; material icon named "phonelink erase".
  'phonelink_erase': const IconData(0xe0db, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phonelink_lock</i> &#x2014; material icon named "phonelink lock".
  'phonelink_lock': const IconData(0xe0dc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phonelink_off</i> &#x2014; material icon named "phonelink off".
  'phonelink_off': const IconData(0xe327, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phonelink_ring</i> &#x2014; material icon named "phonelink ring".
  'phonelink_ring': const IconData(0xe0dd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">phonelink_setup</i> &#x2014; material icon named "phonelink setup".
  'phonelink_setup': const IconData(0xe0de, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo</i> &#x2014; material icon named "photo".
  'photo': const IconData(0xe410, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_album</i> &#x2014; material icon named "photo album".
  'photo_album': const IconData(0xe411, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_camera</i> &#x2014; material icon named "photo camera".
  'photo_camera': const IconData(0xe412, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_filter</i> &#x2014; material icon named "photo filter".
  'photo_filter': const IconData(0xe43b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_library</i> &#x2014; material icon named "photo library".
  'photo_library': const IconData(0xe413, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_size_select_actual</i> &#x2014; material icon named "photo size select actual".
  'photo_size_select_actual': const IconData(0xe432, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_size_select_large</i> &#x2014; material icon named "photo size select large".
  'photo_size_select_large': const IconData(0xe433, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">photo_size_select_small</i> &#x2014; material icon named "photo size select small".
  'photo_size_select_small': const IconData(0xe434, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">picture_as_pdf</i> &#x2014; material icon named "picture as pdf".
  'picture_as_pdf': const IconData(0xe415, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">picture_in_picture</i> &#x2014; material icon named "picture in picture".
  'picture_in_picture': const IconData(0xe8aa, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">picture_in_picture_alt</i> &#x2014; material icon named "picture in picture alt".
  'picture_in_picture_alt': const IconData(0xe911, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pie_chart</i> &#x2014; material icon named "pie chart".
  'pie_chart': const IconData(0xe6c4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pie_chart_outlined</i> &#x2014; material icon named "pie chart outlined".
  'pie_chart_outlined': const IconData(0xe6c5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pin_drop</i> &#x2014; material icon named "pin drop".
  'pin_drop': const IconData(0xe55e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">place</i> &#x2014; material icon named "place".
  'place': const IconData(0xe55f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">play_arrow</i> &#x2014; material icon named "play arrow".
  'play_arrow': const IconData(0xe037, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">play_circle_filled</i> &#x2014; material icon named "play circle filled".
  'play_circle_filled': const IconData(0xe038, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">play_circle_outline</i> &#x2014; material icon named "play circle outline".
  'play_circle_outline': const IconData(0xe039, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">play_for_work</i> &#x2014; material icon named "play for work".
  'play_for_work': const IconData(0xe906, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">playlist_add</i> &#x2014; material icon named "playlist add".
  'playlist_add': const IconData(0xe03b, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">playlist_add_check</i> &#x2014; material icon named "playlist add check".
  'playlist_add_check': const IconData(0xe065, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">playlist_play</i> &#x2014; material icon named "playlist play".
  'playlist_play': const IconData(0xe05f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">plus_one</i> &#x2014; material icon named "plus one".
  'plus_one': const IconData(0xe800, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">poll</i> &#x2014; material icon named "poll".
  'poll': const IconData(0xe801, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">polymer</i> &#x2014; material icon named "polymer".
  'polymer': const IconData(0xe8ab, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pool</i> &#x2014; material icon named "pool".
  'pool': const IconData(0xeb48, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">portable_wifi_off</i> &#x2014; material icon named "portable wifi off".
  'portable_wifi_off': const IconData(0xe0ce, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">portrait</i> &#x2014; material icon named "portrait".
  'portrait': const IconData(0xe416, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">power</i> &#x2014; material icon named "power".
  'power': const IconData(0xe63c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">power_input</i> &#x2014; material icon named "power input".
  'power_input': const IconData(0xe336, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">power_settings_new</i> &#x2014; material icon named "power settings new".
  'power_settings_new': const IconData(0xe8ac, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">pregnant_woman</i> &#x2014; material icon named "pregnant woman".
  'pregnant_woman': const IconData(0xe91e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">present_to_all</i> &#x2014; material icon named "present to all".
  'present_to_all': const IconData(0xe0df, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">print</i> &#x2014; material icon named "print".
  'print': const IconData(0xe8ad, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">priority_high</i> &#x2014; material icon named "priority high".
  'priority_high': const IconData(0xe645, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">public</i> &#x2014; material icon named "public".
  'public': const IconData(0xe80b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">publish</i> &#x2014; material icon named "publish".
  'publish': const IconData(0xe255, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">query_builder</i> &#x2014; material icon named "query builder".
  'query_builder': const IconData(0xe8ae, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">question_answer</i> &#x2014; material icon named "question answer".
  'question_answer': const IconData(0xe8af, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">queue</i> &#x2014; material icon named "queue".
  'queue': const IconData(0xe03c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">queue_music</i> &#x2014; material icon named "queue music".
  'queue_music': const IconData(0xe03d, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">queue_play_next</i> &#x2014; material icon named "queue play next".
  'queue_play_next': const IconData(0xe066, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">radio</i> &#x2014; material icon named "radio".
  'radio': const IconData(0xe03e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">radio_button_checked</i> &#x2014; material icon named "radio button checked".
  'radio_button_checked': const IconData(0xe837, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">radio_button_unchecked</i> &#x2014; material icon named "radio button unchecked".
  'radio_button_unchecked': const IconData(0xe836, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rate_review</i> &#x2014; material icon named "rate review".
  'rate_review': const IconData(0xe560, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">receipt</i> &#x2014; material icon named "receipt".
  'receipt': const IconData(0xe8b0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">recent_actors</i> &#x2014; material icon named "recent actors".
  'recent_actors': const IconData(0xe03f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">record_voice_over</i> &#x2014; material icon named "record voice over".
  'record_voice_over': const IconData(0xe91f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">redeem</i> &#x2014; material icon named "redeem".
  'redeem': const IconData(0xe8b1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">redo</i> &#x2014; material icon named "redo".
  'redo': const IconData(0xe15a, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">refresh</i> &#x2014; material icon named "refresh".
  'refresh': const IconData(0xe5d5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">remove</i> &#x2014; material icon named "remove".
  'remove': const IconData(0xe15b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">remove_circle</i> &#x2014; material icon named "remove circle".
  'remove_circle': const IconData(0xe15c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">remove_circle_outline</i> &#x2014; material icon named "remove circle outline".
  'remove_circle_outline': const IconData(0xe15d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">remove_from_queue</i> &#x2014; material icon named "remove from queue".
  'remove_from_queue': const IconData(0xe067, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">remove_red_eye</i> &#x2014; material icon named "remove red eye".
  'remove_red_eye': const IconData(0xe417, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">remove_shopping_cart</i> &#x2014; material icon named "remove shopping cart".
  'remove_shopping_cart': const IconData(0xe928, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">reorder</i> &#x2014; material icon named "reorder".
  'reorder': const IconData(0xe8fe, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">repeat</i> &#x2014; material icon named "repeat".
  'repeat': const IconData(0xe040, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">repeat_one</i> &#x2014; material icon named "repeat one".
  'repeat_one': const IconData(0xe041, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">replay</i> &#x2014; material icon named "replay".
  'replay': const IconData(0xe042, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">replay_10</i> &#x2014; material icon named "replay 10".
  'replay_10': const IconData(0xe059, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">replay_30</i> &#x2014; material icon named "replay 30".
  'replay_30': const IconData(0xe05a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">replay_5</i> &#x2014; material icon named "replay 5".
  'replay_5': const IconData(0xe05b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">reply</i> &#x2014; material icon named "reply".
  'reply': const IconData(0xe15e, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">reply_all</i> &#x2014; material icon named "reply all".
  'reply_all': const IconData(0xe15f, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">report</i> &#x2014; material icon named "report".
  'report': const IconData(0xe160, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">report_off</i> &#x2014; material icon named "report off".
  'report_off': const IconData(0xe170, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">report_problem</i> &#x2014; material icon named "report problem".
  'report_problem': const IconData(0xe8b2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">restaurant</i> &#x2014; material icon named "restaurant".
  'restaurant': const IconData(0xe56c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">restaurant_menu</i> &#x2014; material icon named "restaurant menu".
  'restaurant_menu': const IconData(0xe561, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">restore</i> &#x2014; material icon named "restore".
  'restore': const IconData(0xe8b3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">restore_from_trash</i> &#x2014; material icon named "restore from trash".
  'restore_from_trash': const IconData(0xe938, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">restore_page</i> &#x2014; material icon named "restore page".
  'restore_page': const IconData(0xe929, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">ring_volume</i> &#x2014; material icon named "ring volume".
  'ring_volume': const IconData(0xe0d1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">room</i> &#x2014; material icon named "room".
  'room': const IconData(0xe8b4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">room_service</i> &#x2014; material icon named "room service".
  'room_service': const IconData(0xeb49, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rotate_90_degrees_ccw</i> &#x2014; material icon named "rotate 90 degrees ccw".
  'rotate_90_degrees_ccw': const IconData(0xe418, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rotate_left</i> &#x2014; material icon named "rotate left".
  'rotate_left': const IconData(0xe419, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rotate_right</i> &#x2014; material icon named "rotate right".
  'rotate_right': const IconData(0xe41a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rounded_corner</i> &#x2014; material icon named "rounded corner".
  'rounded_corner': const IconData(0xe920, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">router</i> &#x2014; material icon named "router".
  'router': const IconData(0xe328, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rowing</i> &#x2014; material icon named "rowing".
  'rowing': const IconData(0xe921, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rss_feed</i> &#x2014; material icon named "rss feed".
  'rss_feed': const IconData(0xe0e5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">rv_hookup</i> &#x2014; material icon named "rv hookup".
  'rv_hookup': const IconData(0xe642, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">satellite</i> &#x2014; material icon named "satellite".
  'satellite': const IconData(0xe562, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">save</i> &#x2014; material icon named "save".
  'save': const IconData(0xe161, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">save_alt</i> &#x2014; material icon named "save alt".
  'save_alt': const IconData(0xe171, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">scanner</i> &#x2014; material icon named "scanner".
  'scanner': const IconData(0xe329, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">scatter_plot</i> &#x2014; material icon named "scatter plot".
  'scatter_plot': const IconData(0xe268, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">schedule</i> &#x2014; material icon named "schedule".
  'schedule': const IconData(0xe8b5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">school</i> &#x2014; material icon named "school".
  'school': const IconData(0xe80c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">score</i> &#x2014; material icon named "score".
  'score': const IconData(0xe269, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">screen_lock_landscape</i> &#x2014; material icon named "screen lock landscape".
  'screen_lock_landscape': const IconData(0xe1be, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">screen_lock_portrait</i> &#x2014; material icon named "screen lock portrait".
  'screen_lock_portrait': const IconData(0xe1bf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">screen_lock_rotation</i> &#x2014; material icon named "screen lock rotation".
  'screen_lock_rotation': const IconData(0xe1c0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">screen_rotation</i> &#x2014; material icon named "screen rotation".
  'screen_rotation': const IconData(0xe1c1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">screen_share</i> &#x2014; material icon named "screen share".
  'screen_share': const IconData(0xe0e2, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">sd_card</i> &#x2014; material icon named "sd card".
  'sd_card': const IconData(0xe623, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sd_storage</i> &#x2014; material icon named "sd storage".
  'sd_storage': const IconData(0xe1c2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">search</i> &#x2014; material icon named "search".
  'search': const IconData(0xe8b6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">security</i> &#x2014; material icon named "security".
  'security': const IconData(0xe32a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">select_all</i> &#x2014; material icon named "select all".
  'select_all': const IconData(0xe162, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">send</i> &#x2014; material icon named "send".
  'send': const IconData(0xe163, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">sentiment_dissatisfied</i> &#x2014; material icon named "sentiment dissatisfied".
  'sentiment_dissatisfied': const IconData(0xe811, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sentiment_neutral</i> &#x2014; material icon named "sentiment neutral".
  'sentiment_neutral': const IconData(0xe812, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sentiment_satisfied</i> &#x2014; material icon named "sentiment satisfied".
  'sentiment_satisfied': const IconData(0xe813, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sentiment_very_dissatisfied</i> &#x2014; material icon named "sentiment very dissatisfied".
  'sentiment_very_dissatisfied': const IconData(0xe814, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sentiment_very_satisfied</i> &#x2014; material icon named "sentiment very satisfied".
  'sentiment_very_satisfied': const IconData(0xe815, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings</i> &#x2014; material icon named "settings".
  'settings': const IconData(0xe8b8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_applications</i> &#x2014; material icon named "settings applications".
  'settings_applications': const IconData(0xe8b9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_backup_restore</i> &#x2014; material icon named "settings backup restore".
  'settings_backup_restore': const IconData(0xe8ba, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_bluetooth</i> &#x2014; material icon named "settings bluetooth".
  'settings_bluetooth': const IconData(0xe8bb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_brightness</i> &#x2014; material icon named "settings brightness".
  'settings_brightness': const IconData(0xe8bd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_cell</i> &#x2014; material icon named "settings cell".
  'settings_cell': const IconData(0xe8bc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_ethernet</i> &#x2014; material icon named "settings ethernet".
  'settings_ethernet': const IconData(0xe8be, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_input_antenna</i> &#x2014; material icon named "settings input antenna".
  'settings_input_antenna': const IconData(0xe8bf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_input_component</i> &#x2014; material icon named "settings input component".
  'settings_input_component': const IconData(0xe8c0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_input_composite</i> &#x2014; material icon named "settings input composite".
  'settings_input_composite': const IconData(0xe8c1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_input_hdmi</i> &#x2014; material icon named "settings input hdmi".
  'settings_input_hdmi': const IconData(0xe8c2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_input_svideo</i> &#x2014; material icon named "settings input svideo".
  'settings_input_svideo': const IconData(0xe8c3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_overscan</i> &#x2014; material icon named "settings overscan".
  'settings_overscan': const IconData(0xe8c4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_phone</i> &#x2014; material icon named "settings phone".
  'settings_phone': const IconData(0xe8c5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_power</i> &#x2014; material icon named "settings power".
  'settings_power': const IconData(0xe8c6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_remote</i> &#x2014; material icon named "settings remote".
  'settings_remote': const IconData(0xe8c7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_system_daydream</i> &#x2014; material icon named "settings system daydream".
  'settings_system_daydream': const IconData(0xe1c3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">settings_voice</i> &#x2014; material icon named "settings voice".
  'settings_voice': const IconData(0xe8c8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">share</i> &#x2014; material icon named "share".
  'share': const IconData(0xe80d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">shop</i> &#x2014; material icon named "shop".
  'shop': const IconData(0xe8c9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">shop_two</i> &#x2014; material icon named "shop two".
  'shop_two': const IconData(0xe8ca, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">shopping_basket</i> &#x2014; material icon named "shopping basket".
  'shopping_basket': const IconData(0xe8cb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">shopping_cart</i> &#x2014; material icon named "shopping cart".
  'shopping_cart': const IconData(0xe8cc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">short_text</i> &#x2014; material icon named "short text".
  'short_text': const IconData(0xe261, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">show_chart</i> &#x2014; material icon named "show chart".
  'show_chart': const IconData(0xe6e1, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">shuffle</i> &#x2014; material icon named "shuffle".
  'shuffle': const IconData(0xe043, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">shutter_speed</i> &#x2014; material icon named "shutter speed".
  'shutter_speed': const IconData(0xe43d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_cellular_4_bar</i> &#x2014; material icon named "signal cellular 4 bar".
  'signal_cellular_4_bar': const IconData(0xe1c8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_cellular_connected_no_internet_4_bar</i> &#x2014; material icon named "signal cellular connected no internet 4 bar".
  'signal_cellular_connected_no_internet_4_bar': const IconData(0xe1cd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_cellular_no_sim</i> &#x2014; material icon named "signal cellular no sim".
  'signal_cellular_no_sim': const IconData(0xe1ce, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_cellular_null</i> &#x2014; material icon named "signal cellular null".
  'signal_cellular_null': const IconData(0xe1cf, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_cellular_off</i> &#x2014; material icon named "signal cellular off".
  'signal_cellular_off': const IconData(0xe1d0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_wifi_4_bar</i> &#x2014; material icon named "signal wifi 4 bar".
  'signal_wifi_4_bar': const IconData(0xe1d8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_wifi_4_bar_lock</i> &#x2014; material icon named "signal wifi 4 bar lock".
  'signal_wifi_4_bar_lock': const IconData(0xe1d9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">signal_wifi_off</i> &#x2014; material icon named "signal wifi off".
  'signal_wifi_off': const IconData(0xe1da, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sim_card</i> &#x2014; material icon named "sim card".
  'sim_card': const IconData(0xe32b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sim_card_alert</i> &#x2014; material icon named "sim card alert".
  'sim_card_alert': const IconData(0xe624, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">skip_next</i> &#x2014; material icon named "skip next".
  'skip_next': const IconData(0xe044, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">skip_previous</i> &#x2014; material icon named "skip previous".
  'skip_previous': const IconData(0xe045, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">slideshow</i> &#x2014; material icon named "slideshow".
  'slideshow': const IconData(0xe41b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">slow_motion_video</i> &#x2014; material icon named "slow motion video".
  'slow_motion_video': const IconData(0xe068, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">smartphone</i> &#x2014; material icon named "smartphone".
  'smartphone': const IconData(0xe32c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">smoke_free</i> &#x2014; material icon named "smoke free".
  'smoke_free': const IconData(0xeb4a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">smoking_rooms</i> &#x2014; material icon named "smoking rooms".
  'smoking_rooms': const IconData(0xeb4b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sms</i> &#x2014; material icon named "sms".
  'sms': const IconData(0xe625, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sms_failed</i> &#x2014; material icon named "sms failed".
  'sms_failed': const IconData(0xe626, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">snooze</i> &#x2014; material icon named "snooze".
  'snooze': const IconData(0xe046, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sort</i> &#x2014; material icon named "sort".
  'sort': const IconData(0xe164, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">sort_by_alpha</i> &#x2014; material icon named "sort by alpha".
  'sort_by_alpha': const IconData(0xe053, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">spa</i> &#x2014; material icon named "spa".
  'spa': const IconData(0xeb4c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">space_bar</i> &#x2014; material icon named "space bar".
  'space_bar': const IconData(0xe256, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">speaker</i> &#x2014; material icon named "speaker".
  'speaker': const IconData(0xe32d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">speaker_group</i> &#x2014; material icon named "speaker group".
  'speaker_group': const IconData(0xe32e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">speaker_notes</i> &#x2014; material icon named "speaker notes".
  'speaker_notes': const IconData(0xe8cd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">speaker_notes_off</i> &#x2014; material icon named "speaker notes off".
  'speaker_notes_off': const IconData(0xe92a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">speaker_phone</i> &#x2014; material icon named "speaker phone".
  'speaker_phone': const IconData(0xe0d2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">spellcheck</i> &#x2014; material icon named "spellcheck".
  'spellcheck': const IconData(0xe8ce, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">star</i> &#x2014; material icon named "star".
  'star': const IconData(0xe838, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">star_border</i> &#x2014; material icon named "star border".
  'star_border': const IconData(0xe83a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">star_half</i> &#x2014; material icon named "star half".
  'star_half': const IconData(0xe839, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">stars</i> &#x2014; material icon named "stars".
  'stars': const IconData(0xe8d0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">stay_current_landscape</i> &#x2014; material icon named "stay current landscape".
  'stay_current_landscape': const IconData(0xe0d3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">stay_current_portrait</i> &#x2014; material icon named "stay current portrait".
  'stay_current_portrait': const IconData(0xe0d4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">stay_primary_landscape</i> &#x2014; material icon named "stay primary landscape".
  'stay_primary_landscape': const IconData(0xe0d5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">stay_primary_portrait</i> &#x2014; material icon named "stay primary portrait".
  'stay_primary_portrait': const IconData(0xe0d6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">stop</i> &#x2014; material icon named "stop".
  'stop': const IconData(0xe047, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">stop_screen_share</i> &#x2014; material icon named "stop screen share".
  'stop_screen_share': const IconData(0xe0e3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">storage</i> &#x2014; material icon named "storage".
  'storage': const IconData(0xe1db, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">store</i> &#x2014; material icon named "store".
  'store': const IconData(0xe8d1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">store_mall_directory</i> &#x2014; material icon named "store mall directory".
  'store_mall_directory': const IconData(0xe563, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">straighten</i> &#x2014; material icon named "straighten".
  'straighten': const IconData(0xe41c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">streetview</i> &#x2014; material icon named "streetview".
  'streetview': const IconData(0xe56e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">strikethrough_s</i> &#x2014; material icon named "strikethrough s".
  'strikethrough_s': const IconData(0xe257, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">style</i> &#x2014; material icon named "style".
  'style': const IconData(0xe41d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">subdirectory_arrow_left</i> &#x2014; material icon named "subdirectory arrow left".
  'subdirectory_arrow_left': const IconData(0xe5d9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">subdirectory_arrow_right</i> &#x2014; material icon named "subdirectory arrow right".
  'subdirectory_arrow_right': const IconData(0xe5da, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">subject</i> &#x2014; material icon named "subject".
  'subject': const IconData(0xe8d2, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">subscriptions</i> &#x2014; material icon named "subscriptions".
  'subscriptions': const IconData(0xe064, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">subtitles</i> &#x2014; material icon named "subtitles".
  'subtitles': const IconData(0xe048, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">subway</i> &#x2014; material icon named "subway".
  'subway': const IconData(0xe56f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">supervised_user_circle</i> &#x2014; material icon named "supervised user circle".
  'supervised_user_circle': const IconData(0xe939, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">supervisor_account</i> &#x2014; material icon named "supervisor account".
  'supervisor_account': const IconData(0xe8d3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">surround_sound</i> &#x2014; material icon named "surround sound".
  'surround_sound': const IconData(0xe049, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">swap_calls</i> &#x2014; material icon named "swap calls".
  'swap_calls': const IconData(0xe0d7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">swap_horiz</i> &#x2014; material icon named "swap horiz".
  'swap_horiz': const IconData(0xe8d4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">swap_horizontal_circle</i> &#x2014; material icon named "swap horizontal circle".
  'swap_horizontal_circle': const IconData(0xe933, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">swap_vert</i> &#x2014; material icon named "swap vert".
  'swap_vert': const IconData(0xe8d5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">swap_vertical_circle</i> &#x2014; material icon named "swap vertical circle".
  'swap_vertical_circle': const IconData(0xe8d6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">switch_camera</i> &#x2014; material icon named "switch camera".
  'switch_camera': const IconData(0xe41e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">switch_video</i> &#x2014; material icon named "switch video".
  'switch_video': const IconData(0xe41f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sync</i> &#x2014; material icon named "sync".
  'sync': const IconData(0xe627, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sync_disabled</i> &#x2014; material icon named "sync disabled".
  'sync_disabled': const IconData(0xe628, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">sync_problem</i> &#x2014; material icon named "sync problem".
  'sync_problem': const IconData(0xe629, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">system_update</i> &#x2014; material icon named "system update".
  'system_update': const IconData(0xe62a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">system_update_alt</i> &#x2014; material icon named "system update alt".
  'system_update_alt': const IconData(0xe8d7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tab</i> &#x2014; material icon named "tab".
  'tab': const IconData(0xe8d8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tab_unselected</i> &#x2014; material icon named "tab unselected".
  'tab_unselected': const IconData(0xe8d9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">table_chart</i> &#x2014; material icon named "table chart".
  'table_chart': const IconData(0xe265, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tablet</i> &#x2014; material icon named "tablet".
  'tablet': const IconData(0xe32f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tablet_android</i> &#x2014; material icon named "tablet android".
  'tablet_android': const IconData(0xe330, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tablet_mac</i> &#x2014; material icon named "tablet mac".
  'tablet_mac': const IconData(0xe331, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tag_faces</i> &#x2014; material icon named "tag faces".
  'tag_faces': const IconData(0xe420, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tap_and_play</i> &#x2014; material icon named "tap and play".
  'tap_and_play': const IconData(0xe62b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">terrain</i> &#x2014; material icon named "terrain".
  'terrain': const IconData(0xe564, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_fields</i> &#x2014; material icon named "text fields".
  'text_fields': const IconData(0xe262, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_format</i> &#x2014; material icon named "text format".
  'text_format': const IconData(0xe165, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_rotate_up</i> &#x2014; material icon named "text rotate up".
  'text_rotate_up': const IconData(0xe93a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_rotate_vertical</i> &#x2014; material icon named "text rotate vertical".
  'text_rotate_vertical': const IconData(0xe93b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_rotation_angledown</i> &#x2014; material icon named "text rotation angledown".
  'text_rotation_angledown': const IconData(0xe93c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_rotation_angleup</i> &#x2014; material icon named "text rotation angleup".
  'text_rotation_angleup': const IconData(0xe93d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_rotation_down</i> &#x2014; material icon named "text rotation down".
  'text_rotation_down': const IconData(0xe93e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">text_rotation_none</i> &#x2014; material icon named "text rotation none".
  'text_rotation_none': const IconData(0xe93f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">textsms</i> &#x2014; material icon named "textsms".
  'textsms': const IconData(0xe0d8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">texture</i> &#x2014; material icon named "texture".
  'texture': const IconData(0xe421, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">theaters</i> &#x2014; material icon named "theaters".
  'theaters': const IconData(0xe8da, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">thumb_down</i> &#x2014; material icon named "thumb down".
  'thumb_down': const IconData(0xe8db, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">thumb_up</i> &#x2014; material icon named "thumb up".
  'thumb_up': const IconData(0xe8dc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">thumbs_up_down</i> &#x2014; material icon named "thumbs up down".
  'thumbs_up_down': const IconData(0xe8dd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">time_to_leave</i> &#x2014; material icon named "time to leave".
  'time_to_leave': const IconData(0xe62c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">timelapse</i> &#x2014; material icon named "timelapse".
  'timelapse': const IconData(0xe422, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">timeline</i> &#x2014; material icon named "timeline".
  'timeline': const IconData(0xe922, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">timer</i> &#x2014; material icon named "timer".
  'timer': const IconData(0xe425, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">timer_10</i> &#x2014; material icon named "timer 10".
  'timer_10': const IconData(0xe423, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">timer_3</i> &#x2014; material icon named "timer 3".
  'timer_3': const IconData(0xe424, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">timer_off</i> &#x2014; material icon named "timer off".
  'timer_off': const IconData(0xe426, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">title</i> &#x2014; material icon named "title".
  'title': const IconData(0xe264, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">toc</i> &#x2014; material icon named "toc".
  'toc': const IconData(0xe8de, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">today</i> &#x2014; material icon named "today".
  'today': const IconData(0xe8df, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">toll</i> &#x2014; material icon named "toll".
  'toll': const IconData(0xe8e0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tonality</i> &#x2014; material icon named "tonality".
  'tonality': const IconData(0xe427, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">touch_app</i> &#x2014; material icon named "touch app".
  'touch_app': const IconData(0xe913, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">toys</i> &#x2014; material icon named "toys".
  'toys': const IconData(0xe332, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">track_changes</i> &#x2014; material icon named "track changes".
  'track_changes': const IconData(0xe8e1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">traffic</i> &#x2014; material icon named "traffic".
  'traffic': const IconData(0xe565, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">train</i> &#x2014; material icon named "train".
  'train': const IconData(0xe570, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tram</i> &#x2014; material icon named "tram".
  'tram': const IconData(0xe571, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">transfer_within_a_station</i> &#x2014; material icon named "transfer within a station".
  'transfer_within_a_station': const IconData(0xe572, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">transform</i> &#x2014; material icon named "transform".
  'transform': const IconData(0xe428, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">transit_enterexit</i> &#x2014; material icon named "transit enterexit".
  'transit_enterexit': const IconData(0xe579, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">translate</i> &#x2014; material icon named "translate".
  'translate': const IconData(0xe8e2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">trending_down</i> &#x2014; material icon named "trending down".
  'trending_down': const IconData(0xe8e3, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">trending_flat</i> &#x2014; material icon named "trending flat".
  'trending_flat': const IconData(0xe8e4, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">trending_up</i> &#x2014; material icon named "trending up".
  'trending_up': const IconData(0xe8e5, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">trip_origin</i> &#x2014; material icon named "trip origin".
  'trip_origin': const IconData(0xe57b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tune</i> &#x2014; material icon named "tune".
  'tune': const IconData(0xe429, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">turned_in</i> &#x2014; material icon named "turned in".
  'turned_in': const IconData(0xe8e6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">turned_in_not</i> &#x2014; material icon named "turned in not".
  'turned_in_not': const IconData(0xe8e7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">tv</i> &#x2014; material icon named "tv".
  'tv': const IconData(0xe333, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">unarchive</i> &#x2014; material icon named "unarchive".
  'unarchive': const IconData(0xe169, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">undo</i> &#x2014; material icon named "undo".
  'undo': const IconData(0xe166, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">unfold_less</i> &#x2014; material icon named "unfold less".
  'unfold_less': const IconData(0xe5d6, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">unfold_more</i> &#x2014; material icon named "unfold more".
  'unfold_more': const IconData(0xe5d7, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">update</i> &#x2014; material icon named "update".
  'update': const IconData(0xe923, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">usb</i> &#x2014; material icon named "usb".
  'usb': const IconData(0xe1e0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">verified_user</i> &#x2014; material icon named "verified user".
  'verified_user': const IconData(0xe8e8, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vertical_align_bottom</i> &#x2014; material icon named "vertical align bottom".
  'vertical_align_bottom': const IconData(0xe258, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vertical_align_center</i> &#x2014; material icon named "vertical align center".
  'vertical_align_center': const IconData(0xe259, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vertical_align_top</i> &#x2014; material icon named "vertical align top".
  'vertical_align_top': const IconData(0xe25a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vibration</i> &#x2014; material icon named "vibration".
  'vibration': const IconData(0xe62d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">video_call</i> &#x2014; material icon named "video call".
  'video_call': const IconData(0xe070, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">video_label</i> &#x2014; material icon named "video label".
  'video_label': const IconData(0xe071, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">video_library</i> &#x2014; material icon named "video library".
  'video_library': const IconData(0xe04a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">videocam</i> &#x2014; material icon named "videocam".
  'videocam': const IconData(0xe04b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">videocam_off</i> &#x2014; material icon named "videocam off".
  'videocam_off': const IconData(0xe04c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">videogame_asset</i> &#x2014; material icon named "videogame asset".
  'videogame_asset': const IconData(0xe338, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_agenda</i> &#x2014; material icon named "view agenda".
  'view_agenda': const IconData(0xe8e9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_array</i> &#x2014; material icon named "view array".
  'view_array': const IconData(0xe8ea, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_carousel</i> &#x2014; material icon named "view carousel".
  'view_carousel': const IconData(0xe8eb, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_column</i> &#x2014; material icon named "view column".
  'view_column': const IconData(0xe8ec, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_comfy</i> &#x2014; material icon named "view comfy".
  'view_comfy': const IconData(0xe42a, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_compact</i> &#x2014; material icon named "view compact".
  'view_compact': const IconData(0xe42b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_day</i> &#x2014; material icon named "view day".
  'view_day': const IconData(0xe8ed, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_headline</i> &#x2014; material icon named "view headline".
  'view_headline': const IconData(0xe8ee, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_list</i> &#x2014; material icon named "view list".
  'view_list': const IconData(0xe8ef, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">view_module</i> &#x2014; material icon named "view module".
  'view_module': const IconData(0xe8f0, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_quilt</i> &#x2014; material icon named "view quilt".
  'view_quilt': const IconData(0xe8f1, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">view_stream</i> &#x2014; material icon named "view stream".
  'view_stream': const IconData(0xe8f2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">view_week</i> &#x2014; material icon named "view week".
  'view_week': const IconData(0xe8f3, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vignette</i> &#x2014; material icon named "vignette".
  'vignette': const IconData(0xe435, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">visibility</i> &#x2014; material icon named "visibility".
  'visibility': const IconData(0xe8f4, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">visibility_off</i> &#x2014; material icon named "visibility off".
  'visibility_off': const IconData(0xe8f5, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">voice_chat</i> &#x2014; material icon named "voice chat".
  'voice_chat': const IconData(0xe62e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">voicemail</i> &#x2014; material icon named "voicemail".
  'voicemail': const IconData(0xe0d9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">volume_down</i> &#x2014; material icon named "volume down".
  'volume_down': const IconData(0xe04d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">volume_mute</i> &#x2014; material icon named "volume mute".
  'volume_mute': const IconData(0xe04e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">volume_off</i> &#x2014; material icon named "volume off".
  'volume_off': const IconData(0xe04f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">volume_up</i> &#x2014; material icon named "volume up".
  'volume_up': const IconData(0xe050, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vpn_key</i> &#x2014; material icon named "vpn key".
  'vpn_key': const IconData(0xe0da, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">vpn_lock</i> &#x2014; material icon named "vpn lock".
  'vpn_lock': const IconData(0xe62f, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wallpaper</i> &#x2014; material icon named "wallpaper".
  'wallpaper': const IconData(0xe1bc, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">warning</i> &#x2014; material icon named "warning".
  'warning': const IconData(0xe002, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">watch</i> &#x2014; material icon named "watch".
  'watch': const IconData(0xe334, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">watch_later</i> &#x2014; material icon named "watch later".
  'watch_later': const IconData(0xe924, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wb_auto</i> &#x2014; material icon named "wb auto".
  'wb_auto': const IconData(0xe42c, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wb_cloudy</i> &#x2014; material icon named "wb cloudy".
  'wb_cloudy': const IconData(0xe42d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wb_incandescent</i> &#x2014; material icon named "wb incandescent".
  'wb_incandescent': const IconData(0xe42e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wb_iridescent</i> &#x2014; material icon named "wb iridescent".
  'wb_iridescent': const IconData(0xe436, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wb_sunny</i> &#x2014; material icon named "wb sunny".
  'wb_sunny': const IconData(0xe430, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wc</i> &#x2014; material icon named "wc".
  'wc': const IconData(0xe63d, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">web</i> &#x2014; material icon named "web".
  'web': const IconData(0xe051, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">web_asset</i> &#x2014; material icon named "web asset".
  'web_asset': const IconData(0xe069, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">weekend</i> &#x2014; material icon named "weekend".
  'weekend': const IconData(0xe16b, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">whatshot</i> &#x2014; material icon named "whatshot".
  'whatshot': const IconData(0xe80e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">widgets</i> &#x2014; material icon named "widgets".
  'widgets': const IconData(0xe1bd, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wifi</i> &#x2014; material icon named "wifi".
  'wifi': const IconData(0xe63e, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wifi_lock</i> &#x2014; material icon named "wifi lock".
  'wifi_lock': const IconData(0xe1e1, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wifi_tethering</i> &#x2014; material icon named "wifi tethering".
  'wifi_tethering': const IconData(0xe1e2, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">work</i> &#x2014; material icon named "work".
  'work': const IconData(0xe8f9, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">wrap_text</i> &#x2014; material icon named "wrap text".
  'wrap_text': const IconData(0xe25b, fontFamily: 'MaterialIcons', matchTextDirection: true),

  /// <i class="material-icons md-36">youtube_searched_for</i> &#x2014; material icon named "youtube searched for".
  'youtube_searched_for': const IconData(0xe8fa, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">zoom_in</i> &#x2014; material icon named "zoom in".
  'zoom_in': const IconData(0xe8ff, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">zoom_out</i> &#x2014; material icon named "zoom out".
  'zoom_out': const IconData(0xe900, fontFamily: 'MaterialIcons'),

  /// <i class="material-icons md-36">zoom_out_map</i> &#x2014; material icon named "zoom out map".
  'zoom_out_map': const IconData(0xe56b, fontFamily: 'MaterialIcons')
// END GENERATED
};
