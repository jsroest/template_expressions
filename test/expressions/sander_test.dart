import 'package:template_expressions/template_expressions.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Simple test, no expressions',
    () {
      final template = Template(
        value: '''
Firstname: {{firstname}}
Lastname: {{lastname}}
Birthday: {{birthday}}
Credits: {{credits}}''',
        syntax: [const MustacheExpressionSyntax()],
      );
      final result = template.process(context: {
        'firstname': 'Sander',
        'lastname': 'Roest',
        'birthday': '11-01-1973',
        'credits': '100.99'
      });
      expect(result, '''
Firstname: Sander
Lastname: Roest
Birthday: 11-01-1973
Credits: 100.99''');
    },
  );

  test(
    'With dateFormat()',
    () {
      final template = Template(
        value: '''
Firstname: {{firstname}}
Lastname: {{lastname}}
Birthday: {{DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(birthday))}}
Credits: {{credits}}
Code: {{(code).toUpperCase()}}''',
        syntax: [const MustacheExpressionSyntax()],
      );
      final result = template.process(context: {
        'firstname': 'Sander',
        'lastname': 'Roest',
        'birthday': '1973-01-11',
        'credits': '100.99',
        'code': 'abc'
      });
      expect(result, '''
Firstname: Sander
Lastname: Roest
Birthday: 11-01-1973
Credits: 100.99
Code: ABC''');
    },
  );

  test(
    'With number format',
    () {
      const value = '''
Firstname: {{firstname}}
Lastname: {{lastname}}
Birthday: {{DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(birthday))}}
Credits: {{NumberFormat('0.00').format(credits)}}
Code: {{(code).toUpperCase()}}''';

      final template = Template(
        value: value,
        syntax: [const MustacheExpressionSyntax()],
      );

      const json = {
        'firstname': 'Sander',
        'lastname': 'Roest',
        'birthday': '1973-01-11',
        'credits': 0.999,
        'code': 'abc'
      };

      final result = template.process(context: json);
      expect(result, '''
Firstname: Sander
Lastname: Roest
Birthday: 11-01-1973
Credits: 1.00
Code: ABC''');
    },
  );

  test(
    'ZPL',
    () {
      const value = '''
^XA

^FX Top section with logo, name and address.
^CF0,60
^FO50,50^GB100,100,100^FS
^FO75,75^FR^GB100,100,100^FS
^FO93,93^GB40,40,40^FS
^FO220,50^FD{{sender_company_name}}^FS
^CF0,30
^FO220,115^FD{{sender_building_number}} {{sender_street}}^FS
^FO220,155^FD{{sender_city}} {{sender_state}} {{sender_zipcode}}^FS
^FO220,195^FD{{sender_country}} ({{sender_country_abbr}})^FS
^FO50,250^GB700,3,3^FS

^FX Second section with recipient address and permit information.
^CFA,30
^FO50,300^FD{{recipient_name}}^FS
^FO50,340^FD{{recipient_building_number}} {{recipient_street}}^FS
^FO50,380^FD{{recipient_city}} {{recipient_state}} {{recipient_zipcode}}^FS
^FO50,420^FD{{recipient_country}} ({{recipient_country_abbr}})^FS
^CFA,15
^FO600,300^GB150,150,3^FS
^FO638,340^FD{{permit_caption}}^FS
^FO638,390^FD{{permit_code}}^FS
^FO50,500^GB700,3,3^FS

^FX Third section with bar code.
^BY5,2,270
^FO100,550^BC^FD{{barcode}}^FS

^FX Fourth section (the two boxes on the bottom).
^FO50,900^GB700,250,3^FS
^FO400,900^GB3,250,3^FS
^CF0,40
^FO100,960^FD{{check_id}}^FS
^FO100,1010^FD{{ref1_caption}} {{ref1}}^FS
^FO100,1060^FD{{ref2_caption}} {{ref2}}^FS
^CF0,190
^FO470,955^FD{{to_letter_code}}^FS

^XZ''';

      final template = Template(
        value: value,
        syntax: [const MustacheExpressionSyntax()],
      );

      const json = {
        'sender_company_name': 'Intershipping, Inc.',
        'sender_building_number': '1000',
        'sender_street': 'Shipping Lane',
        'sender_city': 'Shelbyville',
        'sender_state': 'TN',
        'sender_zipcode': '38102',
        'sender_country': 'United States',
        'sender_country_abbr': 'USA',
        'recipient_name': 'John Doe',
        'recipient_building_number': '100',
        'recipient_street': 'Main Street',
        'recipient_city': 'Springfield',
        'recipient_state': 'TN',
        'recipient_zipcode': '39021',
        'recipient_country': 'United States',
        'recipient_country_abbr': 'USA',
        'barcode': '12345678',
        'permit_caption': 'Permit',
        'permit_code': '123456',
        'check_id': 'Ctr. X34B-1',
        'ref1_caption': 'REF1 F00B47',
        'ref2_caption': 'REF2 BL4H8',
        'to_letter_code': 'CA'
      };

      final result = template.process(context: json);
      expect(result, '''
^XA

^FX Top section with logo, name and address.
^CF0,60
^FO50,50^GB100,100,100^FS
^FO75,75^FR^GB100,100,100^FS
^FO93,93^GB40,40,40^FS
^FO220,50^FDIntershipping, Inc.^FS
^CF0,30
^FO220,115^FD1000 Shipping Lane^FS
^FO220,155^FDShelbyville TN 38102^FS
^FO220,195^FDUnited States (USA)^FS
^FO50,250^GB700,3,3^FS

^FX Second section with recipient address and permit information.
^CFA,30
^FO50,300^FDJohn Doe^FS
^FO50,340^FD100 Main Street^FS
^FO50,380^FDSpringfield TN 39021^FS
^FO50,420^FDUnited States (USA)^FS
^CFA,15
^FO600,300^GB150,150,3^FS
^FO638,340^FDPermit^FS
^FO638,390^FD123456^FS
^FO50,500^GB700,3,3^FS

^FX Third section with bar code.
^BY5,2,270
^FO100,550^BC^FD12345678^FS

^FX Fourth section (the two boxes on the bottom).
^FO50,900^GB700,250,3^FS
^FO400,900^GB3,250,3^FS
^CF0,40
^FO100,960^FDCtr. X34B-1^FS
^FO100,1010^FDREF1 F00B47 ^FS
^FO100,1060^FDREF2 BL4H8 ^FS
^CF0,190
^FO470,955^FDCA^FS

^XZ''');
    },
  );
}
