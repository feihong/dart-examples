import 'dart:html';

class FormMaker {
  var form;
  var firstField;
  var fields = {};
  var submitCallback = (x) => null;

  FormMaker() {
    this.form = new Element.tag('form');
  }

  add(name, label, [type='text']) {
    var tagName = (['text', 'checkbox'].contains(type)) ? 'input' : type;

    var p = new Element.p();
    p.style.display = 'flex';
    this.form.append(p);

    var label_ = new Element.tag('label');
    label_.text = label + (type == 'checkbox' ? '' : ':');
    p.append(label_);

    var field = new Element.tag(tagName);
    field.name = name;
    if (tagName == 'input') {
      field.setAttribute('type', type);
    }

    this.fields[name] = field;
    if (this.firstField == null) {
      this.firstField = field;
    }

    if (type == 'checkbox') {
      field.style.marginRight = '5px';
      p.insertBefore(field, label_);
    } else {
      label_.style.marginRight = '5px';
      field.style.flex = '1';
      p.append(field);
    }
  }

  setValue(name, value) {
    this.fields[name].value = value;
  }

  addButton(label) {
    var p = new Element.p();
    this.form.append(p);

    var button = new Element.tag('button');
    button.text = label;
    button.onClick.listen((evt) {
      evt.preventDefault();
      this.submitCallback(this.getValues());
    });
    p.append(button);
  }

  getValues() {
    var pairs = this.form.querySelectorAll('input, checkbox, textarea').map((e) {
      var value = (e.attributes['type'] == 'checkbox') ?
        e.checked : e.value;
      return [e.name, value];
    });
    return new Map.fromIterable(pairs, key: (x) => x[0], value: (x) => x[1]);
  }

  render(id) {
    var el = querySelector('#' + id);
    el.append(this.form);
    this.firstField.focus();
  }
}
