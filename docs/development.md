# development

- [development](#development)
- [Project challenges](#project-challenges)
- [Concept](#concept)
  - [Domain definition](#domain-definition)
    - [Background](#background)
    - [Core Formula](#core-formula)
    - [MET values](#met-values)
    - [Formula Parameters](#formula-parameters)
    - [Alternative equivalent Formula](#alternative-equivalent-formula)
    - [Precision Formula](#precision-formula)
    - [Common simplification](#common-simplification)
    - [Reality Check](#reality-check)
    - [Estimation methods](#estimation-methods)
    - [Target Solution](#target-solution)
  - [Cycle](#cycle)
    - [Overview](#overview)
    - [Static Estimation](#static-estimation)
    - [Adaptive multiplier](#adaptive-multiplier)
    - [Predictive Model](#predictive-model)
- [Domain Modeling](#domain-modeling)
  - [Data model](#data-model)
    - [DailyLog](#dailylog)
    - [FoodEntry](#foodentry)
    - [WorkoutEntry](#workoutentry)
    - [WeightEntry](#weightentry)
  - [Calculation Engine](#calculation-engine)
- [UX](#ux)
  - [User Stories](#user-stories)
    - [Measure Mode](#measure-mode)
    - [Workout Mode](#workout-mode)
  - [Transparency for trust](#transparency-for-trust)
  - [Look and Feel](#look-and-feel)
  - [Usage Flows](#usage-flows)
    - [New day start-up](#new-day-start-up)
    - [Morning mode](#morning-mode)
    - [Food logging](#food-logging)
    - [Workout mode](#workout-mode-1)
  - [Design principle](#design-principle)
    - [Architectural implications](#architectural-implications)
  - [Materials, Colors and Screens](#materials-colors-and-screens)
    - [Overall Tone](#overall-tone)
    - [Workout Mode Design](#workout-mode-design)
    - [Dashboard Mode](#dashboard-mode)
  - [Typography direction](#typography-direction)
  - [Emotional tone summary](#emotional-tone-summary)
  - [Implementation Strategy in Flutter](#implementation-strategy-in-flutter)


# Project challenges
* Mobile dev (Flutter)
* Data persistence
* Basic physiology
* Time-series smoothing
* Feedback systems
* UX around uncertainty

# Concept

## Domain definition

### Background

There are well-established formulas for estimating burned calories. Most fitness apps rely on MET-based calculations, which are considered semi-official and widely used in exercise science.

The most common reference source is the Compendium of Physical Activities, originally developed by Barbara Ainsworth and colleagues. It assigns MET values to hundreds of activities.

### Core Formula

The standard formula for estimating calories burned is (MET-Based):

> Calories burned = MET × weight (kg) × duration (h)

**What is MET?**
* MET = Metabolic Equivalent of Task
* 1 MET = energy cost of resting (≈ 1 kcal/kg/hour)

| Activity                 | MET |
| ------------------------ | --- |
| Sleeping                 | 0.9 |
| Sitting quietly          | 1.3 |
| Walking 5 km/h           | 3.3 |
| Running 8 km/h           | 8.3 |
| Cycling moderate         | 6–8 |
| Weight lifting (general) | 3–6 |

**Example Calculation**

Person:
* Weight: 85 kg
* Running at 8 km/h (MET = 8.3)
* Duration: 45 minutes (0.75 hours)

> 8.3 × 85 × 0.75 = 529kcal

Estimated burned calories: ~530 kcal

###  MET values
The most cited database (Official source):
* Compendium of Physical Activities (Ainsworth et al.) => Updated 2011 and 2018 editions

### Formula Parameters

**Weight**
* direct multiplier => higher weight = higher calorie burn

**Exercise/ Exercise Type**
* determines MET value
```
Map<String, double> metValues = {
    "walking_2.7_kmh": 2.3, // slow
    "walking_4_kmh": 2.9, // normal
    "walking_5_kmh": 3.3, // moderate
    "walking_6_kmh": 5.3, // brisk
    "running_8_kmh": 8.3,
    "cycling_moderate": 7.5,
    "weight_training_light": 3.5,
    "weight_training_moderate": 4.5,
    "weight_training_intense": 6.0,
};
```

**Duration/Exercise period**
* always required (m or h)

**Walked kilometers  (cardio)**
* Distance-based calculation can be more accurate for walking/running:

Running rule of thumb:
> 1 kcal per kg per km

(85kg person runs 5km = 425kcal) 

**Repetitions & Sets (weight lifting)**

Strength training calorie burn is harder to estimate because:
* Rest time matters
* Intensity matters
* Muscle groups matter
* Tempo matters

Most apps simplify it using:
* Light lifting: 3–4 MET
* Moderate lifting: 4–5 MET
* Heavy lifting: 6 MET

Reps & sets alone are not enough to estimate calories unless you:
* Estimate total workout duration
* Or estimate time under tension


### Alternative equivalent Formula

Another commonly used formula (More "Medical Style"):

> Calories per minute = (MET × 3.5 × weight(kg)) / 200

Then:

> Calories = Calories per minute × minutes

Both formulas give nearly identical results.

### Precision Formula

More advanced estimation includes: Heart rate–based formula (more accurate)

**Example for men:**

> calories = time x ( (−55.0969+(0.6309×HR)+(0.1988×weight)+(0.2017×age)) / 4.184) 

**Example for women:**

> calories = time x ( (−20.4022+(0.4472×HR)+(0.1263×weight)+(0.074×age)) / 4.184) 

### Common simplification

other apps do:

1. Estimate BMR (Mifflin-St Jeor formula)
2. Use MET tables for activities
3. Multiply by duration and weight
4. Apply slight correction factors

### Reality Check

Calorie burn estimation error:
* ±10–25% easily
* Strength training often worse
* Individual metabolism differs
* Movement efficiency differs

### Estimation methods
**open-loop estimation:**
> calories_burned = MET × weight × duration

**closed-loop control:**
> Estimate → Compare with real weight change → Adjust model

key principle (example):

Body fat loss roughly follows:
> 1 kg fat ≈ 7,700 kcal deficit

So if over 14 days:
* You logged: –5,000 kcal total deficit
* But weight dropped 1 kg (~7,700 kcal)

Then your estimation is off by:
> 7,700 / 5,000 = 1.54 correction factor

That factor can then adjust:
* Activity burn multiplier
* Or BMR estimation
* Or global energy expenditure model

Now the app adapts to the user instead of assuming physiology.


### Target Solution

Cardio:
* Use MET formula
* Or distance-based formula for running

Weight lifting:
* Use MET based on intensity level
* Let user select: light, moderate, intense

Auto calorie adjustment:
* Track actual weight progress
* Compare predicted deficit vs actual weight loss
* Adjust calorie burn factor automatically

Knowledge base:
* take 1 year of personal log data to calibrate engine

## Cycle

### Overview

Layer 1 — Static Estimation
* MET-based

Layer 2 — Adaptive Multiplier
* Personalized burn correction factor

Layer 3 — Predictive Model
* Project weight 30 days ahead based on current trend

### Static Estimation

* see domain model above

### Adaptive multiplier

**Step 1: Daily Data Logged**
* Calories eaten
* Estimated calories burned
* Body weight

**Step 2: Calculate Predicted Deficit**
> predictedDeficit = intake - burn

**Step 3: Calculate Actual Deficit**
> actualDeficit = weightDeltaKg × 7700

**Step 4: Compute Correction Factor**
> correctionFactor = actualDeficit / predictedDeficit

**Step 5: Apply Smoothing**
Never adjust instantly. Use:
* Rolling 14–21 day window
* Exponential moving average

Otherwise water retention will destroy the model.

**Reason for this advanced adjustment:**

Real-world weight fluctuates due to Glycogen storage, Sodium intake, Hormonal changes, Hydration or Digestive content - which means that raw daily weight is useless for claorie adjustments. Instead we need:

* Moving average smoothing
* Trend extraction (7–14 day rolling mean)

### Predictive Model

t.b.d.

# Domain Modeling

## Data model

Approach: 
Design it clean first - add complexity later.

* All analytics operate on DailyLog
* Adaptive engine operates on DailyLog
* UI reads DailyLog only
* Entries are detail layer, not required for core logic

Separation of concerns without complexity.

### DailyLog
* used as aggregate anchor
* Instead of separate chaotic entries, anchor everything to a day.

```
DailyLog
- date (DateTime)
- totalCaloriesIntake (int)
- totalProtein (double)
- totalCarbs (double)
- totalFat (double)
- workoutCalories (int)
- bodyWeight (double?)
```

Benefits:
* O(1) dashboard queries
* Easy trend analysis
* Clean adaptive calculations

Possibility to keep detailed entries separately if desired.

### FoodEntry

* optional detail layer

```
FoodEntry
- id
- date
- name
- calories
- protein
- carbs
- fat
```

DailyLog aggregates these automatically.

### WorkoutEntry

```
WorkoutEntry
- id
- date
- workoutType (enum: cardio, weight lifting)
- durationMinutes
- intensityLevel (enum: light, moderate, intense)
- estimatedCalories
```

Deeper model for weight lifting:

```
ExerciseSet
- exerciseName
- weight
- reps
- sets
```

### WeightEntry
* embedded inside DailyLog to simplify

## Calculation Engine
* Calorie adjustment engine architecture:

**1. Static Estimation**

Baseline TDEE - Mifflin-St Jeor:
> BMR = (10 × weight) + (6.25 × height) − (5 × age) + 5
>
> TDEE = BMR × activityFactor

(may override with historical data)

**2. Real Deficit Tracking**

Each day:
> predictedDeficit = intake - (baselineTDEE + workoutCalories)

Then maintain rolling window (e.g., 21 days):
> actualDeficit = (weightTrendStart - weightTrendEnd) × 7700

**3. Adaptive Correction Factor**

> correctionFactor = actualDeficit / predictedDeficit

Then smooth:
> adaptiveFactor = 0.9 × previousFactor + 0.1 × newFactor

The adjusted TDEE becomes:
> adjustedTDEE = baselineTDEE × adaptiveFactor

*Important:*

Never adjust from raw daily weight.
Use:
* 7–14 day moving average
* Or exponential smoothing

Otherwise water retention destroys logic.

# UX

## User Stories

### Measure Mode

* at the start of a day the first thing i do is stepping onto the scale to measure my daily weight
* i then open the app the first time to track my weight
* then i close the app and only reopen it, when tracking my consumed food before eating
* sometimes i want to see the current calories/macro intake to make it easy to decide what to eat

### Workout Mode

* when i am in workout mode, i have the app constantly active to check the exercise sets and reps i did, after each set. sometimes i add extra sets or exercises
* the amount of reps is sometimes predefined, but i always try to do more than defined or increase the weight 
* in rare case i just fulfill the set rep amount and on bad days i interrupt the set when the muscle is already tired

## Transparency for trust

To builds trust and to make the app feel scientific, add an “info” button that shows:
* Which formula was used
* Which multiplier was applied
* Current correction factor
* Trend window length

## Look and Feel
* Not a dashboard
* Not a gamified tracker
* Not a control center
* more of a lab notebook with muscle memory speed

quiet training companion:

It does not:
* Ask questions
* Confirm obvious actions
* Force workflows
* Interrupt transitions

It only:
* Records
* Displays
* Calculates silently

> Quiet - Predictable - Precise

## Usage Flows

### New day start-up

When app opens:
1. Detect today != latestLog.date
2. Auto-create new DailyLog silently
3. No dialog.
4. No question.

Weight logging should be:

* Open app
* Big weight input
* Save
* Done

Time target: 3 seconds

### Morning mode

When opening app first time of the day and if weight not logged yet:

* Large weight input field (numeric keypad)
* “Save” button
* Below it: yesterday weight + delta

```
Weight Today: [ 89.4 ]
Δ from yesterday: -0.3 kg
```

No clutter.
No navigation required.

### Food logging

Reopen the app before eating.
That means:
* taking care about current macro totals
* want quick input

So the dashboard must show immediately:
```
Calories: 1240 / 2200
Protein: 135 g
Carbs: 110 g
Fat: 60 g
Workout Burn: 0 kcal
```

Then a single: [ + Food ] Button

**UX Rules:**

I don't want:
* Food database search
* Barcode scanner
* internet API

I likely eat recurring foods

so the design could be:
* “Recent foods” list
* Tap to add
* Adjust quantity
* Done

Time target: <5 seconds per meal

### Workout mode
* need a live session mode, not static logging here

When I start workout:
* Enter “Workout Session Mode”
* Screen stays awake
* Minimal UI
* No navigation

Each exercise should show:
```
Bench Press
Set 1: 80kg × 10 ✓
Set 2: 80kg × 10 ✓
Set 3: 80kg × 9
[ + Add Set ]

```
Tap set → mark complete.

Long press → edit reps or weight.

No forms.
No dialog spam.

**Important insights:**

I don’t follow strict program execution.
I adapt dynamically.

So the model must allow:
* Extra sets
* Weight changes mid-session
* Variable reps
* Early stop

This means:
* I don’t pre-generate fixed sets rigidly

Instead:
* Suggested sets
* But actual log is dynamic list

> HIDDEN opportunity: progressively overloading allows:
>
> - Volume = weight × reps × sets
> - Weekly volume trend
> - PR detection

## Design principle
* Design principle summary based on user stories

**Automatic Day Transition**
* No “close day” dialog.

**Single-Screen Daily Dashboard**
* Everything relevant visible immediately.

**One-Tap Weight Entry**
* Morning ritual optimized.

**One-Tap Food Logging**
* Recent-first design.

**Dedicated Workout Session Mode**
* Persistent screen.
* Low light UI.
* Fast set logging.

### Architectural implications
The app should have exactly 3 core screens:
* Dashboard (default)
* Workout Session
* Food Add/Edit

Everything else secondary.

No tab jungle.
No 5-layer navigation.

## Materials, Colors and Screens

* Dark
* Clean
* Serious
* High contrast
* Not playful
* Not decorative
* Not terminal ASCII
* Not notebook aesthetic
* Not spreadsheet aesthetic
* Buttons large enough mid-workout

### Overall Tone
* Dark background (#121212 or slightly softer)
* Neutral gray surfaces
* White primary text
* Muted accent color (deep blue, muted green, or desaturated orange)
* No gradients
* No heavy shadows

It should feel:
> Industrial. Focused. Calm.

**Things to Avoid**
* Heavy borders
* Complex icons
* Decorative gradients
* Cartoonish colors
* Micro buttons
* Floating UI chaos
* Pop-up confirmations

### Workout Mode Design

Workout mode should feel different from dashboard.

Characteristics:
* Almost full black background
* Large tap areas
* High contrast numbers
* Minimal animation
* Screen always awake

Example structure:
```
Bench Press

80 kg
Set 1: 10  ✓
Set 2: 10  ✓
Set 3: 9

[ + Add Set ]

```

Tap anywhere on a set row → edit quickly.

No popups if possible.

Inline editing.

Buttons:
* Big
* Rounded
* Flat
* Not glossy

Think: “tool”, not “app”.

**Import Insights:**
* fingers are sweaty, slightly shaking from working on set, under adrenaline

Minimum tap target:
* → 48dp absolute minimum
* → 56–64dp ideal in workout mode

Spacing matters more than design.

* Remove unnecessary app bars
* Remove back arrow clutter
* Use edge-to-edge layout
* Maybe slight vibration on set completion

It should feel responsive, not decorative.

### Dashboard Mode

Dashboard can use softened Material structure:
* Slight card separation
* Large macro numbers
* Clean progress bars
* No neon

Example:
```
Calories
1820 / 2200

Protein
155 g

Carbs
120 g

Fat
65 g

```
Everything scannable in 3 seconds.

## Typography direction
* One clean sans-serif (default Flutter is fine)
* Big numeric display for weight & reps
* Medium weight for labels
* No condensed fonts
* No monospaced font (that’s too terminal)

Terminal energy should come from restraint, not font.

## Emotional tone summary
* Dashboard → Calm overview
* Workout → Focused tool
* Food entry → Fast and functional

No emotional noise.

## Implementation Strategy in Flutter
* Use Material 3 theme
* Override:
  * colorScheme
  * surfaceVariant
  * typography scale
* Disable excessive elevation
* Use custom ButtonStyle with larger padding

You don’t need a custom design system.
Just controlled overrides.