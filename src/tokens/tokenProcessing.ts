import { Stack } from "immutable";
import { AnyToken, invisibleBracket, Token } from "./tokens";

export const renderExpression = (expression: AnyToken[]): string => {
    const expressionWithClosingBracket = Stack([invisibleBracket as AnyToken]).unshiftAll(expression);
    const [value, _] = renderSection(invisibleBracket, expressionWithClosingBracket);
    return value;
}

const renderSection = (bracketToken: Token<"bracket">, expression: Stack<AnyToken>): [string, Stack<AnyToken>] => {
    let runningString = "";

    while (true) {
        const token = expression.peek();

        // Check for empty stack.
        if (!token)
            break;
        else {
            // Update the stack (in O(1) time!!)
            expression = expression.pop()

            if (token.type === "value") {
                runningString += token.text;
            }
            if (token.type === "binary-op") {
                runningString += token.text;
            }
            else if (token === bracketToken) {
                break;
            }
            else if (token.type === "bracket") {
                const [portion, trimmedExpression] = renderSection(token as Token<"bracket">, expression);
                expression = trimmedExpression;
                runningString += portion;
            }
        }
    }

    // We've reached the end of the bracketed section!
    return [runningString, expression]
}

// export const renderToken = (token: Token): TokenIcon => {
//     switch (token) {
//         case "clear": return "C"
//         case "backspace": return <FaBackspace />
//         case "cycle": return <FaRecycle />
//         case "sin": return "sin"
//         case "cos": return "cos"
//         case "tan": return "tan"
//         case "natural-log": return "ln"
//         case "log": return "log"
//         case "toggle-radians": return "Rad"
//         case "square-root": return <FaSquareRootAlt />
//         case "brackets": return "()"
//         case "percentage": return <FaPercent />
//         case "factorial": return <FaExclamation />
//         case "divide": return <FaDivide />
//         case 7: return "7"
//         case 8: return "8"
//         case 9: return "9"
//         case "multiply": return <FaTimes />
//         case "e": return "e"
//         case 4: return "4"
//         case 5: return "5"
//         case 6: return "6"
//         case "subtract": return <FaMinus />
//         case "exponent": return "x^y"
//         case 1: return "1"
//         case 2: return "2"
//         case 3: return "3"
//         case "add": return <FaPlus />
//         case "squared": return "x^2"
//         case "toggle-polarity": return "+-"
//         case 0: return "0"
//         case "decimal-point": return "."
//     }
// }

// export const renderExpression = (tokens: Expression): string => {
//     let withinBrackets = false;
//     const around = renderBrackets(withinBrackets);
//     return tokens.map(token => {
//         switch (token) {
//             case "sin": return "sin"
//             case "cos": return "cos"
//             case "tan": return "tan"
//             case "natural-log": return "ln"
//             case "log": return "log"
//             case "toggle-radians": return "Rad"
//             case "square-root": return around("√")
//             case "brackets": return around("");
//             case "percentage": return "%";
//             case "factorial": return <FaExclamation />
//             case "divide": return <FaDivide />
//             case 7: return "7"
//             case 8: return "8"
//             case 9: return "9"
//             case "multiply": return <FaTimes />
//             case "e": return "e"
//             case 4: return "4"
//             case 5: return "5"
//             case 6: return "6"
//             case "subtract": return <FaMinus />
//             case "exponent": return "x^y"
//             case 1: return "1"
//             case 2: return "2"
//             case 3: return "3"
//             case "add": return <FaPlus />
//             case "squared": return "x^2"
//             case "toggle-polarity": return "+-"
//             case 0: return "0"
//             case "decimal-point": return "."
//         }
//     })
// }

export const renderBrackets = (withinBrackets: boolean) => (renderedToken: string) => {
    const returnVal = withinBrackets ? renderedToken + "(" : ")";
    withinBrackets = !withinBrackets;
    return returnVal;
}

const processOperation = () => {}
