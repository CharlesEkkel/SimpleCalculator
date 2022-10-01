import create from "zustand";
import { devtools } from "zustand/middleware";

interface CalcState {
    /* Latest expression is stored the front */
    oldExpressions: Token[][];
    currentTokens: Token[];
    addToken: (token: Token) => void;
    backspace: () => void;
    calculateResult: () => void;
}

const useCalcStore = create<CalcState>(devtools((set) => ({
    oldExpressions: [],
    currentTokens: [],
    addToken: (token) =>
        set((state) => ({
            currentTokens: [...state.currentTokens, token],
        })),
    backspace: () =>
        set((state) => ({
            currentTokens: state.currentTokens.slice(0, state.currentTokens.length - 2),
        })),
    calculateResult: () =>
        set((state) => ({
            oldExpressions: [state.currentTokens, ...state.oldExpressions],
            currentTokens: processTokens(state.currentTokens)
        }))
})));

export default useCalcStore;

const processTokens = (tokens: Token[]): Token[] => {
    return tokens.slice(0, 1)
}

export type Token =
    "clear"
    | "backspace"
    | "cycle"
    | "sin"
    | "cos"
    | "tan"
    | "natural-log"
    | "log"
    | "toggle-radians"
    | "square-root"
    | "brackets"
    | "percentage"
    | "factorial"
    | "divide"
    | "multiply"
    | "e"
    | "subtract"
    | "exponent"
    | "add"
    | "squared"
    | "toggle-polarity"
    | "decimal-point"
    | 0
    | 1
    | 2
    | 3
    | 4
    | 5
    | 6
    | 7
    | 8
    | 9
