package Padre::Plugin::REPL;

use warnings;
use strict;

#sub BEGIN {
#	$ENV{PERL_RL} = "Stub";
#}

use base 'Padre::Plugin';
use Padre::Wx;
use Padre::Util qw/_T/;
use Devel::REPL;
use Capture::Tiny qw/capture_merged/;
use Devel::REPL::Script;

our $VERSION = '0.01';

our $repl;

sub padre_interfaces {
	return 'Padre::Plugin' => '0.26';
}

sub menu_plugins_simple {
	return "REPL" => [
		( _T('Evaluate something') . "\tCtrl+e" ) => \&dialog,
	];
}

sub plugin_enable {
	_init_repl();
}

sub dialog {
	my $code = Wx::GetTextFromUser("What do you want to evaluate?");
	my $res  = _eval_repl($code);
	Padre::Current->main->output->AppendText("# $code\n$res\n");
	Padre::Current->main->show_output(1);
}

sub _init_repl {
	return if ( defined($repl) );
	my $temp = Devel::REPL::Script->new();
	$repl = $temp->_repl();
	$temp->load_profile( $temp->profile );
	$temp->load_rcfile( $temp->rcfile );
	$repl->out_fh( \*STDOUT );
}

sub _eval_repl {
	my $code = shift;
	my $res  = capture_merged {
		$repl->print( $repl->formatted_eval($code) );
	};
	return $res;
}

=head1 NAME

Padre::Plugin::REPL - read-evaluate-print plugin for Padre

=head1 SYNOPSIS

This plugin will ask you for some code, evaluate it, and show you its output and what it returned.

Since this uses L<Devel::REPL>, most of its plugins can be used in the same way as usual.

=head1 AUTHOR

Ryan Niebur, C<< <ryanryan52 at gmail.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Ryan Niebur, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
