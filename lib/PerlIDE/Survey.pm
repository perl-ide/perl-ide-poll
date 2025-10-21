package PerlIDE::Survey;

use strict;
use warnings;

my %years = (
  2025 => {
    theme => 'Perl Developer Survey 2025 is focused on understanding how Perl developers interact with external IDE tools.',
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
    perlimports => {
      label => 'This year, have you used App::perlimports (perlimports)?',
      input_type => 'checkbox',
      collation_message => 'Percentage of submitters who use Perl::Imports',
      collation_type => 'PERCENTAGE'
    },
    profilers => {
      label => 'This year, have you used a profiler?',
      input_type => 'select',
      collation_message => 'Types of profilers that submitters use',
      collation_type => 'SUMMATION',
      values => ['Devel::NYTProf', 'Devel::DProf', 'p5-spy', 'Devel::SmallProf', 'Devel::StatProfiler', 'Other']
    },
    cpan_client => {
      label => 'This year, which of the following CPAN clients did you use the most?',
      input_type => 'select',
      collation_message => 'Types of CPAN clients that submitters use',
      collation_type => 'SUMMATION',
      values => ['CPAN', 'App::cpanminus', 'App::cpm', 'CPANPLUS', 'Other']
    },
    perl_version => {
      label => 'This year, which of the following Perl versions did you work with most?',
      input_type => 'select',
      collation_message => 'Versions of Perl that submitters are using',
      collation_type => 'SUMMATION',
      values => ['Other', '5.24', '5.26', '5.28', '5.30', '5.32', '5.34', '5.36', '5.38', '5.40', '5.42']
    }
  }
);

sub years {
  my ($year) = @_;

  if (!$year) {
    return %years;
  }

  return $years{$year};
}

1;
