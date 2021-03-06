package Games::Mythic;

use strict;
use warnings;
use feature 'state';
use Moo;

has chaos_level => (
    is      => 'rw',
    default => 5,
    coerce  => sub {
        return 9 if $_[0] > 9;
        return 1 if $_[0] < 1;
        return $_[0];
    },
);

has npcs    => ( is => 'rw', default => sub { {} } );
has threads => ( is => 'rw', default => sub { {} } );

BEGIN {
    no strict 'refs';

    foreach my $thing (qw(npc thread)) {
        my $things = "${thing}s";
        *{"add_$thing"} = sub {
            my ( $self, $arg ) = @_;

            $self->$things->{$arg} = 1;
        };
        *{"remove_$thing"} = sub {
            my ( $self, $arg ) = @_;
            delete $self->$things->{$arg};
        };
        *{"random_$thing"} = sub {
            my ($self) = @_;
            return $self->random_element( [ keys %{ $self->$things } ] );
        };
    }
}

my $fate_chart = [
    [ 50,  25,  10,  5,   5,   0,   0,   -20, -20, -40, -40, -55, -65 ],
    [ 75,  50,  25,  15,  10,  5,   5,   0,   0,   -20, -20, -35, -45 ],
    [ 90,  75,  50,  35,  25,  15,  10,  5,   5,   0,   0,   -15, -25 ],
    [ 95,  85,  65,  50,  45,  25,  15,  10,  5,   5,   5,   -5,  -15 ],
    [ 100, 90,  75,  55,  50,  35,  20,  15,  10,  5,   5,   0,   -10 ],
    [ 105, 95,  85,  75,  65,  50,  35,  25,  15,  10,  10,  5,   -5 ],
    [ 110, 95,  90,  85,  80,  65,  50,  45,  25,  20,  15,  5,   0 ],
    [ 115, 100, 95,  90,  85,  75,  55,  50,  35,  25,  20,  10,  5 ],
    [ 120, 105, 95,  95,  90,  85,  75,  65,  50,  45,  35,  15,  5 ],
    [ 125, 115, 100, 95,  95,  90,  80,  75,  55,  50,  45,  20,  10 ],
    [ 130, 125, 110, 95,  95,  90,  85,  80,  65,  55,  50,  25,  10 ],
    [ 150, 145, 130, 100, 100, 95,  95,  90,  85,  80,  75,  50,  25 ],
    [ 170, 165, 150, 120, 120, 100, 100, 95,  95,  90,  90,  75,  50 ]
];

sub ranks {
    return [
        qw(miniscule2 miniscule weak low below-average average
          above-average high exceptional incredible awesome superhuman
          superhuman2 )
    ];
}

my $actions = [
    "Attainment",  "Starting",      "Neglect",     "Fight",
    "Recruit",     "Triumph",       "Violate",     "Oppose",
    "Malice",      "Communicate",   "Persecute",   "Increase",
    "Decrease",    "Abandon",       "Gratify",     "Inquire",
    "Antagonise",  "Move",          "Waste",       "Truce",
    "Release",     "Befriend",      "Judge",       "Desert",
    "Dominate",    "Procrastinate", "Praise",      "Separate",
    "Take",        "Break",         "Heal",        "Delay",
    "Stop",        "Lie",           "Return",      "Imitate",
    "Struggle",    "Inform",        "Bestow",      "Postpone",
    "Expose",      "Haggle",        "Imprison",    "Release",
    "Celebrate",   "Develop",       "Travel",      "Block",
    "Harm",        "Debase",        "Overindulge", "Adjourn",
    "Adversity",   "Kill",          "Disrupt",     "Usurp",
    "Create",      "Betray",        "Agree",       "Abuse",
    "Oppress",     "Inspect",       "Ambush",      "Spy",
    "Attach",      "Carry",         "Open",        "Carelessness",
    "Ruin",        "Extravagance",  "Trick",       "Arrive",
    "Propose",     "Divide",        "Refuse",      "Mistrust",
    "Deceive",     "Cruelty",       "Intolerance", "Trust",
    "Excitement",  "Activity",      "Assist",      "Care",
    "Negligence",  "Passion",       "Work hard",   "Control",
    "Attract",     "Failure",       "Pursue",      "Vengeance",
    "Proceedings", "Dispute",       "Punish",      "Guide",
    "Transform",   "Overthrow",     "Oppress",     "Change"
];

