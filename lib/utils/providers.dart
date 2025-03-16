import 'package:next_gen_metro/view_model/nfc_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';


List<SingleChildWidget> providers = [
  ChangeNotifierProvider<NfcViewModel>(create: (context) => NfcViewModel()),
];