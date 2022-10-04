import { List } from "immutable";
import create from "zustand";
import { devtools } from "zustand/middleware";
import { bracket, Token } from "./tokens/tokens";

interface CalcState {
    /* Latest expression is stored the front */
    oldExpressions: List<List<Token>>;
    currentTokens: List<Token>;
    addToken: (token: Token) => void;
    backspace: () => void;
    calculateResult: () => void;
    clear: () => void;
    clearAll: () => void;
}

const useCalcStore = create<CalcState>()(devtools((set) => ({
    oldExpressions: List<List<Token>>(),
    currentTokens: List<Token>(),
    addToken: (token) =>
        set((state) => ({
            currentTokens: token.type == "unary-op"
                ? state.currentTokens.push(token, bracket)
                : state.currentTokens.push(token)
        })),
    backspace: () =>
        set((state) => ({
            currentTokens: state.currentTokens.slice(0, state.currentTokens.count() - 2),
        })),
    calculateResult: () =>
        set((state) => ({
            oldExpressions: state.oldExpressions.unshift(state.currentTokens),
            currentTokens: processTokens(state.currentTokens)
        })),
    clear: () =>
        set((state) => ({
            currentTokens: state.currentTokens.clear(),
        })),
    clearAll: () =>
        set((state) => ({
            oldExpressions: state.oldExpressions.clear(),
            currentTokens: state.currentTokens.clear(),
        }))
})));

export default useCalcStore;

const processTokens = (tokens: List<Token>): List<Token> => {
    return tokens.slice(0, 1)
}
