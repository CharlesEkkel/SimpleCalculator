import { List, Set } from "immutable";
import * as E from 'fp-ts/Either';
import create from "zustand";
import { devtools } from "zustand/middleware";
import { evaluateTokens } from "./tokens/MathTree";
import { addTokenToList, bracket, combineValues, isEmpty, mkValue, Token } from "./tokens/tokens";

interface CalcState {
    /* Latest expression is stored the front */
    oldExpressions: List<List<Token>>;
    currentTokens: List<Token>;
    usingRadians: boolean;
    errorMessage: string;
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
    errorMessage: "",
    addToken: (token) =>
        set((state) => 
            E.match(
                (err: string) => ({errorMessage: err}),
                (match: List<Token>) => ({currentTokens: match, errorMessage: ""})
            )(addTokenToList(state.currentTokens, token))
        ),
    backspace: () =>
        set((state) => ({
            currentTokens: state.currentTokens.slice(0, state.currentTokens.count() - 2)
        })),
    calculateResult: () =>
        set((state) => ({
            oldExpressions: state.oldExpressions.unshift(state.currentTokens),
            currentTokens: 
                state.currentTokens
                    .clear()
                    .push(mkValue(evaluateTokens(state.currentTokens)))
        })),
    clear: () =>
        set((state) => ({
            currentTokens: state.currentTokens.clear().push(mkValue(0))
        })),
    clearAll: () =>
        set((state) => ({
            oldExpressions: state.oldExpressions.clear(),
            currentTokens: state.currentTokens.clear().push(mkValue(0)),
        })),
    toggleRadians: () =>
        set((state) => ({
            usingRadians: !state.usingRadians
        }))
})));

export default useCalcStore;
