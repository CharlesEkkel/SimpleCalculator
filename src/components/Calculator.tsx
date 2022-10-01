import { FaEquals } from "react-icons/fa";
import renderToken from "../renderTokens";
import useCalcStore, { Token } from "../store";
import Button from "./Button";

interface CalculatorProps {}

const Calculator = (props: CalculatorProps) => {
    const runEquals = useCalcStore((state) => state.calculateResult);
    const addToken = useCalcStore((state) => state.addToken);

    const click = (token: Token) => () => addToken(token)

    return (
        <div className="grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg">
            <div />
            <div />
            {tokensInOrder.map((token) =>
                <Button
                    onClick={click(token)}
                    icon={renderToken(token)}
                />
            )}
            <Button onClick={runEquals} icon={<FaEquals />} />
        </div>
    );
};

export default Calculator;

const tokensInOrder: Token[] = [
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
