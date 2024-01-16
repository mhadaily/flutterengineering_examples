import 'dart:io';
import 'dart:math';

//mhttps://raw.githubusercontent.com/dart-lang/language/main/accepted/3.0/class-modifiers/feature-specification.md
enum DeclarationType {
  classDeclaration,
  baseClassDeclaration,
  interfaceClassDeclaration,
  finalClassDeclaration,
  sealedClassDeclaration,
  abstractClassDeclaration,
  abstractBaseClassDeclaration,
  abstractInterfaceClassDeclaration,
  abstractFinalClassDeclaration,
  mixinClassDeclaration,
  baseMixinClassDeclaration,
  abstractMixinClassDeclaration,
  abstractBaseMixinClassDeclaration,
  mixinDeclaration,
  baseMixinDeclaration,
}

class Declaration {
  final DeclarationType type;
  final bool canConstruct;
  final bool canExtend;
  final bool canImplement;
  final bool canMixin;
  final bool isExhaustive;

  Declaration({
    required this.type,
    required this.canConstruct,
    required this.canExtend,
    required this.canImplement,
    required this.canMixin,
    required this.isExhaustive,
  });
}

final declarations = [
  Declaration(
    type: DeclarationType.classDeclaration,
    canConstruct: true,
    canExtend: true,
    canImplement: true,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.baseClassDeclaration,
    canConstruct: true,
    canExtend: true,
    canImplement: false,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.interfaceClassDeclaration,
    canConstruct: true,
    canExtend: false,
    canImplement: true,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.finalClassDeclaration,
    canConstruct: true,
    canExtend: false,
    canImplement: false,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.sealedClassDeclaration,
    canConstruct: false,
    canExtend: false,
    canImplement: false,
    canMixin: false,
    isExhaustive: true,
  ),
  Declaration(
    type: DeclarationType.abstractClassDeclaration,
    canConstruct: false,
    canExtend: true,
    canImplement: true,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.abstractBaseClassDeclaration,
    canConstruct: false,
    canExtend: true,
    canImplement: false,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.abstractInterfaceClassDeclaration,
    canConstruct: false,
    canExtend: false,
    canImplement: true,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.abstractFinalClassDeclaration,
    canConstruct: false,
    canExtend: false,
    canImplement: false,
    canMixin: false,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.mixinClassDeclaration,
    canConstruct: true,
    canExtend: true,
    canImplement: true,
    canMixin: true,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.baseMixinClassDeclaration,
    canConstruct: true,
    canExtend: true,
    canImplement: false,
    canMixin: true,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.abstractMixinClassDeclaration,
    canConstruct: false,
    canExtend: true,
    canImplement: true,
    canMixin: true,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.abstractBaseMixinClassDeclaration,
    canConstruct: false,
    canExtend: true,
    canImplement: false,
    canMixin: true,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.mixinDeclaration,
    canConstruct: false,
    canExtend: false,
    canImplement: true,
    canMixin: true,
    isExhaustive: false,
  ),
  Declaration(
    type: DeclarationType.baseMixinDeclaration,
    canConstruct: false,
    canExtend: false,
    canImplement: false,
    canMixin: true,
    isExhaustive: false,
  ),
];