my $subjects = [
    "Goals",            "Dreams",
    "Environment",      "Outside",
    "Inside",           "Realities",
    "Allies",           "Enemies",
    "Evil",             "Good",
    "Emotions",         "Opposition",
    "War",              "Peace",
    "The innocent",     "Love",
    "The spiritual",    "The intellectual",
    "New ideas",        "Joy",
    "Messages",         "Energy",
    "Balance",          "Tension",
    "Friendship",       "The physical",
    "A project",        "Pleasures",
    "Pain",             "Possessions",
    "Benefits",         "Plans",
    "Lies",             "Expectations",
    "Legal matters",    "Bureaucracy",
    "Business",         "A plan",
    "News",             "Exterior factors",
    "Advice",           "A plot",
    "Competition",      "Prison",
    "Illness",          "Food",
    "Attention",        "Success",
    "Failure",          "Travel",
    "Jealously",        "Dispute",
    "Home",             "Investment",
    "Suffering",        "Wishes",
    "Tactics",          "Stalemate",
    "Randomness",       "Misfortune",
    "Death",            "Disruption",
    "Power",            "A burden",
    "Intrigues",        "Fears",
    "Ambush",           "Rumour",
    "Wounds",           "Extravagance",
    "A representative", "Adversities",
    "Opulance",         "Liberty",
    "Military",         "The mundane",
    "Trials",           "Masses",
    "Vehicle",          "Art",
    "Victory",          "Dispute",
    "Riches",           "Status quo",
    "Technology",       "Hope",
    "Magic",            "Illusions",
    "Portals",          "Danger",
    "Weapons",          "Animals",
    "Weather",          "Elements",
    "Nature",           "The public",
    "Leadership",       "Fame",
    "Anger",            "Information"
];

sub rank_to_index {
    my ( $self, $rank ) = @_;
    state %ranks;
    if ( not %ranks ) {
        my @ranks = @{ $self->ranks };
        while ( my ( $index, $rank ) = each @ranks ) {
            $ranks{$rank} = $index;
        }
    }
    return $ranks{$rank};
}

sub d100 {
    my ($self) = @_;
    return ( int rand 99 ) + 1;
}

sub ask {
    my ( $self, $acting, $difficulty, $roll ) = @_;
    $difficulty ||= $self->chaos_level_to_rank;
    my $odds = $self->get_odds( $acting, $difficulty );
    $roll = defined $roll ? $roll : $self->d100;
    my ( $answer, $random_event );
    if ( $roll <= $odds->[0] ) {
        $answer = 'exceptional-no';
    }
    elsif ( $roll < $odds->[1] ) {
        $answer = 'no';
    }
    elsif ( $roll < $odds->[2] ) {
        $answer = 'yes';
    }
    elsif ( $roll >= $odds->[2] ) {
        $answer = 'exceptional-yes';
    }
    if ( $roll % 11 == 0 ) {
        $random_event = $self->random_event();
    }
    return {
        answer => $answer,
        roll   => $roll,
        event  => $random_event,
    };
}

sub get_odds {
    my ( $self, $acting, $difficulty ) = @_;
    my ( $row, $column ) = (
        $self->rank_to_index( $self->get_base_rank($acting) ),
        $self->rank_to_index( $self->get_base_rank($difficulty) ),
    );
    my $odds =
      $fate_chart->[$row]->[$column] +
      $self->get_extreme_modifier($acting) -
      $self->get_extreme_modifier($difficulty);
    my $lower = $odds / 5;
    my $upper = 101 - ( 100 - $odds ) / 5;
    return [ $lower, $odds, $upper ];
}

sub chaos_level_to_rank {
    my ($self) = @_;
    if ( $self->chaos_level < 2 )  { return 'high' }
    if ( $self->chaos_level < 4 )  { return 'above-average' }
    if ( $self->chaos_level < 7 )  { return 'average' }
    if ( $self->chaos_level < 9 )  { return 'below-average' }
    if ( $self->chaos_level < 11 ) { return 'low' }
    return;
}

sub get_base_rank {
    my ( $self, $rank ) = @_;
    if ( $rank =~ /superhuman(\d+)/ && $1 > 2 ) {
        return 'superhuman2';
    }
    elsif ( $rank =~ /miniscule(\d+)/ && $1 > 2 ) {
        return 'miniscule2';
    }
    else {
        return $rank;
    }
}

sub get_extreme_modifier {
    my ( $self, $rank ) = @_;
    if ( $rank =~ /superhuman(\d+)/ && $1 > 2 ) {
        return ( $1 - 2 ) * 20;
    }
    elsif ( $rank =~ /miniscule(\d+)/ && $1 > 2 ) {
        return ( $1 - 2 ) * -20;
    }
    else {
        return 0;
    }
}

sub ask_odds_question {
    my ( $self, $acting ) = @_;
    get_odds( $acting, $self->chaos_level_to_rank );
}

# focusArray[0] = new Array("5/Standard game.  Regular fate chart rules."  "1/7/Remote event"  "8/28/NPC action"  "29/35/Introduce a new NPC"  "36/45/Move towards a thread"  "46/52/Move away from a thread"  "53/55/Close a thread"  "56/67/PC negative"  "68/75/PC positive"  "76/83/Ambiguous event"  "84/92/NPC negative"  "93/100/NPC positive")

