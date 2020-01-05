#! usr/local/bin/perl
use strict;
use warnings;
use diagnostics;


# Amer Haj Ahmad
# CMSC 416
# Eliza Assignment
# ID: V00897230
# 2/5/2019


# so Eliza is a software program that simulates a psychiatrist, performing a psychotherapy that is ego-centered, as the patient
# speaks about what troubles him/her or his/her problems that he/she is facing, and Eliza asks questions about those a problem so he/she can express
# more, in other words, Eliza is not really talkative but more of a someone who listens, (she makes a great listener).
# to properly use this software you have to answer with short meaningful sentences, although answering with long and hard sentences
# will sometimes make sense to Eliza.

#an example of a conversation with Eliza.
#[Eliza] Hi, I'm Eliza the psychotherapist. What is your name?
#[User] Hey it's Amer
#[Eliza] Hey Amer, how are you feeling today?
#[Amer] I'm not good
#[Eliza] Why are you not good?
#[Amer] I killed someone
#[Eliza] why did you kill  someone?
#[Amer] I don't know
#[Eliza] so anything you like to add?
#[Amer] I feel guilty
#[Eliza] do you usually feel like ' guilty' ?
#[Amer] No
#[Eliza] No? tell me more..
#[Amer] I do not think I am a killer
#[Amer] I do not!!
#[Eliza] what do you think about your life?
#[Amer] what do you mean
#[Eliza] me? it's about you not me, tell me what do you mean ?
#[Amer] ok?
#[Eliza] alright alright alright (*matthew mcconaughey voice*)
#[Amer] hahaha that was funny
#[Eliza] glad that I made you laugh..
#[Amer] goodbye Eliza
#[Eliza] have a nice day! see you next time in the next session :")


#the algorithm that I used to program Eliza is first trying the match the user input with some familiar patterns,
#if that did not work then, the program will try to check if the person is asking a question so it can get back to the main point
#which is talking about the patient him/herself, then it tries to spot verbs or nouns or adjs and ask about them.
#if all what was mentioned before did not work out, then it will ask a random question out of a pool of pre-written questions.
#additionally, I will randomly ask from time to time in the conversation about some statements the user inputted before,
#just to make the software more personalized. 


#declaring arrays that will be needed
my @verbs = (); #contains present verbs
my @pastverbs = (); #contains past verbs
my @v3 = (); #contains past participle verbs
my @patient = (); #contains what patient has asked so far
my @responses = (); #contains some random responses that the program will output in case of gibberish words.
my @nouns = (); #contains some familiar nouns to spot
my @adj = (); #contains some familiar adjectives
my @wh = (); #contains WH questions
my $name; #contains the name of the user
my $input; #contains the input of the user
my $quit=0; #boolean var to decide whether to quit the program or not.

# a map with familiar abbreviations.
my %abb = (
	"it's" => "it is",
	"they're" => "they are",
	"they've" => "they have",
	"i've" => "I have",
	"you've" => "they have",
	"you're" => "you are",
	"i'm" => "I am",
	"he's" => "he is",
	"she's" => "she is",
	"i'll" => "I will",
	"he'll" => "he will",
	"you'll" => "you will",
	"she'll" => "she will",
	"don't" => "do not",
	"doesn't" => "does not",
	"haven't" => "have not",
	"hasn't" => "has not",
	"weren't" => "were not",
	"wasn't" => "was not",
	"won't" => "will not",
	"didn't" => "did not",
	"shouldn't" => "should not",
	"wouldn't" => "would not",
	"couldn't" => "could not"
);


# a parser for the input of the user
sub parse
{
	#first I will check for any abbreviation in the user response
	#so I can be able to convert the user's statement in a correct
	#grammatical way.
	# just a normal parser function to smoothly deal with the user's input
	# chomping & fixing abbreviations
	my ($input) = @_;
	chomp($input);
	$input =~s/[.!,;]/ /;
	foreach my $abbreviation (keys %abb)
	{
		if ( $input =~m/(.*)?$abbreviation(.*)?/i )
		{
			$input = $1.$abb{$abbreviation}.$2;
		}
	}
	return $input;
}


