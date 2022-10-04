import useCalcStore from "../store";
import { renderExpression } from "../tokens/tokenProcessing";

interface CalculationProps {
}

const Calculation = (props: CalculationProps) => {
    const oldCalculations = useCalcStore((state) => state.oldExpressions)
    const currentExpression = useCalcStore((state) => state.currentTokens)

    return <div className="rounded-lg bg-sky-100 p-2 min-w-[30%]">
        {/* Note that this inner div is just to reverse the order of the historical
        expressions performantly, since otherwise they show in the wrong order. */}
        <div className="flex flex-col-reverse items-end">
            {oldCalculations.slice(0, 3).map(expression =>
                <p className="text-5xl m-7 text-sky-300 flex flex-row">
                    {renderExpression(expression)}
                </p>
            )}
        </div>
        <p className="text-5xl m-7 text-sky-600 text-right">
            {renderExpression(currentExpression)}
        </p>
    </div>
}

export default Calculation
