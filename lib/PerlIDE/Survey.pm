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
      values => ['Perl Navigator', 'PLS', 'Perl::LanguageServer', 'Other']
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
      collation_message => 'Percentage of submitters who use App::perlimports',
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
  },
  2026 => {
    theme => 'Perl Developer Survey 2026 is focused on understanding how Perl Developers interact with generative AI tools while writing Perl code.',
    ai => {
      label => 'This year, while writing Perl code, did you use generative AI?',
      input_type => 'checkbox',
      collation_message => 'Percentage of submitters that used generative AI while writing Perl code',
      collation_type => 'PERCENTAGE'
    },
    ai_models => {
      depends_on => 'ai',
      label => 'What models did you use to write Perl code this year?',
      input_type => 'select',
      collation_message => 'Models that users used this year',
      collation_type => 'SUMMATION',
      values => ['GPT', 'Claude', 'Gemini', 'Deep Seek', 'Grok', 'Llama', 'Mistral', 'Other']
    },
    ai_feel => {
      label => 'Which of the following best describes how you interact with generative AI when writing Perl code?',
      input_type => 'select',
      collation_message => 'How Perl Developers feel about generative AI',
      collation_type => 'SUMMATION',
      values => [
        'I do not use generative AI to write code',
        'I use it to generate some code, but I still write code by hand',
        'I vast majority, if not all code I produce is AI generated'
      ]
    },
    ai_rating => {
      label => 'How likely are you to use generative AI in 2027 while writing Perl code?',
      input_type => 'select',
      collation_message => 'How likely Perl Developers are to use generative AI in 2027',
      collation_type => 'SUMMATION',
      values => ['Very unlikely', 'Unlikely', 'Potentially', 'Likely', 'Very likely']
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