# a subroutine to initialize the files that the program is going to use in order to fill the arrays that were declared previously.
sub init_files
{
	my $f_wh = 'whq.txt';
	my $f_verbs = 'verbs.txt';
	my $f_res = 'random_responses.txt';
	my $f_adj = 'adj.txt';
	my $f_nouns = 'nouns.txt';
	open (F_WHQ, "<", $f_wh) or die "whq.txt File writer error: $!";
	open (F_VERBS, "<", $f_verbs) or die "verbs.txt File writer error: $!";
	open (F_RESPONSES, "<", $f_res) or die "random_responses.txt File writer error: $!";
	open (F_ADJ, "<", $f_verbs) or die "adj.txt File writer error: $!";
	open (F_NOUNS, "<", $f_nouns) or die "nouns.txt File writer error: $!";
	
	while(<F_WHQ>)
	{
		chomp;
		push(@wh, split '\n');
	}
	
	while(<F_VERBS>)
	{
		chomp;
		my @temp = ();
		push(@temp, split '\n');
		foreach my $tmp (@temp)
		{
			my @array = split(/\s+/ , $tmp);
			push( @pastverbs , $array[1] );
			push( @verbs , $array[0] );
			push( @v3 , $array[2] );
			#print( "$array[0] $array[1] $array[2]\n" );
		}
	}
	while(<F_RESPONSES>)
	{
		chomp;
		push(@responses, split '\n');
	}
	while(<F_ADJ>)
	{
		chomp;
		push(@adj, split '\n');
	}
	while(<F_NOUNS>)
	{
		chomp;
		push(@nouns, split '\n');
	}
	close(F_WHQ);
	close(F_VERBS);
	close(F_RESPONSES);
	close(F_ADJ);
	close(F_NOUNS);
	
}

# a subroutine to parse the output.
sub output
{
	my ($name, $output , $other) = @_;
	print( "[$name] $output\n[$other] " );
}

# a subroutine for intro to extract the name and the feeling of the patient
sub intro
{
	print ("[Eliza] Hi, I'm Eliza the psychotherapist. What is your name?\n[User] ");
	$input = <STDIN>;
	$name = parse($input);
	my @line = split /\s+/, $name;

	$name =~s/^(.*)\s(is|am|called)*\s([A-Za-z]+)/$3/;
	print ("[Eliza] Hey $name, how are you feeling today?\n[$name] ");

	$input = <>;
	$input = parse($input);
	#push(@patient, $input);
	my @tmp = split( /\s+/ , $input );
	#print join("\n " , @tmp );
	if ( $#tmp!=0 ){
	$input =~s/(I am)/Why are you/i;
	$input =~s/(I feel)/Why are you/i;
	}
	else
	{
	$input = "why are you feeling $input";
	}
	output( "Eliza" , $input."?" , $name );
}


#this subroutine has some common patterns, so that if the sentence typed by the user matched any of them
#the program will choose a reply randomly out of 2 or 4 possible replies.
#the idea behind choosing a random response so it does not feel repetitive.
sub go
{
	my $istrue = 0;
	my ($input) = @_;
	my $rand = int(rand 4);
	#print("$input****\n");
	
	if ( $input =~m/(goodbye|bye|see you|have a nice day|quit|adios)/i )
	{
		output("Eliza", "have a nice day! see you next time in the next session :\") " , $name);
		$quit=1;
		return $istrue=1;
	}
	elsif ( $input =~m/(lol|(haha)+)/i )
	{
		$istrue=1;
		my $toss = int(rand 2);
		if ( $toss==0 )
		{
			output("Eliza", "laughing is good for your health.. go for it! XD" , $name);
		}
		else
		{
			output("Eliza", "glad that I made you laugh.." , $name);
		}
		
	}
	elsif ( $input =~m/(thanks|thank you|thx)/ )
	{
		my $toss = int(rand 2);
		if ( $toss==0 )
		{
			output("Eliza", "no need to thank me, my pleasure.." , $name);
		}
		else
		{
			output("Eliza", "anytime $name!" , $name);
		}
	}
	elsif ( $input =~m/(.*)?\b(I)\b(.*)?\b(you)\b(.*)?/i )
	{
		$istrue=1;
		if ($rand==0)
		{
			output("Eliza", "why me though?" , $name);
		}
		elsif ( $rand==1 )
		{
			output("Eliza", "how come? I'm your psychiatrist" , $name);
		}
		elsif ( $rand==2 )
		{
			output("Eliza", "do you really $2 me?" , $name);
		}
		elsif( $rand==3 )
		{
			output("Eliza", "$2??" , $name);
		}
	}
	elsif ( $input =~m/(\w+\s)(me)\b/i  )
	{
		$istrue=1;
		if ($rand==0)
		{
			output("Eliza", "life is unfair,.. take it easy on yourself" , $name);
		}
		elsif ( $rand==1 )
		{
			output("Eliza", "what heppened then?" , $name);
		}
		elsif ( $rand==2 )
		{
			output("Eliza", "things gonna get better.. tell me more" , $name);
		}
		elsif( $rand==3 )
		{
			output("Eliza", "but why $1 you though?" , $name);
		}
	} 
	elsif ( $input =~m/((.)*)?I\s+(am|feel)((.)*)?/i )
	{
		$istrue=1;
		my $toss = int(rand 2);
		if ( $toss==0 )
		{
			output("Eliza", "why do you think that you are $4?" , $name);
		}
		else
		{
			output("Eliza", "do you usually feel like \'$4\' ?" , $name);
		}
	}
	elsif( $input =~m/(yes|no)\b(.*)?/i )
	{
		$istrue=1;
		my $toss = int(rand 2);
		if ( $toss==0 )
		{
			output("Eliza", "$1.. things started make sense now.. speak up your mind.." , $name);
		}
		else
		{
			output("Eliza", "$1? tell me more.." , $name);
		}
	}
	elsif ($input =~m/^ok(.*)?/i  )
	{
		$istrue=1;
		my $toss = int(rand 2);
		if ( $toss==0 )
		{
			randomize();
		}
		else
		{
			output("Eliza", "alright alright alright (\*matthew mcconaughey voice\*)" , $name);
		}
	}
	return $istrue;
}

