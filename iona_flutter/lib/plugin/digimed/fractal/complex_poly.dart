import 'dart:typed_data';

import 'complex.dart';

abstract class ComplexPoly {
  List<double> terms;
  ComplexPoly derivative();
  ComplexX4 getValues(ComplexX4 x);
}

/// Polynomial 2
class ComplexPoly2 extends ComplexPoly {
  @override
  List<double> terms;

  ComplexPoly2(this.terms);

  ComplexPoly derivative() {
    throw Error();
  }

  ComplexX4 getValues(ComplexX4 x) {
    var y = ComplexX4.zero.addReal(terms[0]);
    final t1 = terms[1];
    return y + x.pow2().multiply(Float32x4(t1, t1, t1, t1));
  }
}

/// Polynomial 3
class ComplexPoly3 extends ComplexPoly {
  @override
  List<double> terms;

  ComplexPoly3(this.terms);

  @override
  ComplexPoly2 derivative() {
    final nt = <double>[];
    for (var i = 0; i < terms.length - 1; i++) {
      nt.add(terms[i + 1] * (i + 1));
    }
    return ComplexPoly2(nt);
  }

  @override
  ComplexX4 getValues(ComplexX4 x) {
    var y = ComplexX4.zero.addReal(terms[0]);
    final t1 = terms[1];
    final t2 = terms[2];
    y += x.multiply(Float32x4(t1, t1, t1, t1));
    y += x.pow2().multiply(Float32x4(t2, t2, t2, t2));
    return y;
  }
}

/// Polynomial 3
class ComplexPoly4 extends ComplexPoly {
  @override
  List<double> terms;

  ComplexPoly4(this.terms);

  @override
  ComplexPoly3 derivative() {
    final nt = <double>[];
    for (var i = 0; i < terms.length - 1; i++) {
      nt.add(terms[i + 1] * (i + 1));
    }
    return ComplexPoly3(nt);
  }

  @override
  ComplexX4 getValues(ComplexX4 x) {
    var y = ComplexX4.zero.addReal(terms[0]);
    final t1 = terms[1];
    final t2 = terms[2];
    final t3 = terms[3];
    y += x.multiply(Float32x4(t1, t1, t1, t1));
    y += x.pow2().multiply(Float32x4(t2, t2, t2, t2));
    y += x.pow3().multiply(Float32x4(t3, t3, t3, t3));
    return y;
  }
}
