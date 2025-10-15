package PerlIDE::Survey;

use strict;
use warnings;

my %years = (
  2025 => {
    theme => 'Perl IDE Survey 2025 is focused on understanding how Perl developers interact with external IDE tools.',
    lsp => {
      label => 'This year did you use an LSP server for Perl?',
      input_type => 'checkbox',
      collation_message => 'Percentage of submitters who use LSP in their IDEs',
      collation_type => 'PERCENTAGE'
    },
    lsp_server => {
      depends_on => 'lsp',
      label => 'What LSP server do you use?',
      input_type => 'select',
      collation_message => 'Types of LSP that submitters use',
      collation_type => 'SUMMATION',
      values => ['Perl Navigator', 'Perl::LanguageServer', 'Other']
    },
    perlcritic => {
      label => 'This year, have you used Perl::Critic (perlcritic)?',
      input_type => 'checkbox',
      collation_message => 'Percentage of submitters who use Perl::Critic',
      collation_type => 'PERCENTAGE'
    },
    perltidy => {
      label => 'This year, have you used Perl::Tidy (perltidy)?',
      input_type => 'checkbox',
      collation_message => 'Percentage of submitters who use Perl::Tidy',
      collation_type => 'PERCENTAGE'
    },
    profilers => {
      label => 'This year, have you used a profiler?',
      input_type => 'select',
      collation_message => 'Types of profilers that people use',
      collation_type => 'SUMMATION',
      values => ['Devel::NYTProf', 'Devel::DProf', 'p5-spy', 'Devel::SmallProf', 'Devel::StatProfiler', 'Other']
    }
  }
);

sub years {
  my ($year) = @_;

  return $years{$year};
}

1;
