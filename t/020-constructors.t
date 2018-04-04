use Test;
use Math::Matrix;
plan 27;

lives-ok { my $matrix = Math::Matrix.new([[1,2],[3,4]]); }  , "Able to create a int matrix";
lives-ok { my $matrix = Math::Matrix.new([[.1,2.11111],[3/5,4e-2]]); }, "created a rational matrix";
lives-ok { my $matrix = Math::Matrix.new([[1,2],[3,4]]); }  , "Able to create a complex matrix";
dies-ok  { my $matrix = Math::Matrix.new([[1,2],[1,2,3]]); }, "Different nuber of elements per line";
dies-ok  { my $matrix = Math::Matrix.new(); }               , "Constructor need params";
dies-ok  { my $matrix = Math::Matrix.new([[1,2],[3,"a"]]); }, "All elements have to be Numeric";

my $matrixa = Math::Matrix.new([[1,2],[3,4]]);
ok $matrixa ~~ Math::Matrix        , "object was created of right type";

my $from-perl = EVAL($matrixa.perl);
ok $from-perl ~~ $matrixa          , ".perl result can be evaled in a similar object";

my $data   =   [[1,3],[3,25]];
my $samedata = [[1,3],[3,25]];
my $dataMatrix = Math::Matrix.new($data);;
my $samedataMatrix = Math::Matrix.new($samedata);;
$data[0][0] = 0;
ok $dataMatrix ~~ $samedataMatrix  , "no bleed from input data to matrix";

ok $matrixa.Str().WHAT ~~ Str      , "Method Str should return a String";
is $matrixa.Str(), "[[1 2] [3 4]]" , "value is correct in Str context ";
is ~$matrixa, "[[1 2] [3 4]]"      , "content is correct in string context by prefix op";
is +$matrixa, 4                    , "content is correct in numeric context by prefix op";
is ?$matrixa, True                 , "content is correct in bool context by prefix op";

my $matrixb = Math::Matrix.new([[1,2],[3,4]]);
my $matrixc = Math::Matrix.new([[8,8],[8,8]]);
my $matrixd = Math::Matrix.new([[ 1.0, 2.0 ],[ 3.0 , 4.0 ]]);
my $matrixr = Math::Matrix.new([[ 1.1, 2.2 ],[ 3.3 , 4.4 ]]);
is ~$matrixr, "[[1.1 2.2] [3.3 4.4]]",  "correct content of real values in string context";

ok $matrixa.equal( $matrixb ), "equal method working";
ok $matrixa ~~ $matrixb      , "~~ operator working";

nok $matrixa.equal( $matrixc), "Non equal matrices, with equal method";
nok $matrixa ~~ $matrixc     , "Non equal matrices, foud via ~~";

ok $matrixa.equal( $matrixd) , "equal method working";
ok $matrixa ~~ $matrixd      , "~~ operator working";

my $zero = Math::Matrix.new-zero(3,4);
my $expectz = Math::Matrix.new([[0,0,0,0],[0,0,0,0],[0,0,0,0]]);
ok $zero ~~ $expectz, "Get zero matrix";
is ?$zero, False    , "zero matrix is false in bool context by prefix op";

my $identity = Math::Matrix.new-identity(3);
my $expected = Math::Matrix.new([[1,0,0],[0,1,0],[0,0,1]]);
ok $identity ~~ $expected, "Get identity matrix";

my $diagonal = Math::Matrix.new-diagonal([1,2,3]);
my $expectd   = Math::Matrix.new([[1,0,0],[0,2,0],[0,0,3]]);
ok $diagonal ~~ $expectd, "Get diagonal matrix";

#TODO: reinstate test either in success or failure
my $diagonal2 = Math::Matrix.new-diagonal( 1, 2, 3 );
ok  $diagonal2 ~~ $expectd, "Get diagonal matrix";

my $product = Math::Matrix.new-vector-product([1,2,3],[2,3,4]);
my $pexpect = Math::Matrix.new([[2,3,4],[4,6,8],[6,9,12]]);
ok $product.equal( $pexpect ), "matrix construction by vector product";
