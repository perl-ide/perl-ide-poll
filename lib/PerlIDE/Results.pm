package PerlIDE::Results;

use strict;
use warnings;

use PerlIDE::Survey;
use Cpanel::JSON::XS;

sub get_total_submissions_for_year {
  my ($db, $year) = @_;

  my $total_hash = $db->query(<<'SQL', $year)->hash;
SELECT count(*) as total_submissions FROM submissions WHERE year = ?
SQL
  return $total_hash->{total_submissions};
}

sub get_results_for_year {
  my ($db, $year) = @_;

  my $primary_ides = $db->query(<<'SQL', $year)->hashes;
SELECT primary_ide, count(primary_ide) as primary_ide_count FROM
submissions WHERE year = ? GROUP BY primary_ide ORDER BY primary_ide_count
SQL
  my $secondary_ides = $db->query(<<'SQL', $year)->hashes;
SELECT secondary_ide, count(secondary_ide) as secondary_ide_count FROM
submissions WHERE year = ? GROUP BY secondary_ide ORDER BY secondary_ide_count
SQL

  my $collated_data = _collate_year_data($db, $year);

  return {
    primary_ides => [$primary_ides->each],
    secondary_ides => [$secondary_ides->each],
    collated_data => $collated_data
  };
}

sub _collate_year_data {
  my ($db, $year) = @_;

  my $survey = PerlIDE::Survey::years($year);

  my @submission_data = $db->query(<<'SQL', $year)->hashes->each;
SELECT data FROM submissions WHERE year = $year
SQL

  my $c;
  for (@submission_data) {
    my $json = decode_json($_->{data});
    for my $key (keys %{$survey}) {
      next if $key eq 'theme' || !$json->{$key};
      my $field = $survey->{$key};
      my $collation_type = $field->{collation_type};
      if ($collation_type eq 'SUMMATION') {
        $c->{$key}->{$json->{$key}}++;
      }
      elsif ($collation_type eq 'PERCENTAGE') {
        ++$c->{$key};
      }
    }
  }

  return $c;
}

1;
