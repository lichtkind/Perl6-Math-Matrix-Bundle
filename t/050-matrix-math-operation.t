use Test;
use Math::Matrix;
plan 10;

my $matrix = Math::Matrix.new([[1,2],[3,4]]);
my $m1 = Math::Matrix.new([[1]]);

subtest {
   plan 1;
   ok (｜$matrix ｜ == -2), 'ascii determinant operator';
}, "Determinant";

subtest {
   plan 2;
   ok ‖ $m1 ‖ == 1, 'norm on simplest matrix';
   ok ‖ $matrix ‖ == 5.477225575051661, 'norm on default matrix';
}, "L2 Norm";

subtest {
    plan 10;
    my $expected1 = Math::Matrix.new([[3,5],[3,4]]);
    my $expected2 = Math::Matrix.new([[1,2],[5,7]]);
    my $expected3 = Math::Matrix.new([[3,2],[6,4]]);
    my $expected4 = Math::Matrix.new([[1,4],[3,7]]);

    ok $matrix.add-row(0,[2,3]) ~~ $expected1,  "add a row";
    ok $matrix.add-row(1,[2,3]) ~~ $expected2,  "add another row";
    dies-ok { $matrix.add-column(1,(1,2)) },    "row is not array";
    dies-ok { $matrix.add-row(3,[1,2]) },       "row index out of bound";
    dies-ok { $matrix.add-row(1,[1])   },       "row size out of bound";

    ok $matrix.add-column(0,[2,3])~~ $expected3,"add a column";
    ok $matrix.add-column(1,[2,3])~~ $expected4,"add another column";
    dies-ok { $matrix.add-column(1,(1,2)) },    "column is not array";
    dies-ok { $matrix.add-column(3,[1,2]) },    "column index out of bound";
    dies-ok { $matrix.add-column(1,[1])   },    "column size out of bound";
}, "Vector Addition";


subtest {
    plan 5;
    my $matrix2 = Math::Matrix.new([[4,3],[2,1]]);
    my $expected = Math::Matrix.new([[5,5],[5,5]]);

    ok $matrix.add( $matrix2 ) ~~ $expected, "Sum of matrices";
    ok $matrix2.add( $matrix ) ~~ $expected, "Sum of matrices reversed";
    ok $matrix + $matrix2 ~~ $expected, "Sum of matrices using + operator";
    ok $matrix2 + $matrix ~~ $expected, "Sum of matrices using + operator reversed";

    dies-ok { $matrix.add(Math::Matrix.new([[1]]))}, "matrix size out of bound";
}, "Matrix Addition";


subtest {
    plan 3;
    my $matrix2 = Math::Matrix.new([[4,3],[2,1]]);
    my $expected = Math::Matrix.new([[ -3 , -1 ],[ 1 , 3 ]]);

    ok $matrix.subtract( $matrix2 ) ~~ $expected,         "Substraction of matrices";
    ok $matrix - $matrix2 ~~ $expected,                   "Substraction of matrices using - operator";
    dies-ok { $matrix.subtract(Math::Matrix.new([[1]]))}, "matrix size out of bound";
}, "Subtraction";


subtest {
    plan 6;
    my $expected1 = Math::Matrix.new([[3,6],[3,4]]);
    my $expected2 = Math::Matrix.new([[1,2],[9,12]]);
    my $expected3 = Math::Matrix.new([[3,2],[9,4]]);
    my $expected4 = Math::Matrix.new([[1,6],[3,12]]);

    ok $matrix.multiply-row(0,3) ~~ $expected1,   "multiply a row";
    ok $matrix.multiply-row(1,3) ~~ $expected2,   "multiply another row";
    dies-ok { $matrix.multiply-row(3,2) },        "row index out of bound";

    ok $matrix.multiply-column(0,3) ~~ $expected3,"multiply a column";
    ok $matrix.multiply-column(1,3) ~~ $expected4,"multiply another column";
    dies-ok { $matrix.multiply-column(3,2) },     "row index out of bound";
}, "Partial Scalar Multiplication";

subtest {
    plan 3;
    my $matrix = Math::Matrix.new([[1,1],[1,1]]);
    my $expected = Math::Matrix.new([[2.2, 2.2],[2.2, 2.2]]);
    ok $matrix.multiply( 2.2 ) ~~ $expected, "multiplication with real working";
    ok $matrix * 2.2 ~~ $expected, "multiplication with real working with operator *";
    ok 2.2 * $matrix ~~ $expected, "multiplication with real working with operator *, reverse args";
}, "Scalar Multiplication";

subtest {
    plan 3;
    my $matrix = Math::Matrix.new([[1,2],[3,4]]);
    my $matrix2 = Math::Matrix.new([[4,3],[2,1]]);
    my $expected = Math::Matrix.new([[ 4 , 6 ],[ 6 , 4 ]]);

    ok $matrix.multiply( $matrix2 ) ~~ $expected, "Multiplication of matrices (element by element)";
    ok $matrix * $matrix2 ~~ $expected,           "Multiplication of matrices using * operator";
    dies-ok {$matrix.multiply(Math::Matrix.new([[1]]))}, "matrix size out of bound";
}, "Cellwise Multiplication";


subtest {
    plan 8;
    my $a = Math::Matrix.new( [[1,2,3],[4,5,6]] );
    my $b = Math::Matrix.new( [[7,8],[9,10],[11,12]] );
    my $p = Math::Matrix.new([[58,64],[139,154]]);
    my $matrix   = Math::Matrix.new([[1,2],[3,4]]);
    my $identity = Math::Matrix.new-identity(2);

    ok $a.dotProduct( $b ) ~~ $p,            "Simple multiplication check";
    ok ($a ⋅ $b) ~~ $p,                      "Simple multiplication check with ⋅ operator";
    ok ($a dot $b) ~~ $p,                    "Simple multiplication check with ⋅ operator, texas form";
    ok $matrix ** 0 ~~ $identity,            "times one means no multiplication";
    ok $matrix ** 1 ~~ $matrix,              "times one means no multiplication";
    ok $matrix ** 2 ~~ $matrix dot $matrix,  "power operator works too";

    my $c = Math::Matrix.new( [[7,8],[9,10],[11,12],[13,14]] );
    dies-ok { $a ⋅ $c } , "Matrices can't be multiplied, first matrix column count should be equal to second matrix row count";
    dies-ok { $a.dotProduct( $c ) } , "Matrices can't be multiplied, first matrix column count should be equal to second matrix row count";
}, "Dot Product";


subtest {
    plan 4;
    my $a = Math::Matrix.new( [[1,2],[3,4]] );
    my $b = Math::Matrix.new( [[5,6],[7,8]] );
    my $p = Math::Matrix.new( [[5,6,10,12],[7,8,14,16],[15,18,20,24],[21,24,28,32]] );
    my $i = Math::Matrix.new( [[1]] );
    my $z3 = Math::Matrix.new-zero(3);
    my $z12 = Math::Matrix.new-zero(12);

    ok $i.tensorProduct( $i ) ~~ $i,     "Trivial multiplication check";
    ok $a.tensorProduct( $b ) ~~ $p,     "Simple multiplication check";
    ok $z3.tensorProduct($p ) ~~ $z12,   "check for richt dimension expansion on larger matrix";
    ok ($a x $b) ~~ $p,                  "Simple multiplication check with x operator";
}, "Tensor Product";




