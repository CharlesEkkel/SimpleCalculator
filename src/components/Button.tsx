import { IconContext } from "react-icons/lib";

interface ButtonProps {
    onClick?: () => void;
    value: JSX.Element | string;
}

const Button = (props: ButtonProps) => (
    <button className="flex items-center justify-center p-4 m-1 text-sky-500 font-bold
        rounded-md hover:bg-sky-200 active:bg-sky-300">
        <IconContext.Provider value={{ className: "fill-sky-500" }}>
            {props.value}
        </IconContext.Provider>
    </button>
);

export default Button;
