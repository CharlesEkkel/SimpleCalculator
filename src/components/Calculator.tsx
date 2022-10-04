import { FaEquals } from "react-icons/fa";
import useCalcStore from "../store";
import { Token } from "../tokens/tokens";
import * as Tokens from "../tokens/tokens";
import Button from "./Button";

interface CalculatorProps {}

const Calculator = (props: CalculatorProps) => {
    const runEquals = useCalcStore((state) => state.calculateResult);
    const addToken = useCalcStore((state) => state.addToken);
    const runClear = useCalcStore((state) => state.clear);
    const runClearAll = useCalcStore((state) => state.clearAll);

    const click = (token: Token) => () => addToken(token)

    return (
        <div className="grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg">
            <Button onClick={runClearAll} icon="CA" />
            <Button onClick={runClear} icon="C" />
            {buttonTokens.map((token) =>
                <Button
                    onClick={click(token)}
                    icon={token.icon}
                />
            )}
            <Button onClick={runEquals} icon={<FaEquals />} />
        </div>
    );
};

export default Calculator;

const buttonTokens: Token[] = [
    Tokens.sin,
    Tokens.cos,
    Tokens.tan,
    Tokens.naturalLog,
    Tokens.log,
    Tokens.bracket,
    Tokens.divide,
    Tokens.one,
    Tokens.two,
    Tokens.three,
    Tokens.four
]

const tokensInOrder: (string | number)[] = [
    "clear",
    "backspace",
    "cycle",
    "sin",
    "cos",
    "tan",
    "natural-log",
    "log",
    "toggle-radians",
    "square-root",
    "brackets",
    "percentage",
    "factorial",
    "divide",
    7,
    8,
    9,
    "multiply",
    "e",
    4,
    5,
    6,
    "subtract",
    "exponent",
    1,
    2,
    3,
    "add",
    "squared",
    "toggle-polarity",
    0,
    "decimal-point",
]
