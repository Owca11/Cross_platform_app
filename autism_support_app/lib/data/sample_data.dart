import 'package:flutter/material.dart';
import '../models/feeling.dart';
import '../models/calm_tip.dart';

// Default feelings - these are the initial data
List<Feeling> sampleFeelings = [
  Feeling(
    name: 'Happy',
    icon: Icons.sentiment_very_satisfied,
    prompt: 'I feel happy',
  ),
  Feeling(
    name: 'Sad',
    icon: Icons.sentiment_dissatisfied,
    prompt: 'I feel sad',
  ),
  Feeling(
    name: 'Angry',
    icon: Icons.sentiment_very_dissatisfied,
    prompt: 'I feel angry',
  ),
  Feeling(
    name: 'Scared',
    icon: Icons.sentiment_neutral,
    prompt: 'I feel scared',
  ),
  Feeling(name: 'Excited', icon: Icons.celebration, prompt: 'I feel excited'),
  Feeling(name: 'Tired', icon: Icons.bedtime, prompt: 'I feel tired'),
  Feeling(
    name: 'Frustrated',
    icon: Icons.error_outline,
    prompt: 'I feel frustrated',
  ),
  Feeling(name: 'Anxious', icon: Icons.warning, prompt: 'I feel anxious'),
  Feeling(name: 'Calm', icon: Icons.spa, prompt: 'I feel calm'),
  Feeling(
    name: 'Overwhelmed',
    icon: Icons.blur_on,
    prompt: 'I feel overwhelmed',
  ),
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
  Need(
    name: 'Medicine',
    icon: Icons.medical_services,
    prompt: 'I need medicine',
  ),
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
  Thought(
    name: 'Idea',
    icon: Icons.lightbulb_outline,
    prompt: 'I have an idea',
  ),
  Thought(
    name: 'Question',
    icon: Icons.question_mark,
    prompt: 'I have a question',
  ),
  Thought(name: 'Forget', icon: Icons.cancel, prompt: 'I forget'),
  Thought(name: 'Understand', icon: Icons.check_circle, prompt: 'I understand'),
  Thought(name: 'Dream', icon: Icons.cloud, prompt: 'I had a dream'),
  Thought(name: 'Plan', icon: Icons.schedule, prompt: 'I have a plan'),
  Thought(name: 'Wonder', icon: Icons.star, prompt: 'I wonder'),
  Thought(name: 'Know', icon: Icons.info, prompt: 'I know'),
];

