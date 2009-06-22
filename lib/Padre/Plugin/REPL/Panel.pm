package Padre::Plugin::REPL::Panel;

use strict;
use warnings;

our $VERSION = '0.01';

use Padre::Wx;
use Padre::Util qw/_T/;
use base 'Wx::Panel';

sub new {
	my $class      = shift;
	my $main       = shift;
	my $self       = $class->SUPER::new( Padre::Current->main->bottom );
	my $box        = Wx::BoxSizer->new(Wx::wxVERTICAL);
	my $bottom_box = Wx::BoxSizer->new(Wx::wxHORIZONTAL);
	my $output     = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize,
		Wx::wxTE_READONLY
			| Wx::wxTE_MULTILINE
			| Wx::wxTE_DONTWRAP
			| Wx::wxNO_FULL_REPAINT_ON_RESIZE,
	);
	$box->Add($output);
	my $input = Wx::TextCtrl->new(
		$self,
		-1,
		"",
		Wx::wxDefaultPosition,
		Wx::wxDefaultSize
	);
	my $button = Wx::Button->new( $self, -1, _T("Evaluate") );
	Wx::Event::EVT_BUTTON( $self, $button, \&Padre::Plugin::REPL::evaluate );
	$bottom_box->Add($input);
	$bottom_box->Add($button);
	$box->Add($bottom_box);
	$self->SetSizer($box);
	Padre::Current->main->bottom->show($self);
	return ( $input, $output );
}

sub gettext_label {
	return "REPL";
}

1;
