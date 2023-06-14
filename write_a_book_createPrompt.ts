async function createPrompt(args: {
  storySoFar: string;
  summaries: string;
  lastChapterContent: string;
  newChapterContent: string;
  suggestions: string;
  percentComplete: number;
  heroJourneyStage: string;
}): Promise<string> {
  const {
    storySoFar,
    summaries,
    lastChapterContent,
    newChapterContent,
    suggestions,
    percentComplete,
    heroJourneyStage,
  } = args;

  const prompts = [
    `Based on the story so far:\n\n${storySoFar}\n\nSummarize the content written in the last chapter.`,
    `Based on the story so far:\n\n${storySoFar}\n\nUpdate the previous chapter summaries:\n\n${summaries}`,
    `Based on the story so far:\n\n${storySoFar}\n\nWrite a new chapter for the story. The current stage in the Hero's Journey is: ${heroJourneyStage}`,
    `Review and edit the content written in the last chapter:\n\n${lastChapterContent}`,
    `Improve the content written in the last chapter:\n\n${newChapterContent}\n\nHere are some suggestions for improvement:\n\n${suggestions}`,
  ];

  return prompts[currentStep - 1];
}
