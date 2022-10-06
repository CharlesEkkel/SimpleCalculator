import { List, Set } from "immutable";
import create from "zustand";
import { devtools } from "zustand/middleware";
import { bracket, Token } from "./tokens/tokens";

interface CalcState {
    /* Latest expression is stored the front */
    oldExpressions: List<List<Token>>;
    currentTokens: List<Token>;
    usingRadians: boolean;
    addToken: (token: Token) => void;
    backspace: () => void;
    calculateResult: () => void;
    clear: () => void;
    clearAll: () => void;
    toggleRadians: () => void;
}

const useCalcStore = create<CalcState>()(devtools((set) => ({
    oldExpressions: List<List<Token>>(),
    currentTokens: List<Token>(),
    usingRadians: true,
    addToken: (token) =>
        set((state) => ({
            currentTokens: _addToken(token, state.currentTokens)
        })),
    backspace: () =>
        set((state) => ({
            currentTokens: state.currentTokens.slice(0, state.currentTokens.count() - 2)
        })),
    calculateResult: () =>
        set((state) => ({
            oldExpressions: state.oldExpressions.unshift(state.currentTokens),
            currentTokens: _addToken(state.currentTokens.first(), state.currentTokens.clear())
        })),
    clear: () =>
        set((state) => ({
            currentTokens: state.currentTokens.clear()
        })),
    clearAll: () =>
        set((state) => ({
            oldExpressions: state.oldExpressions.clear(),
            currentTokens: state.currentTokens.clear(),
        })),
    toggleRadians: () =>
        set((state) => ({
            usingRadians: !state.usingRadians
        }))
})));

export default useCalcStore;

const _addToken = (token: Token, currList: List<Token>): List<Token> => {

    if (token.type === "left-unary-op")
        return currList.push(token, bracket)

    const prevToken = currList.last();
    if (!prevToken || shouldAddToken(prevToken, token))
        return currList.push(token)

    return currList
}

const shouldAddToken = (prevToken: Token, newToken: Token): boolean => {
    const repeatableTokenTypes = Set<typeof newToken.type>(["value", "bracket"]);

    return repeatableTokenTypes.contains(prevToken.type)
        || repeatableTokenTypes.contains(newToken.type);
}
