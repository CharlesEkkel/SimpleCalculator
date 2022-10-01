import { Token } from "./store";
import {
    FaBackspace,
    FaDivide,
    FaExclamation,
    FaMinus,
    FaPercent,
    FaPlus,
    FaRecycle,
    FaSquareRootAlt,
    FaTimes,
} from "react-icons/fa";

const renderToken = (token: Token): (JSX.Element | string) => {
    switch (token) {
        case "clear": return "C"
        case "backspace": return <FaBackspace />
        case "cycle": return <FaRecycle />
        case "sin": return "sin"
        case "cos": return "cos"
        case "tan": return "tan"
        case "natural-log": return "ln"
        case "log": return "log"
        case "toggle-radians": return "Rad"
        case "square-root": return <FaSquareRootAlt />
        case "brackets": return "()"
        case "percentage": return <FaPercent />
        case "factorial": return <FaExclamation />
        case "divide": return <FaDivide />
        case 7: return "7"
        case 8: return "8"
        case 9: return "9"
        case "multiply": return <FaTimes />
        case "e": return "e"
        case 4: return "4"
        case 5: return "5"
        case 6: return "6"
        case "subtract": return <FaMinus />
        case "exponent": return "x^y"
        case 1: return "1"
        case 2: return "2"
        case 3: return "3"
        case "add": return <FaPlus />
        case "squared": return "x^2"
        case "toggle-polarity": return "+-"
        case 0: return "0"
        case "decimal-point": return "."
    }
}

export default renderToken;
