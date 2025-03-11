import winston from "winston";
import chalk from "chalk";

function colorizeJson(obj: any) {
  let result = "";
  const recurse = (obj: any, indent = 0) => {
    const type = typeof obj;
    if (Array.isArray(obj)) {
      result += chalk.yellow("[") + "\n";
      obj.forEach((item) => {
        result += " ".repeat(indent + 2);
        recurse(item, indent + 2);
        result += "," + "\n";
      });
      result += " ".repeat(indent) + chalk.yellow("]");
    } else if (obj !== null && type === "object") {
      result += chalk.yellow("{") + "\n";
      Object.keys(obj).forEach((key, index, array) => {
        result += " ".repeat(indent + 2) + chalk.blue(key) + chalk.white(": ");
        recurse(obj[key], indent + 2);
        if (index < array.length - 1) {
          result += ",";
        }
        result += "\n";
      });
      result += " ".repeat(indent) + chalk.yellow("}");
    } else if (type === "string") {
      result += chalk.green(`"${obj}"`);
    } else {
      result += chalk.cyan(`${obj}`);
    }
  };
  recurse(obj);
  return result;
}

export const prettyJson = winston.format.printf(
  (info: winston.Logform.TransformableInfo) => {
    const logLevelsToColors = {
      error: chalk.red,
      warn: chalk.yellow,
      info: chalk.green,
      debug: chalk.blue,
    } as const;

    // TODO (amiller68): it would be nice to not use this as a type assertion
    const colorizeLevel =
      logLevelsToColors[info.level as keyof typeof logLevelsToColors] ||
      chalk.white;

    // Beautify the JSON string
    return `[${colorizeLevel(info.level)}] ${chalk.gray(
      info.timestamp,
    )} - ${chalk.white(info.message)}: ${colorizeJson(info)}`;
  },
);
