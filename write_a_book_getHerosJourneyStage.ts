function getHeroJourneyStage(percentComplete: number): string {
  if (percentComplete < 10) {
    return "Ordinary World";
  } else if (percentComplete < 20) {
    return "Call to Adventure";
  } else if (percentComplete < 30) {
    return "Refusal of the Call";
  } else if (percentComplete < 40) {
    return "Meeting the Mentor";
  } else if (percentComplete < 50) {
    return "Crossing the Threshold";
  } else if (percentComplete < 70) {
    return "Tests, Allies, and Enemies";
  } else if (percentComplete < 80) {
    return "Approach to the Inmost Cave";
  } else if (percentComplete < 90) {
    return "Ordeal";
  } else if (percentComplete < 95) {
    return "Reward";
  } else {
    return "The Road Back, Resurrection, and Return with the Elixir";
  }
}
