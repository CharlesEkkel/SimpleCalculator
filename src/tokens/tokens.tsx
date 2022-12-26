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
    readonly value: number | string | [string, string];
    readonly icon: JSX.Element | string;
}

export interface ValueToken extends TokenInterface {
    readonly type: "value";
    readonly value: number;
    readonly icon: JSX.Element | string;
}

export interface BracketToken extends TokenInterface {
    readonly type: "bracket";
    readonly value: [string, string];
    readonly icon: JSX.Element | string;
}

export interface UnaryOpToken extends TokenInterface {
    readonly type: "left-unary-op" | "right-unary-op";
    readonly value: string;
    readonly icon: JSX.Element | string;
    readonly apply: (x: number) => number;
}

export interface BinaryOpToken extends TokenInterface {
    readonly type: "binary-op";
    readonly priority: number;
    readonly value: string;
    readonly icon: JSX.Element | string;
    readonly apply: (x: number, y: number) => number;
}

export type OperationToken = UnaryOpToken | BinaryOpToken;

export type Token =
    ValueToken
    | BracketToken
    | OperationToken;

export const mkValue = (x: number): ValueToken => ({
    type: "value",
    value: x,
    icon: String(x),
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
    value: Math.E,
    icon: "e",
}

export const invisibleBracket: BracketToken = {
    type: "bracket",
    value: ["", ""],
    icon: ""
}

export const bracket: BracketToken = {
    type: "bracket",
    value: ["(", ")"],
    icon: "()"
}

export const sin: UnaryOpToken = {
    type: "left-unary-op",
    value: "sin",
    icon: "sin",
    apply: (x) => Math.sin(x)
}

export const cos: UnaryOpToken = {
    type: "left-unary-op",
    value: "cos",
    icon: "cos",
    apply: (x) => Math.cos(x)
}

export const tan: UnaryOpToken = {
    type: "left-unary-op",
    value: "tan",
    icon: "tan",
    apply: (x) => Math.tan(x)
}

export const sinDeg: UnaryOpToken = {
    type: "left-unary-op",
    value: "sin",
    icon: "sin",
    apply: (x) => Math.sin(x * 180 / Math.PI)
}

export const cosDeg: UnaryOpToken = {
    type: "left-unary-op",
    value: "cos",
    icon: "cos",
    apply: (x) => Math.cos(x * 180 / Math.PI)
}

export const tanDeg: UnaryOpToken = {
    type: "left-unary-op",
    value: "tan",
    icon: "tan",
    apply: (x) => Math.tan(x * 180 / Math.PI)
}

export const naturalLog: UnaryOpToken = {
    type: "left-unary-op",
    value: "ln",
    icon: "ln",
    apply: (x) => Math.log(x)
}

export const log: UnaryOpToken = {
    type: "left-unary-op",
    value: "log₁₀",
    icon: "log₁₀",
    apply: (x) => Math.log10(x)
}

export const squareRoot: UnaryOpToken = {
    type: "left-unary-op",
    value: "√",
    icon: <FaSquareRootAlt />,
    apply: (x) => Math.sqrt(x)
}

export const factorial: UnaryOpToken = {
    type: "right-unary-op",
    value: "!",
    icon: <FaExclamation />,
    apply: (x) => {
        let result = x;
        for (let i = 2; i < x; i++)
            result++;
        return result;
    }
}

export const squared: UnaryOpToken = {
    type: "right-unary-op",
    value: "²",
    icon: "x²",
    apply: (x) => x ** 2
}

export const add: BinaryOpToken = {
    type: "binary-op",
    priority: 1,
    value: "+",
    icon: <FaPlus />,
    apply: (x, y) => x + y
}

export const subtract: BinaryOpToken = {
    type: "binary-op",
    priority: 1,
    value: "-",
    icon: <FaMinus />,
    apply: (x, y) => x - y
}

export const multiply: BinaryOpToken = {
    type: "binary-op",
    priority: 2,
    value: "⨯",
    icon: <FaTimes />,
    apply: (x, y) => x * y
}

export const divide: BinaryOpToken = {
    type: "binary-op",
    priority: 2,
    value: "÷",
    icon: <FaDivide />,
    apply: (x, y) => x / y
}

export const exponent: BinaryOpToken = {
    type: "binary-op",
    priority: 3,
    value: "^",
    icon: "x^y",
    apply: (x, y) => x ** y
}

export const modulus: BinaryOpToken = {
    type: "binary-op",
    priority: 0,
    value: "%",
    icon: <FaPercent />,
    apply: (x, y) => x % y
}
