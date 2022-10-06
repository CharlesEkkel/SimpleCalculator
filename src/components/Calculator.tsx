import { FaEquals, FaRecycle } from "react-icons/fa";
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
    const runBackspace = useCalcStore((state) => state.backspace);
    const isRadiansEnabled = useCalcStore((state) => state.usingRadians);
    const toggleRadians = useCalcStore((state) => state.toggleRadians);

    const click = (token: Token) => () => addToken(token)

    const renderTokenList = (tokens: Token[]): JSX.Element[] =>
        tokens.map(token =>
            <Button
                onClick={click(token)}
                icon={token.icon}
            />
        )

    return (
        <div className="grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg">
            <Button onClick={runClearAll} icon="CA" />
            <Button onClick={runClear} icon="C" />
            <Button onClick={runBackspace} icon="<=" />
            <Button icon={<FaRecycle />} />
            <Button onClick={toggleRadians} icon={isRadiansEnabled ? "Rad" : "Deg"} />
            {renderTokenList(isRadiansEnabled ? trigTokens : degreeTrigTokens)}
            {renderTokenList(otherTokens)}
            <div />
            <div />
            <div />
            <Button onClick={runEquals} icon={<FaEquals />} />
        </div>
    );
};

export default Calculator;


const trigTokens: Tokens.UnaryOpToken[] = [
    Tokens.sin,
    Tokens.cos,
    Tokens.tan
]

const degreeTrigTokens: Tokens.UnaryOpToken[] = [
    Tokens.sinDeg,
    Tokens.cosDeg,
    Tokens.tanDeg
]

const otherTokens: Token[] = [
    Tokens.naturalLog,
    Tokens.log,
    Tokens.squareRoot,
    Tokens.bracket,
    Tokens.modulus,
    Tokens.factorial,
    Tokens.divide,
    Tokens.seven,
    Tokens.eight,
    Tokens.nine,
    Tokens.multiply,
    Tokens.e,
    Tokens.four,
    Tokens.five,
    Tokens.six,
    Tokens.subtract,
    Tokens.exponent,
    Tokens.one,
    Tokens.two,
    Tokens.three,
    Tokens.add,
    Tokens.squared,
    Tokens.zero
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
