import { List, Stack } from "immutable";
import { Token, BinaryOpToken, ValueToken, mkValue, combineValues } from "./tokens";

/**
* Render a list of tokens as a string which can be easily understood
* by a user.
*/
export const renderExpression = (expression: List<Token>): string =>
    expression.reduce((x, y) => x + y.value, "");


/**
* A Node in a mathematical expression tree. The tree is intended for
* evaluation, where nodes lower in the tree represent calculations which
* must be processed before their parents.
*/
type Node = {
    op: BinaryOpToken;
    left: Node;
    right: Node;
} | {
    op: "none";
    value: ValueToken;
};

/**
* Evaluate the value of a maths expression represented by a list of tokens.
*/
export const evaluateTokens = (tokens: List<Token>): number =>
    evalOperationTree(buildOperationTree(tokens))

/**
* Evaluate the result of an expression tree, where child nodes are evaluated
* before their parents.
*/
const evalOperationTree = (root: Node): number => {
    if (root.op === 'none')
        return root.value.value;

    return root.op.apply(
        evalOperationTree(root.left),
        evalOperationTree(root.right),
    )
};

/**
* Build a tree of binary operations where higher-priority operations are
* found closer to the leaves of the tree.
*/
const buildOperationTree = (tokens: List<Token>): Node => {
    let stack = tokens.toStack();

    let root: Node = { op: "none", value: nextNumber(stack) }
    stack = stack.skipWhile(t => t.type === 'value');

    while (!stack.isEmpty()) {

        const nextOp = stack.peek();
        stack = stack.pop();

        // Binary operation, followed by a number
        if (nextOp?.type === 'binary-op') {
            const num = nextNumber(stack);
            stack = stack.skipWhile(t => t.type === 'value');

            root = processNextOp(root, nextOp, num);
            continue;
        }

        //if (nextOp?.type === 'left-unary-op') {
        //    root = processNextOp(root, nextOp, num);
        //}
    }

    return root;
};

/** 
* Add a new operation to the tree.
*/
const processNextOp = (root: Node, nextOp: BinaryOpToken, nextVal: ValueToken): Node => {
    if (root.op === 'none' || root.op.priority >= nextOp.priority) {
        return {
            op: nextOp,
            left: root,
            right: { op: "none", value: nextVal }
        };
    }

    const rightNode: Node = {
        op: nextOp,
        left: root.right,
        right: { op: "none", value: nextVal }
    };

    root.right = rightNode;

    return root;
};

/** 
* Add a new operation to the tree.
*/
const nextNumber = (stack: Stack<Token>): ValueToken =>
    stack.takeWhile(t => t.type === 'value')
        .map(t => t as ValueToken)
        .reduce(combineValues, mkValue(0))
