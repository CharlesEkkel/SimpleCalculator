import { List } from 'immutable';
import { describe, it, expect } from 'vitest';
import { renderExpression } from './tokenProcessing';
import * as T from './tokens';

describe("when rendering an expression", () => {
    it("should nest brackets after an operation or bracket", () => {
        expect(renderExpression(List([
            T.bracket, T.five, T.multiply,
            T.bracket, T.nine, T.subtract,
            T.two, T.bracket, T.bracket]
        ))).toBe("(5⨯(9-2))")
    })
})
