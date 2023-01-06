import { List, Stack } from "immutable";
import { match, P } from "ts-pattern";
import * as E from 'fp-ts/Either';
import { Token, BinaryOpToken, ValueToken, mkValue, combineValues , UnaryOpToken, isUnary, zero, identity} from "./tokens";

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
    kind: 'binary';
    op: BinaryOpToken;
    left: Node;
    right: Node | null;
} | {
    kind: 'unary';
    op: UnaryOpToken;
    child: Node | null;
} | {
    kind: 'value';
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
const evalOperationTree = (node: Node | null): number => 
    match(node)
        .with(null, () => 0)
        .with({kind: 'value'}, (n) => n.value.value)
        .with({kind: 'unary'}, (n) => n.op.apply(evalOperationTree(n.child)))
        .with({kind: 'binary'}, (n) => 
            n.op.apply(
                evalOperationTree(n.left),
                evalOperationTree(n.right))
            )
        .exhaustive()

/**
* Build a tree of binary operations where higher-priority operations are
* found closer to the leaves of the tree.
*/
const buildOperationTree = (tokens: List<Token>): Node =>
    //tokens.reduce(processNextToken, mkValueNode(zero))
    tokens.reduce((x, _) => x, mkValueNode(zero))

    //let root: Node = { kind: 'value', value: nextNumber(stack) }
    //stack = stack.skipWhile(t => t.type === 'value');

    //while (!stack.isEmpty()) {

    //    stack.peek()

    //    const nextAction = stateToAction(stack, , 

    //    stack = stack.pop();

    //    // Binary operation, followed by a number
    //    if (nextOp?.type === 'binary-op') {
    //        const num = nextNumber(stack);
    //        stack = stack.skipWhile(t => t.type === 'value');

    //        root = processNextOp(root, nextOp, num);
    //        continue;
    //    }

    //    if (nextOp?.type === 'left-unary-op') {
    //        root = processNextOp(root, nextOp, num);
    //    }
    //}

    //return root;

//const splitByBrackets = (tokens: Stack<Token>, level: number): [Node, Stack<Token>] => {
//    return match(tokens.peek())
//        .with(
//            {type: "bracket-left"},
//            (_) => {
//
//                const [child, nextTokens] = splitByBrackets(tokens.pop(), level+1)
//
//                const parent = {
//                    kind: 'unary',
//                    op: identity, 
//                    child: child
//                }
//
//                return [parent, nextTokens]
//            }
//        )
//        .with(
//            {type: "bracket-right"},
//            (_) => {
//                
//
//            }
//        )
//};
    

type State = [Stack<Token>, Node];

/**
* Add a token to a list of tokens in such a way that respects the idiosyncracies
* of how tokens interact.
*/
const addToken = (stack: Stack<Token>, bracketCount: number, currNode: Node, upperPriority?: number): E.Either<string, [Stack<Token>, Node]> =>
    match<[Token | undefined, Node], E.Either<string, [Stack<Token>, Node]>>([stack.peek(), currNode])
        
        // BASE CASE: Empty stack
        .with(
            [undefined, P._], 
            ([_, node]) => E.right([stack, node])
        )

        // VALUE TOKENS
        .with(
            [{type: "value"}, {kind: "binary"}], 
            ([token, node]) => 
                addToken(stack.pop(), bracketCount, {
                    ...node,
                    right: mkValueNode(token)
                })
        )
        .with(
            [{type: "value"}, {kind: "unary"}], 
            ([token, node]) => 
                addToken(stack.pop(), bracketCount, {
                    ...node,
                    child: mkValueNode(token)
                })
        )
        .with(
            [{type: "value"}, {kind: 'value'}], 
            ([token, node]) => 
                E.left(`Parsing error: Values '${token.value}' and '${node.value.value}' adjacent without an operator.`)
        )

        // LEFT BRACKETS
        .with(
            [{type: "bracket-left"}, {kind: "binary"}], 
            ([_, node]) => (
                E.map(
                    (([newStack, newNode]: State) => [newStack, {
                        ...node,
                        right: newNode
                    }] as State)
                )(addToken(stack.pop(), bracketCount + 1, mkUnaryNode(identity)))
            )
        )

        .with(
            [{type: "bracket-left"}, {kind: "unary"}], 
            ([_, node]) => (
                E.map(
                    (([newStack, newNode]: State) => [newStack, {
                        ...node,
                        child: newNode
                    }] as State)
                )(addToken(stack.pop(), bracketCount + 1, mkUnaryNode(identity)))
            )
        )
        .with(
            [{type: "bracket-left"}, {kind: "value"}],
            ([_, node]) =>
                E.left(`Parsing error: Left bracket is to the right of a number, '${node.value.value}`)
        )

        // RIGHT BRACKETS
        .with(
            [{type: "bracket-right"}, P._], 
            ([_, node]) =>
                E.right([stack.pop(), node])
        )

        // BINARY OPERATORS
        .with(
            [{type: "binary-op"}, {kind: "value"}], 
            [{type: "binary-op"}, {kind: "unary"}], 
            ([token, node]) =>
                addToken(stack.pop(), bracketCount,
                    {
                        kind: "binary",
                        op: token,
                        left: node,
                        right: null
                    }
                )
        )

        .with(
            [{type: "binary-op"}, {kind: "binary"}], 
            ([token, node]) => {
                if (token.priority >= node.op.priority) {
                    return addToken(stack.pop(), bracketCount,
                        {
                            kind: "binary",
                            op: token,
                            left: node,
                            right: null
                        }
                    )
                } else { 
                    const isBinaryWithLowerPriority = (t: Token) => t.type === 'binary-op' && t.priority <= token.priority;
                    const miniStack = stack.takeUntil(isBinaryWithLowerPriority);
                    const updatedStack = stack.skipUntil(isBinaryWithLowerPriority);

                    return E.chain
                        ((innerNode: Node) => addToken(updatedStack, bracketCount, {...node, right: innerNode})),
                        (addToken(miniStack, bracketCount, mkUnaryNode(identity)))
                }
            }

        )
        .run();

//        .with(
//            [{type: "left-unary-op"}, {type: "left-unary-op"}], 
//            [{type: "left-unary-op"}, {type: "bracket-left"}], 
//            [{type: "left-unary-op"}, {type: "value"}], 
//            ([_, next]) => 
//                E.right(list.push(next)))
//        .with(
//            [{type: "left-unary-op"}, P._], 
//            ([_, next]) =>
//                E.left(`Cannot insert '${next.value}' after a (leftwise) unary operator.`))
//
//        .with(
//            [{type: "right-unary-op"}, {type: "right-unary-op"}], 
//            [{type: "right-unary-op"}, {type: "binary-op"}], 
//            [{type: "right-unary-op"}, {type: "bracket-right"}], 
//            ([_, next]) => 
//                E.right(list.push(next)))
//        .with(
//            [{type: "right-unary-op"}, P._], 
//            ([_, next]) =>
//                E.left(`Cannot insert '${next.value}' after a (rightwise) unary operator.`))
//
//        .exhaustive()

/** 
* Add a new operation to the tree.
*/
const mkValueNode = (x: ValueToken): Node => ({ kind: 'value', value: x });

const mkUnaryNode = (f: UnaryOpToken): Node => ({ kind: 'unary', op: f, child: null });

/** 
* Add a new operation to the tree.
*/
const nextNumber = (stack: Stack<Token>): ValueToken =>
    stack.takeWhile(t => t.type === 'value')
        .map(t => t as ValueToken)
        .reduce(combineValues, mkValue(0))
