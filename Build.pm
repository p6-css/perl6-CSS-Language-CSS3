use v6;

use CSS::Specification::Build;
use Panda::Builder;
use Panda::Common;

class Build is Panda::Builder {

    method build($where) {

        indir $where, {
            for (<etc css3x-background-20120724.txt> => <CSS3 Backgrounds_and_Borders>,
                ) {
                my ($input-spec, $class-isa) = .kv;

                for interface => 'Interface',
                    actions => 'Actions',
                    grammar => 'Grammar' {
                    my ($type, $subclass) = .kv;
                    my $name = (<CSS Module>, @$class-isa, <Spec>,  $subclass).flat.join('::');

                    my $class-dir = $*SPEC.catdir(<lib CSS Module>, @$class-isa, <Spec>);
                    mkdir $class-dir;

                    my $class-path = $*SPEC.catfile($class-dir, $subclass ~ '.pm');

                    my $input-path = $*SPEC.catfile( |@$input-spec );
                    say "Building $input-path => $name";
                    temp $*IN  = open $input-path, :r;
                    temp $*OUT = open $class-path, :w;

                    CSS::Specification::Build::generate( $type, $name );
                }
            }
        }
    }
}

# Build.pm can also be run standalone 
sub MAIN(Str $working-directory = '.') {
    Build.new.build($working-directory);
}
