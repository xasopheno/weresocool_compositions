const prompts = {
  summarizing: {
    prompt: `Summarize the key events, characters, and themes of the following chapters in the book so far:\n\n[Chapter summaries]`,
  },
  writing: {
    prompt: `Based on the summaries and previous chapters provided below, write a new chapter for a captivating love story set in the future. The writing style should draw inspiration from Kurt Vonnegut, Steven King, Stanislaw Lem, Isaac Asimov, Ursula K. Le Guin, Ray Bradbury, Philip K. Dick, Margaret Atwood, and Neal Stephenson. Create a unique narrative that blends elements from these authors, making it a page-turner that is both entertaining and thought-provoking.\n\nSummaries:\n[Chapter summaries]\n\nPrevious chapters:\n[Previous chapters]`,
  },
  editing: {
    prompt: `Review the following chapter and provide suggestions for improvement in terms of flow, style, coherence, and character development. Ensure that the writing style remains consistent and engaging while maintaining the influence of the authors mentioned.\n\nChapter:\n[New chapter]`,
  },
  updatingSummaries: {
    prompt: `Review the existing chapter summaries and update them to reflect any new developments, connections, or insights from the latest chapters. Ensure that the summaries remain relevant and provide the necessary context for a cohesive and engaging narrative. Retain any important callbacks, foreshadowing, and character development information.\n\nExisting chapter summaries:\n[Chapter summaries]\n\nLatest chapters:\n[Latest chapters]`,
  },
  improving: {
    prompt: `Incorporate the suggestions provided below to rewrite and enhance the chapter. Maintain the engaging and thought-provoking style throughout the revised chapter, and ensure the narrative is captivating and well-rounded.\n\nEdit suggestions:\n[Edit suggestions]\n\nOriginal chapter:\n[New chapter]`,
  },
};

type BuildPromptArgs = {
  step: number;
  chapterSummaries: string;
  previousChapters: string;
  newChapter: string;
  editSuggestions: string;
  prompts: any;
};

function buildPrompt(args: BuildPromptArgs): string {
  const {
    step,
    chapterSummaries,
    previousChapters,
    newChapter,
    editSuggestions,
    prompts,
  } = args;

  let prompt = "";

  switch (step) {
    case 0:
      prompt = prompts.summarizing.prompt.replace(
        "[Chapter summaries]",
        chapterSummaries
      );
      break;
    case 1:
      prompt = prompts.writing.prompt
        .replace("[Chapter summaries]", chapterSummaries)
        .replace("[Previous chapters]", previousChapters);
      break;
    case 2:
      prompt = prompts.updatingSummaries.prompt
        .replace("[Chapter summaries]", chapterSummaries)
        .replace("[Latest chapters]", previousChapters);
      break;
    case 3:
      prompt = prompts.editing.prompt.replace("[New chapter]", newChapter);
      break;
    case 4:
      prompt = prompts.improving.prompt
        .replace("[Edit suggestions]", editSuggestions)
        .replace("[New chapter]", newChapter);
      break;
    default:
      throw new Error("Invalid step");
  }

  return prompt;
}
  step,
  chapterSummaries,
  previousChapters,
  newChapter,
  editSuggestions,
  prompts,
});