List<CalmTip> sampleCalmTips = [
  // Panic Attacks
  CalmTip(
    title: '5-4-3-2-1 Technique',
    description:
        'Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, 1 you can taste.',
    details:
        'This grounding technique helps bring your focus back to the present moment by engaging your senses. Start by naming 5 things you can see around you, then 4 things you can touch, 3 things you can hear, 2 things you can smell, and finally 1 thing you can taste. This method is particularly useful for reducing anxiety and sensory overload.',
    category: 'Panic Attacks',
  ),
  CalmTip(
    title: 'Deep Breathing',
    description:
        'Breathe in slowly for 4 counts, hold for 4, exhale for 4. Repeat.',
    details:
        'Deep breathing exercises activate the parasympathetic nervous system, which helps calm the body and mind. Inhale deeply through your nose for a count of 4, hold your breath for 4 counts, then exhale slowly through your mouth for 4 counts. Repeat this cycle several times. This technique can lower heart rate and reduce stress.',
    category: 'Panic Attacks',
  ),
  CalmTip(
    title: 'Grounding',
    description:
        'Focus on your feet on the ground, feel the support beneath you.',
    details:
        'Grounding techniques help you feel more connected to the present and less overwhelmed by emotions or thoughts. Sit or stand with your feet flat on the ground and focus on the sensation of your feet touching the floor. Feel the weight of your body being supported. This can help during moments of dissociation or intense emotions.',
    category: 'Panic Attacks',
  ),

  // Anxiety
  CalmTip(
    title: 'Positive Affirmation',
    description: 'Repeat to yourself: "I am safe. This will pass."',
    details:
        'Positive affirmations are statements that can help reframe negative thought patterns. Repeating phrases like "I am safe" or "This feeling will pass" can help build resilience and reduce anxiety. Choose affirmations that resonate with you and repeat them regularly, especially during challenging moments.',
    category: 'Anxiety',
  ),
  CalmTip(
    title: 'Muscle Relaxation',
    description: 'Tense and release each muscle group from toes to head.',
    details:
        'Progressive muscle relaxation involves tensing and then releasing different muscle groups in your body. Start with your toes, tense them for 5 seconds, then release. Move up through your body: feet, legs, abdomen, chest, arms, neck, and face. This technique can reduce physical tension and promote relaxation.',
    category: 'Anxiety',
  ),
  CalmTip(
    title: 'Mindful Walking',
    description:
        'Take a slow walk, focusing on each step and your surroundings.',
    details:
        'Mindful walking combines physical activity with mindfulness. Walk slowly, paying attention to the sensation of your feet touching the ground, the movement of your body, and your breath. This can help reduce anxiety by bringing your focus to the present moment and providing gentle exercise.',
    category: 'Anxiety',
  ),

  // Stress
  CalmTip(
    title: 'Distraction',
    description: 'Count backwards from 100, or think of your favorite memory.',
    details:
        'Distraction techniques can help shift your focus away from distressing thoughts or feelings. Counting backwards from 100 engages your brain in a simple task, or recalling a positive memory can evoke happier emotions. These methods are useful for short-term relief during overwhelming situations.',
    category: 'Stress',
  ),
  CalmTip(
    title: 'Visualization',
    description:
        'Imagine yourself in a peaceful place, like a beach or forest.',
    details:
        'Visualization involves creating a mental image of a calm, peaceful place. Close your eyes and imagine yourself in a favorite relaxing location, engaging all your senses in the experience. This technique can help reduce stress by providing a mental escape and promoting relaxation.',
    category: 'Stress',
  ),
  CalmTip(
    title: 'Journaling',
    description: 'Write down your thoughts and feelings to process them.',
    details:
        'Journaling can help you organize your thoughts and emotions. Write about what\'s causing your stress, how you feel, and potential solutions. This process can provide clarity and help you manage stress more effectively by externalizing your internal experiences.',
    category: 'Stress',
  ),

  // Sensory Overload
  CalmTip(
    title: 'Sensory Break',
    description: 'Find a quiet, dimly lit space to rest your senses.',
    details:
        'When experiencing sensory overload, remove yourself to a quiet environment. Dim the lights, reduce noise, and give yourself time to recover. This allows your nervous system to reset and prevents further overwhelm.',
    category: 'Sensory Overload',
  ),
  CalmTip(
    title: 'Weighted Blanket',
    description: 'Use a weighted blanket for deep pressure stimulation.',
    details:
        'Weighted blankets provide deep pressure touch stimulation, which can be calming for many people. The gentle pressure can help reduce anxiety and promote relaxation by mimicking a comforting hug.',
    category: 'Sensory Overload',
  ),
  CalmTip(
    title: 'Noise-Canceling Headphones',
    description:
        'Block out overwhelming sounds with noise-canceling headphones.',
    details:
        'Noise-canceling headphones can create a barrier against overwhelming auditory stimuli. Use them with calming music or white noise to help manage sensory overload in noisy environments.',
    category: 'Sensory Overload',
  ),

  // General
  CalmTip(
    title: 'Hydration Check',
    description: 'Drink water and ensure you\'re properly hydrated.',
    details:
        'Dehydration can worsen feelings of anxiety, stress, or overwhelm. Keep water nearby and sip regularly. Sometimes what feels like emotional distress is actually your body signaling the need for hydration.',
    category: 'General',
  ),
  CalmTip(
    title: 'Movement Break',
    description: 'Take a short walk or do some gentle stretching.',
    details:
        'Physical movement can help release built-up tension and improve mood. Even a few minutes of gentle stretching or walking can provide relief from stress and anxiety by releasing endorphins.',
    category: 'General',
  ),
  CalmTip(
    title: 'Self-Compassion',
    description: 'Be kind to yourself, just as you would to a friend.',
    details:
        'Practice self-compassion by treating yourself with the same kindness you\'d offer a friend in distress. Acknowledge your feelings without judgment and remind yourself that it\'s okay to struggle sometimes.',
    category: 'General',
  ),
];
