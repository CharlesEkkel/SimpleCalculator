import { Stack } from "immutable";
import {
    FaDivide,
    FaExclamation,
    FaMinus,
    FaPercent,
    FaPlus,
    FaSquareRootAlt,
    FaTimes,
} from "react-icons/fa";

export type Token = {
    readonly type: "value" | "unary-op" | "binary-op";
    readonly text: string;
    readonly icon: JSX.Element | string;
} | {
    readonly type: "bracket";
    readonly text: [string, string];
    readonly icon: JSX.Element | string;
}

export const invisibleBracket: Token = {
    type: "bracket",
    text: ["", ""],
    icon: ""
}

export const bracket: Token = {
    type: "bracket",
    text: ["(", ")"],
    icon: "()"
}

export const sin: Token = {
    type: "unary-op",
    text: "sin",
    icon: "sin"
}

export const cos: Token = {
    type: "unary-op",
    text: "cos",
    icon: "cos"
}

export const tan: Token = {
    type: "unary-op",
    text: "tan",
    icon: "tan"
}

export const naturalLog: Token = {
    type: "unary-op",
    text: "ln",
    icon: "ln"
}

export const log: Token = {
    type: "unary-op",
    text: "log₁₀",
    icon: "log₁₀"
}

export const squareRoot: Token = {
    type: "unary-op",
    text: "√",
    icon: <FaSquareRootAlt />
}

export const factorial: Token = {
    type: "unary-op",
    text: "!",
    icon: "!"
}

export const squared: Token = {
    type: "unary-op",
    text: "x²",
    icon: "x²"
}

export const add: Token = {
    type: "binary-op",
    text: "+",
    icon: <FaPlus />
}

export const subtract: Token = {
    type: "binary-op",
    text: "-",
    icon: <FaMinus />
}

export const multiply: Token = {
    type: "binary-op",
    text: "⨯",
    icon: <FaTimes />
}

export const divide: Token = {
    type: "binary-op",
    text: "÷",
    icon: <FaDivide />
}

export const exponent: Token = {
    type: "binary-op",
    text: "x¹⁰",
    icon: "x¹⁰"
}

export const zero: Token = {
    type: "value",
    text: "0",
    icon: "0"
}

export const one: Token = {
    type: "value",
    text: "1",
    icon: "1"
}

export const two: Token = {
    type: "value",
    text: "2",
    icon: "2"
}

export const three: Token = {
    type: "value",
    text: "3",
    icon: "3"
}

export const four: Token = {
    type: "value",
    text: "4",
    icon: "4"
}

export const five: Token = {
    type: "value",
    text: "5",
    icon: "5"
}

export const six: Token = {
    type: "value",
    text: "6",
    icon: "6"
}

export const seven: Token = {
    type: "value",
    text: "7",
    icon: "7"
}

export const eight: Token = {
    type: "value",
    text: "8",
    icon: "8"
}

export const nine: Token = {
    type: "value",
    text: "9",
    icon: "9"
}

export const e: Token = {
    type: "value",
    text: "e",
    icon: "e"
}
