import {
    FaBackspace,
    FaDivide,
    FaEquals,
    FaExclamation,
    FaMinus,
    FaPercent,
    FaPlus,
    FaRecycle,
    FaSquareRootAlt,
    FaTimes,
} from "react-icons/fa";
import Button from "./Button";

interface CalculatorProps {}

const Calculator = (props: CalculatorProps) => {
    return (
        <div className="grid grid-cols-5 grid-rows-7 bg-sky-100 rounded-lg">
            <div />
            <div />
            <Button value={"C"} />
            <Button value={<FaBackspace />} />
            <Button value={<FaRecycle />} />
            <Button value={"sin"} />
            <Button value={"cos"} />
            <Button value={"tan"} />
            <Button value={"ln"} />
            <Button value={"log"} />
            <Button value={"Rad"} />
            <Button value={<FaSquareRootAlt />} />
            <Button value={"()"} />
            <Button value={<FaPercent />} />
            <Button value={<FaExclamation />} />
            <Button value={<FaDivide />} />
            <Button value={"7"} />
            <Button value={"8"} />
            <Button value={"9"} />
            <Button value={<FaTimes />} />
            <Button value={"e"} />
            <Button value={"4"} />
            <Button value={"5"} />
            <Button value={"6"} />
            <Button value={<FaMinus />} />
            <Button value={"x^y"} />
            <Button value={"1"} />
            <Button value={"2"} />
            <Button value={"3"} />
            <Button value={<FaPlus />} />
            <Button value={"x^2"} />
            <Button value={"+-"} />
            <Button value={"0"} />
            <Button value={"."} />
            <Button value={<FaEquals />} />
        </div>
    );
};

export default Calculator;
