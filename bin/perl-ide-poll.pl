#!/usr/bin/env perl

use strict;
use warnings;
use FindBin '$Bin';
use lib "$Bin/../lib";

use PerlIDE::Migrate;
use PerlIDE::Results;
use PerlIDE::Survey;

use Carp;
use Mojo::SQLite;
use Mojolicious::Lite;
use Time::Piece;
use Cpanel::JSON::XS;

my $sql = Mojo::SQLite->new('sqlite:perl-ide-poll.db');
my $db  = $sql->db;

push @{app->renderer->paths}, ("$Bin/../templates");
push @{app->static->paths}, ("$Bin/../public");
PerlIDE::Migrate::migrate($sql, app->log);

my $secret = $ENV{PERL_IDE_SECRET};
Carp::croak("SECRET NOT SET") unless $secret;
app->secrets([$secret]);

sub _is_poll_active {
  my $now = localtime;
  my $mon = $now->mon;
  my $poll_active = $mon >= 10 && $mon <= 11;
  return $poll_active;
}

get '/' => sub {
  my ($c) = @_;

  my $now = localtime;
  my $mon = $now->mon;
  my $poll_active = $mon >= 10 && $mon <= 12;
  my $year = $now->year;

  if (!$poll_active) {
    $c->flash(message => 'The poll is currently disabled until October, where it will resume again. Here are the results from last year.');
    return $c->redirect_to('/results/' . $year - 1);
  }

  if ($c->session->{"$year"}) {
    return $c->redirect_to('/success');
  }

  my $total_submissions = PerlIDE::Results::get_total_submissions_for_year($db, $year);
  my $survey = PerlIDE::Survey::years($year);
  my $ides   = $db->query('SELECT id FROM ides ORDER BY id')->hashes->to_array;
  return $c->render(
    template => 'poll',
    year => $year,
    total_submissions => $total_submissions,
    survey => $survey,
    ides => $ides
   );
};

post '/' => sub {
  my ($c) = @_;

  my $now = localtime;
  my $year = $now->year;

  if ($c->session->{"$year"}) {
    return $c->redirect_to('/success');
  }

  if (!_is_poll_active) {
    $c->flash(message => 'The poll is currently disabled until October.');
    return $c->redirect_to('/');
  }

  my $primary_ide = $c->param('primary_ide');
  my $secondary_ide = $c->param('secondary_ide');

  if (!$primary_ide) {
    $c->flash(error => 'Both primary IDE selection is required.');
    return $c->redirect_to('/');
  }

  my $primary_exists = $db->query('SELECT COUNT(*) as count FROM ides WHERE id = ?', $primary_ide)->hash;

  if (!$primary_exists->{count}) {
    $c->flash(error => 'Invalid IDE selection.');
    return $c->redirect_to('/');
  }

  if ($primary_ide eq $secondary_ide) {
    $secondary_ide = undef;
  }

  my $survey = PerlIDE::Survey::years($year);
  my %survey_data;

  for my $field_key (keys %$survey) {
    next if $field_key eq 'theme';

    my $field = $survey->{$field_key};
    my $value = $c->param($field_key);

    if ($field->{depends_on}) {
      my $parent_value = $c->param($field->{depends_on});
      if (!$parent_value) {
        next;
      }
    }

    if (defined $value && $value ne '') {
      if ($field->{input_type} eq 'checkbox') {
        $survey_data{$field_key} = $value eq '1' ? 1 : 0;
      } else {
        $survey_data{$field_key} = $value;
      }
    }
  }

  my $data_json = encode_json(\%survey_data);

  eval {
    $db->query(
      'INSERT INTO submissions (year, primary_ide, secondary_ide, data) VALUES (?, ?, ?, ?)',
      $year, $primary_ide, $secondary_ide || undef, $data_json
     );
  };

  if ($@) {
    app->log->error("Database error: $@");
    $c->flash(error => 'An error occurred while saving your submission. Please try again.');
    return $c->redirect_to('/');
  }

  $c->session->{"$year"} = 1;

  return $c->redirect_to('/success');
};

get '/results/:year' => sub {
  my ($c) = @_;
  my $year = $c->param('year');
  my $now = localtime;
  my $curr_year   = $now->year;

  if ($year !~ /20[2-9][0-9]/xm) {
    return $c->render(text => 'invalid year', status => 400);
  }

  my $survey = PerlIDE::Survey::years($year);

  if (!$survey) {
    return $c->render(text => 'invalid year', status => 400);
  }

  if ($year == $curr_year && _is_poll_active) {
    $c->flash(message => q[The poll is still running, please submit a response if you haven't done so already.]);
    return $c->redirect_to('/');
  }

  my $results = PerlIDE::Results::get_results_for_year($db, $year);

  return $c->render(
    template => 'results',
    year => $year,
    total_submissions => PerlIDE::Results::get_total_submissions_for_year($db, $year),
    survey => $survey,
    %{$results}
   );
};

get '/success' => sub {
  my ($c) = @_;

  my $year = localtime->year;
  return $c->render(
    template => 'success',
    year => $year
  );
};

get '/results' => sub {
  my ($c) = @_;

  my $year = localtime->year;
  my %surveys = PerlIDE::Survey::years;
  return $c->render(
    template => 'results_index',
    surveys => \%surveys,
    current_year_is_active => _is_poll_active(),
    year => $year
  );
};

app->start;