#this subroutine is to handle when the patient asks a question.
#it has some familiar patterns to match the user's input, additionally the main function for this subroutine
#is to get back to psychotherapy, which is letting the user speak up their minds.
sub patient_asking
{
	my ($input) = @_;
	my $istrue=0;
	my $rand = int(rand 4);
		if ( $input =~m/which(.*)?\b(\w+)\sor(.*)?/i )
		{
			$istrue = 1;
			if ($rand==0)
			{
				output("Eliza", "what do you think of $2" , $name);
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "how about both?" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "did you consider other options?" , $name);
			}
			elsif( $rand==3 )
			{
				output("Eliza", "$2 or $3, remember freddie mercury, nothing really matters :)" , $name);	
			}
			return $istrue;
		}
	
	foreach my $tmp (@wh)
	{
		if ( $input =~m/$tmp\s+(did|do|does)(\s+)?(not)?\s+?(he|she|it|I|they|we|you)?\s+?(\w+)(.*)?/i )
		{
			$istrue=1;
			if ( lc($4) eq "you" )
			{
				output("Eliza" , "me? it's about you not me, tell me $tmp $1 you $5 $6?", $name );	
			}
			elsif ( lc($4) eq "i" )
			{
				output("Eliza" , "don't stress it out $name.. it will be alright", $name );	
			}
			else
			{
				output("Eliza" , "what about $6?", $name );	
			}
		}
		elsif ( $input =~m/$tmp\s+(is|are|was|were)\s+?(.*)?/i )
		{
			output("Eliza" , "stop these existential questions, and think more simple.. ", $name );	
			return $istrue;
		}
		elsif ( $input =~m/$tmp(.*)?/ )
		{
			$istrue = 1;
			my $rand = int(rand 4);
			if ($rand==0)
			{
				output("Eliza", "do not overthink it with these questions.." , $name);
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "what do you mean by $tmp?" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "why do you want to know $1?" , $name);
			}
			else
			{
				output("Eliza" , "$1? really?" , $name );
			}
			return $istrue;
		}
	}
	return $istrue;
}

