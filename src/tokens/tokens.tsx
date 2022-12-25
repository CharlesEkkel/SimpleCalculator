import {
    FaDivide,
    FaExclamation,
    FaMinus,
    FaPercent,
    FaPlus,
    FaSquareRootAlt,
    FaTimes,
} from "react-icons/fa";

type TokenType = "value" | "bracket" | "left-unary-op" | "right-unary-op" | "binary-op";

interface TokenInterface {
    readonly type: TokenType;
    readonly text: string | [string, string];
    readonly icon: JSX.Element | string;
}

export interface ValueToken extends TokenInterface {
    readonly type: "value";
    readonly text: string;
    readonly icon: JSX.Element | string;
    readonly value: number;
}

export interface BracketToken extends TokenInterface {
    readonly type: "bracket";
    readonly text: [string, string];
    readonly icon: JSX.Element | string;
}

export interface UnaryOpToken extends TokenInterface {
    readonly type: "left-unary-op" | "right-unary-op";
    readonly text: string;
    readonly icon: JSX.Element | string;
    readonly apply: (x: ValueToken) => ValueToken;
}

export interface BinaryOpToken extends TokenInterface {
    readonly type: "binary-op";
    readonly priority: number;
    readonly text: string;
    readonly icon: JSX.Element | string;
    readonly apply: (x: ValueToken, y: ValueToken) => ValueToken;
}

export type Token =
    ValueToken
    | BracketToken
    | UnaryOpToken
    | BinaryOpToken

const mkValue = (x: number): ValueToken => ({
    type: "value",
    text: String(x),
    icon: String(x),
    value: x
})

export const zero: Token = mkValue(0)
export const one: Token = mkValue(1)
export const two: Token = mkValue(2)
export const three: Token = mkValue(3)
export const four: Token = mkValue(4)
export const five: Token = mkValue(5)
export const six: Token = mkValue(6)
export const seven: Token = mkValue(7)
export const eight: Token = mkValue(8)
export const nine: Token = mkValue(9)

export const e: Token = {
    type: "value",
    text: "e",
    icon: "e",
    value: Math.E
}

export const invisibleBracket: BracketToken = {
    type: "bracket",
    text: ["", ""],
    icon: ""
}

export const bracket: BracketToken = {
    type: "bracket",
    text: ["(", ")"],
    icon: "()"
}

export const sin: UnaryOpToken = {
    type: "left-unary-op",
    text: "sin",
    icon: "sin",
    apply: (t) => mkValue(Math.sin(t.value))
}

export const cos: UnaryOpToken = {
    type: "left-unary-op",
    text: "cos",
    icon: "cos",
    apply: (t) => mkValue(Math.cos(t.value))
}

export const tan: UnaryOpToken = {
    type: "left-unary-op",
    text: "tan",
    icon: "tan",
    apply: (t) => mkValue(Math.tan(t.value))
}

export const sinDeg: UnaryOpToken = {
    type: "left-unary-op",
    text: "sin",
    icon: "sin",
    apply: (t) => mkValue(Math.sin(t.value * 180 / Math.PI))
}

export const cosDeg: UnaryOpToken = {
    type: "left-unary-op",
    text: "cos",
    icon: "cos",
    apply: (t) => mkValue(Math.cos(t.value * 180 / Math.PI))
}

export const tanDeg: UnaryOpToken = {
    type: "left-unary-op",
    text: "tan",
    icon: "tan",
    apply: (t) => mkValue(Math.tan(t.value * 180 / Math.PI))
}

export const naturalLog: UnaryOpToken = {
    type: "left-unary-op",
    text: "ln",
    icon: "ln",
    apply: (t) => mkValue(Math.log(t.value))
}

export const log: UnaryOpToken = {
    type: "left-unary-op",
    text: "log₁₀",
    icon: "log₁₀",
    apply: (t) => mkValue(Math.log10(t.value))
}

export const squareRoot: UnaryOpToken = {
    type: "left-unary-op",
    text: "√",
    icon: <FaSquareRootAlt />,
    apply: (t) => mkValue(Math.sqrt(t.value))
}

export const factorial: UnaryOpToken = {
    type: "right-unary-op",
    text: "!",
    icon: <FaExclamation />,
    apply: (t) => {
        let result = t.value;
        for (let i = 2; i < t.value; i++)
            result++;
        return mkValue(result);
    }
}

export const squared: UnaryOpToken = {
    type: "right-unary-op",
    text: "²",
    icon: "x²",
    apply: (t) => mkValue((t.value) ** 2)
}

export const add: BinaryOpToken = {
    type: "binary-op",
    priority: 1,
    text: "+",
    icon: <FaPlus />,
    apply: (t1, t2) => mkValue(t1.value + t2.value)
}

export const subtract: BinaryOpToken = {
    type: "binary-op",
    priority: 1,
    text: "-",
    icon: <FaMinus />,
    apply: (t1, t2) => mkValue(t1.value - t2.value)
}

export const multiply: BinaryOpToken = {
    type: "binary-op",
    priority: 2,
    text: "⨯",
    icon: <FaTimes />,
    apply: (t1, t2) => mkValue(t1.value * t2.value)
}

export const divide: BinaryOpToken = {
    type: "binary-op",
    priority: 2,
    text: "÷",
    icon: <FaDivide />,
    apply: (t1, t2) => mkValue(t1.value / t2.value)
}

export const exponent: BinaryOpToken = {
    type: "binary-op",
    priority: 3,
    text: "^",
    icon: "x^y",
    apply: (t1, t2) => mkValue(t1.value ** t2.value)
}

export const modulus: BinaryOpToken = {
    type: "binary-op",
    priority: 0,
    text: "%",
    icon: <FaPercent />,
    apply: (t1, t2) => mkValue(t1.value % t2.value)
}
