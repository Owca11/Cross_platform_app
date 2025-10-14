import 'package:flutter/material.dart';
import '../models/feeling.dart';
import '../models/calm_tip.dart';

List<Feeling> sampleFeelings = [
  Feeling(name: 'Happy', icon: Icons.sentiment_very_satisfied, prompt: 'I feel happy'),
  Feeling(name: 'Sad', icon: Icons.sentiment_dissatisfied, prompt: 'I feel sad'),
  Feeling(name: 'Angry', icon: Icons.sentiment_very_dissatisfied, prompt: 'I feel angry'),
  Feeling(name: 'Scared', icon: Icons.sentiment_neutral, prompt: 'I feel scared'),
  Feeling(name: 'Excited', icon: Icons.celebration, prompt: 'I feel excited'),
  Feeling(name: 'Tired', icon: Icons.bedtime, prompt: 'I feel tired'),
  Feeling(name: 'Frustrated', icon: Icons.error_outline, prompt: 'I feel frustrated'),
  Feeling(name: 'Anxious', icon: Icons.warning, prompt: 'I feel anxious'),
  Feeling(name: 'Calm', icon: Icons.spa, prompt: 'I feel calm'),
  Feeling(name: 'Overwhelmed', icon: Icons.blur_on, prompt: 'I feel overwhelmed'),
  Feeling(name: 'Lonely', icon: Icons.person_off, prompt: 'I feel lonely'),
  Feeling(name: 'Proud', icon: Icons.emoji_events, prompt: 'I feel proud'),
];

List<Need> sampleNeeds = [
  Need(name: 'Water', icon: Icons.local_drink, prompt: 'I need water'),
  Need(name: 'Food', icon: Icons.restaurant, prompt: 'I need food'),
  Need(name: 'Rest', icon: Icons.hotel, prompt: 'I need rest'),
  Need(name: 'Help', icon: Icons.help, prompt: 'I need help'),
  Need(name: 'Hug', icon: Icons.favorite, prompt: 'I need a hug'),
  Need(name: 'Quiet', icon: Icons.volume_off, prompt: 'I need quiet'),
  Need(name: 'Bathroom', icon: Icons.wc, prompt: 'I need to use the bathroom'),
  Need(name: 'Medicine', icon: Icons.medical_services, prompt: 'I need medicine'),
  Need(name: 'Comfort', icon: Icons.chair, prompt: 'I need comfort'),
  Need(name: 'Attention', icon: Icons.visibility, prompt: 'I need attention'),
  Need(name: 'Space', icon: Icons.space_bar, prompt: 'I need space'),
  Need(name: 'Talk', icon: Icons.chat, prompt: 'I need to talk'),
];

List<Thought> sampleThoughts = [
  Thought(name: 'Confused', icon: Icons.help_outline, prompt: 'I am confused'),
  Thought(name: 'Worried', icon: Icons.warning, prompt: 'I am worried'),
  Thought(name: 'Thinking', icon: Icons.lightbulb, prompt: 'I am thinking'),
  Thought(name: 'Remember', icon: Icons.memory, prompt: 'I remember'),
  Thought(name: 'Idea', icon: Icons.lightbulb_outline, prompt: 'I have an idea'),
  Thought(name: 'Question', icon: Icons.question_mark, prompt: 'I have a question'),
  Thought(name: 'Forget', icon: Icons.cancel, prompt: 'I forget'),
  Thought(name: 'Understand', icon: Icons.check_circle, prompt: 'I understand'),
  Thought(name: 'Dream', icon: Icons.cloud, prompt: 'I had a dream'),
  Thought(name: 'Plan', icon: Icons.schedule, prompt: 'I have a plan'),
  Thought(name: 'Wonder', icon: Icons.star, prompt: 'I wonder'),
  Thought(name: 'Know', icon: Icons.info, prompt: 'I know'),
];

List<CalmTip> sampleCalmTips = [
  CalmTip(
    title: '5-4-3-2-1 Technique',
    description: 'Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste.',
  ),
  CalmTip(
    title: 'Deep Breathing',
    description: 'Breathe in slowly for 4 counts, hold for 4, exhale for 4. Repeat.',
  ),
  CalmTip(
    title: 'Grounding',
    description: 'Focus on your feet on the ground, feel the support beneath you.',
  ),
  CalmTip(
    title: 'Positive Affirmation',
    description: 'Repeat to yourself: "I am safe. This will pass."',
  ),
  CalmTip(
    title: 'Muscle Relaxation',
    description: 'Tense and release each muscle group from toes to head.',
  ),
  CalmTip(
    title: 'Distraction',
    description: 'Count backwards from 100, or think of your favorite memory.',
  ),
];