#  focusArray[1] = new Array("4/Horror: the game starts with the Chaos Factor set to 4.  Chaos can only increase not decrease.  When random events are generated results of 1 to 3 within the Chaos Factor are altered scenes.  Any higher numbers will be interrupts."  "1/10/Horror - PC"  "11/23/Horror - NPC"  "24/30/Remote Event"  "31/49/NPC action"  "50/52/Introduce an NPC"  "53/55/Move toward a thread"  "56/62/Move away from a thread"  "63/72/PC Negative"  "73/75/PC positive"  "76/82/Ambiguous event"  "83/97/NPC negative"  "98/100/NPC positive");

#  focusArray[2] = new Array("5/Action adventure: Double rolls on the Fate chart always result in a random event whether they fall within the Chaos Facotr range or not.  Chaos cannot fall below 5.  Any scene which would normally lower the Chaos below 5 leaves it unchanged."  "1/16/Action!"  "17/24/Remote event"  "25/44/NPC action"  "45/52/Introduce an NPC"  "53/56/Move toward a thread"  "57/64/Move away from a thread"  "65/76/PC negative"  "77/80/PC positive"  "81/84/Ambiguous event"  "85/96/NPC negative"  "97/100/NPC positive")

#  focusArray[3] = new Array("5/Mystery: the Chaos Factor cannot fall below 3.  Any scene which would normally lower the Chaos below 3 leaves it unchanged."  "1/8/Remote event"  "9/20/NPC action"  "21/32/Introduce an NPC"  "33/52/Move toward a thread"  "53/64/Move away from a thread"  "65/72/PC negative"  "73/80/PC positive"  "81/88/Ambiguous event"  "89/96/NPC negative"  "97/100/NPC positive")

#  focusArray[4] = new Array("5/Social game: this game uses standard Chaos rules."  "1/12/Drop a bomb!"  "13/24/Remote event"  "25/36/NPC action"  "37/44/Introduce an NPC"  "45/56/Move toward a thread"  "57/60/Move away from a thread"  "61/64/Close a thread"  "65/72/PC negative"  "73/80/PC positive"  "81/92/Ambiguous event"  "93/96/NPC negative"  "7/100/NPC positive")

#  focusArray[5] = new Array("5/Personal game: this game uses standard Chaos rules."  "1/7/Remote event"  "8/24/NPC action"  "25/28/PC NPC action"  "29/35/Introduce an NPC"  "36/42/Move toward a thread"  "43/45/Move toward a PC thread"  "46/50/Move away from a thread"  "51/52/Move away from a PC thread"  "53/54/Close thread"  "55/55/Close PC thread"  "56/67/PC negative"  "68/75/PC positive"  "76/83/Ambiguous event"  "84/90/NPC negative"  "91/92/PC NPC negative"  "93/99/NPC positive"  "100/100/PC NPC positive")

#  focusArray[6] = new Array("5/Epic game: the Chaos Factor cannot fall below 3.  Any scene which would normally lower the Chaos below 3 leaves it unchanged."  "1/12/Thread escalates"  "13/16/Remote event"  "17/30/NPC action"  "31/42/Introduce an NPC"  "43/46/Move toward a thread"  "47/58/Move away from a thread"  "59/72/PC negative"  "73/80/PC positive"  "81/84/Ambiguous event"  "85/92/NPC negative"  "93/100/NPC positive")

sub random_element {
    my ( $self, $array ) = @_;
    return $array->[ rand @$array ];
}

my @event_focus = (
    [ 7   => "Remote event" ],
    [ 28  => "NPC action" => 'random_npc' ],
    [ 35  => "Introduce a new NPC" ],
    [ 45  => "Move towards a thread" => 'random_thread' ],
    [ 52  => "Move away from a thread" => 'random_thread' ],
    [ 55  => "Close a thread" => 'random_thread' ],
    [ 67  => "PC negative" ],
    [ 75  => "PC positive" ],
    [ 83  => "Ambiguous event" ],
    [ 92  => "NPC negative" => 'random_npc' ],
    [ 100 => "NPC positive" => 'random_npc' ],
);

sub event_focus {
    my $self = shift;
    my $roll = d100();
    for my $focus (@event_focus) {
        if ( $roll <= $focus->[0] ) {
            my $sub = $focus->[2];
            return {
                focus => $focus->[1],
                what  => $sub ? $self->$sub : undef
            };
        }
    }
    return;
}

sub random_event {
    my $self        = shift;
    my $event_focus = $self->event_focus;
    my $focus       = $event_focus->{focus};
    my $what        = $event_focus->{what};
    $focus
      . ( defined $what ? " ($what) " : '' ) . ' - '
      . $self->random_element($actions) . "/"
      . $self->random_element($subjects);
}

sub increase_chaos {
    my $self = shift;
    return $self->chaos_level( $self->chaos_level + 1 );
}

sub decrease_chaos {
    my $self = shift;
    return $self->chaos_level( $self->chaos_level - 1 );
}

1;
