package PerlIDE::Migrate;

use strict;
use warnings;

use FindBin '$Bin';
use Mojo::File;

sub migrate {
  my ($sql, $log) = @_;

  $log->info('Migrations STARTING.');
  $sql->migrations->from_file("$Bin/../migrations.sql")->migrate;
  $log->info('Migrations DONE.');

  my $db = $sql->db;
  my $ides_file = Mojo::File->new("$Bin/../ides.txt");
  my @ides = split("\n", $ides_file->slurp);

  $log->info('IDEs INSERTING.');
  my $tx = $db->begin;
  for my $ide (@ides) {
    chomp(my $clean = $ide);
    $db->query('INSERT OR IGNORE INTO ides ( id ) VALUES ( ? )', $clean);
  }
  $tx->commit;
  $log->info('IDEs DONE.');
}

1;