#this subroutine is to spot verbs (past, present, past participle), and some familiar nouns and adjs
#then it throws some random reply from a pool of 4 replies.
sub spot
{
	my ($input) = @_;
	my $istrue=0;
	for ( my $i=0 ; $i<$#pastverbs ; $i++ )
	{
		my $tmp = $verbs[$i];
		if ( $input =~m/(.*)?$tmp\b(.*)?/i )
		{
			$istrue=1;
			my $rand = int(rand 4);
			if ($rand==0)
			{
				output("Eliza" , "why do you $tmp that?" , $name );
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "tell more about the $2" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "how did you $pastverbs[$i] that" , $name);
			}
			elsif( $rand==3 )
			{
				output("Eliza", "when do you usually $tmp $2" , $name);
			}
			return $istrue;
		}
	}
	for ( my $i=0 ; $i<$#pastverbs ; $i++ )
	{
		my $tmp = $pastverbs[$i];
		#print( "$tmp\n" );
		if ( $input =~m/(.*)?$tmp(.*)?/i )
		{
			$istrue=1;
			my $rand = int(rand 4);
			if ($rand==0)
			{
				output("Eliza" , "why did you $verbs[$i] $2?" , $name );
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "have you ever $v3[$i] $2 before" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "how did you $verbs[$i] $2" , $name);
			}
			elsif( $rand==3 )
			{
				output("Eliza", "when did you $verbs[$i] $2" , $name);
			}
			return $istrue;
		}
	}
	
	for ( my $i=0 ; $i<$#v3 ; $i++ )
	{
		my $tmp = $v3[$i];
		#print( "$tmp\n" );
		if ( $input =~m/(.*)?$tmp(.*)?/i )
		{
			$istrue=1;
			my $rand = int(rand 4);
			if ($rand==0)
			{
				output("Eliza" , "why did you $verbs[$i] $2?" , $name );
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "tell me more about $2" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "how did you $verbs[$i] $2" , $name);
			}
			elsif( $rand==3 )
			{
				output("Eliza", "when did you $verbs[$i] $2" , $name);
			}
			return $istrue;
		}
	}
	
	
	
	foreach my $tmp (@nouns)
	{
		my $rand = int(rand 4);
		if ( $input =~m/(.*)?$tmp(.*)?/i )
		{
			$istrue=1;
			if ($rand==0)
			{
				output("Eliza" , "$tmp? really?" , $name );
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "tell more about the $tmp" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "so what about $tmp, what that makes you feel?" , $name);
			}
			elsif( $rand==3 )
			{
				output("Eliza", "your $tmp?? tell me more.." , $name);	
			}
			return $istrue;
		}
	}
	foreach my $tmp (@adj)
	{
		my $rand = int(rand 4);
		if ( $input =~m/(.*)?$tmp(.*)?/i )
		{
			$istrue=1;
			if ($rand==0)
			{
				output("Eliza" , "what made you feel $tmp" , $name );
			}
			elsif ( $rand==1 )
			{
				output("Eliza", "any other feelings than $tmp?" , $name);
			}
			elsif ( $rand==2 )
			{
				output("Eliza", "what triggered being $tmp, the place? the time?" , $name);
			}
			elsif( $rand==3 )
			{
				output("Eliza", "$tmp? tell me more about being $tmp.." , $name);	
			}
			return $istrue;
		}
	}
	return $istrue;
}

#this subroutine is to throw a random reply from a pool of pre-writtnen replies in case the user inputted some gibberish words.
sub randomize
{
	output( "Eliza" , $responses[int(rand $#responses)] , $name );
}


#this subroutine is to refer back to some reply that the user inputted before.
sub relate
{
	my $toss = int(rand 2);
	if ( $toss==0 ){
	output( "Eliza" , "you previously said that \"$patient[int(rand $#patient)]\", can you elaborate more?" , $name );
	}
	else
	{
	output( "Eliza" , "when did you say \"$patient[int(rand $#patient)]\" before, what did you really mean? " , $name );
	}
}


#program starts from here !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

init_files(); # calling the subroutine to initialize the files
my $count=0; # just a counter for how many lines the patient spoke so far.
intro(); # intro to get the name and feeling of the patient

#infinite loop
while (1)
{
	my $rand = int(rand(11));
	my $input = <STDIN>;
	$input = parse($input);
	
	#in case the input matched a question in the subroutine patient_asking then just continue in the loop.
	if ( (patient_asking($input))==1 ){ next; }
	
	#in case the input matched a pattern in the subroutine go then just continue in the loop.
	if ( go($input)==1 ){ if ($quit==1){last;} next; }
	
	
	#in case the input matched a pattern in the subroutine spot then just continue in the loop.
	if ( spot($input)==1 ) { next; }
	
	#in a chance of 1/11, I will ask the user about some reply he/she made before.
	if ( $rand == 7 && $count>3 )
	{
		relate();
		next;
	}
	
	#in case none of the subroutines above matched with the user input, I will ask a random question to the user 
	randomize();
	
	#pushing the user input in the patient array.
	push( @patient , $input );
	
	$count++;
	
}