import 'dart:html';
import 'dart:convert';
import './form_maker.dart';

main() {
    print('woo');

    var fm = new FormMaker();
    fm.add('slug', 'Project slug');
    fm.add('title', 'Project title');
    fm.add('desc', 'Description');
    fm.add('long_title', 'Long title');
    fm.add('long_desc', 'Long description', 'textarea');
    fm.add('ghp_branch', 'Create gh_pages branch', 'checkbox');
    fm.addButton('Submit');
    fm.render('content');

    fm.submitCallback = (values) {
      print(JSON.encode(values));
      // window.alert(JSON.encode(values));
    };
}