String formatTable(List<String> header, List<List<String>> rows) {
  final maxWidths = <int>[];
  for (var i = 0; i < header.length; i++) {
    maxWidths.add(header[i].length);
    for (var row in rows) {
      maxWidths[i] = max(maxWidths[i], row[i].length);
    }
  }

  final divider = '+${maxWidths.map((width) => '-' * (width + 2)).join('+')}+';
  final formattedRows = <String>[];
  formattedRows.add(divider);
  formattedRows.add(
      '| ${header.map((cell) => cell.padRight(maxWidths[header.indexOf(cell)])).join(' | ')} |');
  formattedRows.add(divider);
  for (var row in rows) {
    formattedRows.add(
        '| ${row.map((cell) => cell.padRight(maxWidths[rows.indexOf(row)])).join(' | ')} |');
  }
  formattedRows.add(divider);

  return formattedRows.join('\n');
}
/*
Many combinations don't make sense:

*   `base`, `interface`, and `final` all control the same two capabilities so
    are mutually exclusive.
*   `sealed` types cannot be constructed so it's redundant to combine with
    `abstract`.
*   `sealed` types already cannot be mixed in, extended or implemented
    from another library, so it's redundant to combine with `final`,
    `base`, or `interface`.
*   `mixin` as a modifier can obviously only be applied to a `class`
    declaration, which makes it also introduce a mixin.
*   `mixin` as a modifier cannot be applied to a mixin-application `class`
    declaration (the `class C = S with M;` syntax for declaring a class). The
    remaining modifiers can.
*   A `mixin` or `mixin class` declaration is intended to be mixed in,
    so its declaration cannot have an `interface`, `final` or `sealed` modifier.
*   A `mixin` declaration cannot be constructed, so `abstract` is redundant.
*   `enum` declarations cannot be extended, implemented, mixed in,
    and can always be instantiated, so no modifiers apply to `enum`
    declarations.

The remaining valid combinations and their capabilities are:

| Declaration | Construct? | Extend? | Implement? | Mix in? | Exhaustive? |
|--|--|--|--|--|--|
|`class`                    |**Yes**|**Yes**|**Yes**|No     |No     |
|`base class`               |**Yes**|**Yes**|No     |No     |No     |
|`interface class`          |**Yes**|No     |**Yes**|No     |No     |
|`final class`              |**Yes**|No     |No     |No     |No     |
|`sealed class`             |No     |No     |No     |No     |**Yes**|
|`abstract class`           |No     |**Yes**|**Yes**|No     |No     |
|`abstract base class`      |No     |**Yes**|No     |No     |No     |
|`abstract interface class` |No     |No     |**Yes**|No     |No     |
|`abstract final class`     |No     |No     |No     |No     |No     |
|`mixin class`              |**Yes**|**Yes**|**Yes**|**Yes**|No     |
|`base mixin class`         |**Yes**|**Yes**|No     |**Yes**|No     |
|`abstract mixin class`     |No     |**Yes**|**Yes**|**Yes**|No     |
|`abstract base mixin class`|No     |**Yes**|No     |**Yes**|No     |
|`mixin`                    |No     |No     |**Yes**|**Yes**|No     |
|`base mixin`               |No     |No     |No     |**Yes**|No     |

*/

void main() {
  // Ask questions to determine desired declaration properties
  print(
      'Do you want to be able to construct instances of this declaration? (yes/no)');
  final canConstruct = stdin.readLineSync()!.toLowerCase() == 'yes';

  print('Do you want to be able to extend this declaration? (yes/no)');
  final canExtend = stdin.readLineSync()!.toLowerCase() == 'yes';

  print('Do you want to be able to implement this declaration? (yes/no)');
  final canImplement = stdin.readLineSync()!.toLowerCase() == 'yes';

  print('Do you want to be able to mixin in this declaration? (yes/no)');
  final canMixin = stdin.readLineSync()!.toLowerCase() == 'yes';

  print('Do you want to be able to exhaustive in this declaration? (yes/no)');
  final isExhaustive = stdin.readLineSync()!.toLowerCase() == 'yes';

  // Filter declarations based on user's answers
  final potentialDeclarations = declarations.where((declaration) {
    return declaration.canConstruct == canConstruct &&
        declaration.canExtend == canExtend &&
        declaration.canImplement == canImplement &&
        declaration.isExhaustive == isExhaustive &&
        declaration.canMixin == canMixin;
  }).toList();

  // Present potential declarations or indicate no match
  if (potentialDeclarations.isNotEmpty) {
    print(
      formatTable(
        ['Potential Declarations'],
        potentialDeclarations
            .map((d) => [d.type.toString().split('.').last])
            .toList(),
      ),
    );
  } else {
    print('No matching declaration found based on your requirements.');
  }
}
