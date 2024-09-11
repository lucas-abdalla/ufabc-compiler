grammar Grammar;

@header {
    import java.util.ArrayList;
    import java.util.HashMap;
    import java.util.HashSet;
    import java.util.Stack;
    import io.compiler.types.*;
    import io.compiler.core.exceptions.*;
    import io.compiler.core.ast.*;
}

@members {
    private HashMap<String, Var> symbolTable = new HashMap<>();
    private HashSet<String> usedVariables = new HashSet<>();
    private ArrayList<Var> currentDecl = new ArrayList<>();
    private Types currentType;
    private Types leftType = null, rightType = null;
    private Program program = new Program();
    private Stack<String> strExprStack = new Stack<>();
    private Stack<IfCommand> ifCommandStack = new Stack<>();
    private Stack<AttributeCommand> attribCommandStack = new Stack<>();
    private Stack<WhileCommand> whileCommandStack = new Stack<>();
    private Stack<DoWhileCommand> doWhileCommandStack = new Stack<>();
    private Stack<ArrayList<Command>> stack = new Stack<>();

    public void updateType() {
        for (Var v : currentDecl) {
            v.setType(currentType);
            symbolTable.put(v.getId(), v);
        }
    }

    public void checkUnusedVariables() {
        for (String id : symbolTable.keySet()) {
            if (!usedVariables.contains(id)) {
                System.out.println("Warning: Variable " + id + " declared but not used.");
            }
        }
    }

    public void checkUninitializedVariables() {
        for (String id : symbolTable.keySet()) {
            if (!symbolTable.get(id).isInitialized()) {
                System.out.println("Warning: Variable " + id + " declared but not initialized.");
            }
        }
    }

    public Program getProgram() {
        return this.program;
    }

    public boolean isDeclared(String id) {
        return symbolTable.get(id) != null;
    }
}

programa : 'programa' ID 
            { program.setName(_input.LT(-1).getText()); stack.push(new ArrayList<Command>()); strExprStack.push(""); }
            declaravar+
            'inicio'
            comando+
            'fim'
            'fimprog'
            { 
                checkUnusedVariables();
                checkUninitializedVariables();
                program.setSymbolTable(symbolTable);
                program.setCommandList(stack.pop());
            }
          ;

declaravar : 'declare' { currentDecl.clear(); } 
              ID { currentDecl.add(new Var(_input.LT(-1).getText())); }
              ( VIRG ID { currentDecl.add(new Var(_input.LT(-1).getText())); } )* 
              DP 
              ( 'number' { currentType = Types.NUMBER; } 
              | 'text' { currentType = Types.TEXT; } ) 
              { updateType(); } 
              PV
            ;

comando : cmdAttrib
        | cmdLeitura
        | cmdEscrita
        | cmdIF
        | cmdWhile
        | cmdDoWhile
        ;

cmdIF : 'se' { stack.push(new ArrayList<Command>()); strExprStack.push(""); ifCommandStack.push(new IfCommand()); } 
         AP expr OPREL { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } expr FP 
         { ifCommandStack.peek().setExpression(strExprStack.pop()); }
         'entao' comando+ 
         { ifCommandStack.peek().setTrueList(stack.pop()); } 
         ( 'senao' { stack.push(new ArrayList<Command>()); } comando+ 
         { ifCommandStack.peek().setFalseList(stack.pop()); } )? 
         'fimse' 
         { stack.peek().add(ifCommandStack.pop()); }
       ;

cmdWhile : 'enquanto' { stack.push(new ArrayList<Command>()); strExprStack.push(""); whileCommandStack.push(new WhileCommand()); } 
            AP expr OPREL { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } expr FP 
            { whileCommandStack.peek().setExpression(strExprStack.pop()); }
            '{' comando+ 
            { whileCommandStack.peek().setCommands(stack.pop()); } 
            '}' 
            { stack.peek().add(whileCommandStack.pop()); }
          ;

