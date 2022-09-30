interface CalculationProps {
    historicalCalc: string;
    currentCalc: string;
}

const Calculation = (props: CalculationProps) => {
    return <div className="rounded-lg bg-sky-100 p-2 text-right">
        <p className="text-5xl m-7 text-sky-300">{props.historicalCalc}</p>
        <p className="text-5xl m-7 text-sky-600">{props.currentCalc}</p>
    </div>
}

export default Calculation
