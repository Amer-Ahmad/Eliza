# Eliza
This project emulates a Rogerian psychotherapist, simulating the early ELIZA program that was done in the mid 60s.

So Eliza is a software program that simulates a psychiatrist, performing a psychotherapy that is ego-centered, as the patient
speaks about what troubles him/her or his/her problems that he/she is facing, and Eliza asks questions about those a problem so he/she can express
more, in other words, Eliza is not really talkative but more of a someone who listens, (she makes a great listener).
to properly use this software you have to answer with short meaningful sentences, although answering with long and hard sentences
will sometimes make sense to Eliza.

an example of a conversation with Eliza.
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


the algorithm that I used to program Eliza is first trying the match the user input with some familiar patterns,
if that did not work then, the program will try to check if the person is asking a question so it can get back to the main point
which is talking about the patient him/herself, then it tries to spot verbs or nouns or adjs and ask about them.
if all what was mentioned before did not work out, then it will ask a random question out of a pool of pre-written questions.
additionally, I will randomly ask from time to time in the conversation about some statements the user inputted before,
just to make the software more personalized.