cmdDoWhile : 'faca' { stack.push(new ArrayList<Command>()); strExprStack.push(""); doWhileCommandStack.push(new DoWhileCommand()); } 
              '{' comando+ 
              { doWhileCommandStack.peek().setCommands(stack.pop()); } 
              '}' 'enquanto' AP expr OPREL { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } expr FP 
              { doWhileCommandStack.peek().setExpression(strExprStack.pop()); } 
              PV 
              { stack.peek().add(doWhileCommandStack.pop()); }
            ;

cmdAttrib : ID { if (!isDeclared(_input.LT(-1).getText())) { throw new UFABCSemanticException("Undeclared Variable: " + _input.LT(-1).getText()); } 
                   symbolTable.get(_input.LT(-1).getText()).setInitialized(true); 
                   leftType = symbolTable.get(_input.LT(-1).getText()).getType(); 
                   strExprStack.push(""); 
                   attribCommandStack.push(new AttributeCommand(symbolTable.get(_input.LT(-1).getText()).getId())); } 
              OP_AT expr { attribCommandStack.peek().setContent(strExprStack.pop()); } 
              PV 
              { if (leftType.getValue() < rightType.getValue()) { throw new UFABCSemanticException("Type Mismatch on Assignment"); } 
                stack.peek().add(attribCommandStack.pop()); }
            ;

cmdLeitura : 'leia' AP ID { if (!isDeclared(_input.LT(-1).getText())) { throw new UFABCSemanticException("Undeclared Variable: " + _input.LT(-1).getText()); } 
                              symbolTable.get(_input.LT(-1).getText()).setInitialized(true); 
                              Command cmdRead = new ReadCommand(symbolTable.get(_input.LT(-1).getText())); 
                              stack.peek().add(cmdRead); } 
                      FP PV
            ;

cmdEscrita : 'escreva' AP termo { Command cmdWrite = new WriteCommand(_input.LT(-1).getText()); stack.peek().add(cmdWrite); } FP PV 
              { rightType = null; }
            ;

expr : termo { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } exprl 
     ;

termo : ID { if (!isDeclared(_input.LT(-1).getText())) { throw new UFABCSemanticException("Undeclared Variable: " + _input.LT(-1).getText()); } 
              if (!symbolTable.get(_input.LT(-1).getText()).isInitialized()) { throw new UFABCSemanticException("Variable " + _input.LT(-1).getText() + " has no value assigned"); } 
              if (rightType == null) { rightType = symbolTable.get(_input.LT(-1).getText()).getType(); } 
              else { if (symbolTable.get(_input.LT(-1).getText()).getType().getValue() > rightType.getValue()) { rightType = symbolTable.get(_input.LT(-1).getText()).getType(); } } 
              usedVariables.add(_input.LT(-1).getText()); }
     | NUM { if (rightType == null) { rightType = Types.NUMBER; } 
             else { if (rightType.getValue() < Types.NUMBER.getValue()) { rightType = Types.NUMBER; } } }
     | TEXTO { if (rightType == null) { rightType = Types.TEXT; } 
               else { if (rightType.getValue() < Types.TEXT.getValue()) { rightType = Types.TEXT; } } }
     ;

exprl : (OP { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } termo { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); })*
      ;

OP : '+' | '-' | '*' | '/' ;
OP_AT : ':=' ;
OPREL : '>' | '<' | '>=' | '<= ' | '<>' | '==' ;
ID : [a-z] ( [a-z] | [A-Z] | [0-9] )* ;
NUM : [0-9]+ ('.' [0-9]+ )? ;
VIRG : ',' ;
PV : ';' ;
AP : '(' ;
FP : ')' ;
DP : ':' ;
TEXTO : '"' ( [a-z] | [A-Z] | [0-9] | ',' | '.' | ' ' | '-' )* '"' ;
WS : (' ' | '\n' | '\r' | '\t' ) -> skip ;
