import Calculation from "./components/Calculation";
import Calculator from "./components/Calculator";

export function App() {
    return (
        <div className="h-screen w-screen bg-slate-600 flex items-center justify-evenly">
            <Calculation />
            <Calculator />
        </div>
    );
}
