grammar Grammar;

@header {
	import java.util.ArrayList;
	import java.util.Stack;
	import java.util.HashMap;
	import io.compiler.types.*;
	import io.compiler.core.exceptions.*;
	import io.compiler.core.ast.*;
}

@members {
    private HashMap<String,Var> symbolTable = new HashMap<String, Var>();
    private ArrayList<Var> currentDecl = new ArrayList<Var>();
    private Types currentType;
    private Types leftType=null, rightType=null;
    private Program program = new Program();
    private Stack<String> strExprStack = new Stack<>();
    private Stack<IfCommand> ifCommandStack = new Stack<>();
    private Stack<AttributeCommand> attribCommandStack = new Stack<>();
    private Stack<WhileCommand> whileCommandStack = new Stack<>();
    private Stack<DoWhileCommand> doWhileCommandStack = new Stack<>();
    
    private Stack<ArrayList<Command>> stack = new Stack<ArrayList<Command>>();
    
    
    public void updateType(){
    	for(Var v: currentDecl){
    	   v.setType(currentType);
    	   symbolTable.put(v.getId(), v);
    	}
    }
    public void exibirVar(){
        for (String id: symbolTable.keySet()){
        	System.out.println(symbolTable.get(id));
        }
    }
    
    public Program getProgram(){
    	return this.program;
    	}
    
    public boolean isDeclared(String id){
    	return symbolTable.get(id) != null;
    }
}
 
programa	: 'programa' ID  { program.setName(_input.LT(-1).getText());
                               stack.push(new ArrayList<Command>());
                               strExprStack.push("");
                             }
               declaravar+
               'inicio'
               comando+
               'fim'
               'fimprog'
               
               {
                  program.setSymbolTable(symbolTable);
                  program.setCommandList(stack.pop());
               }
			;
						
declaravar	: 'declare' { currentDecl.clear(); } 
               ID  { currentDecl.add(new Var(_input.LT(-1).getText()));}
               ( VIRG ID                
              		 { currentDecl.add(new Var(_input.LT(-1).getText()));}
               )*	 
               DP 
               (
               'number' {currentType = Types.NUMBER;}
               |
               'text' {currentType = Types.TEXT;}
               ) 
               
               { updateType(); } 
               PV
			;
			
comando     :  cmdAttrib
			|  cmdLeitura
			|  cmdEscrita
			|  cmdIF
         |  cmdWhile
         |  cmdDoWhile
			;
			
cmdIF		: 'se'  { stack.push(new ArrayList<Command>());
                     strExprStack.push("");
                     ifCommandStack.push(new IfCommand());
                    } 
               AP 
               expr
               OPREL  { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText());}
               expr 
               FP  { ifCommandStack.peek().setExpression(strExprStack.pop()); }
               'entao'  
               comando+                
               { 
                  ifCommandStack.peek().setTrueList(stack.pop());                            
               }  
               ( 'senao'  
                  { stack.push(new ArrayList<Command>()); }
                 comando+
                 {
                   ifCommandStack.peek().setFalseList(stack.pop());
                 }  
               )? 
               'fimse' 
               {
               	   stack.peek().add(ifCommandStack.pop());
               }  			   
			;

cmdWhile	   : 'enquanto'  { stack.push(new ArrayList<Command>());
                      strExprStack.push("");
                      whileCommandStack.push(new WhileCommand());
                    }
                  AP 
                  expr
                  OPREL  { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText());}
                  expr 
                  FP  { whileCommandStack.peek().setExpression(strExprStack.pop()); }
                  '{'
                     comando+
                        {
                           whileCommandStack.peek().setCommands(stack.pop());
                        }  
                  '}'
                        {
               	         stack.peek().add(whileCommandStack.pop());
                        }  
		   
			;

cmdDoWhile	   : 'faca'  { stack.push(new ArrayList<Command>());
               strExprStack.push("");
               doWhileCommandStack.push(new DoWhileCommand());
            }
         '{'
            comando+
               {
                  doWhileCommandStack.peek().setCommands(stack.pop());
               }  
         '}'
         'enquanto'
         AP 
         expr
         OPREL  { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText());}
         expr 
         FP  { doWhileCommandStack.peek().setExpression(strExprStack.pop()); }
               {
                  stack.peek().add(doWhileCommandStack.pop());
               }
         PV

;

			
cmdAttrib   : ID { if (!isDeclared(_input.LT(-1).getText())) {
                       throw new UFABCSemanticException("Undeclared Variable: "+_input.LT(-1).getText());
                   }
                   symbolTable.get(_input.LT(-1).getText()).setInitialized(true);
                   leftType = symbolTable.get(_input.LT(-1).getText()).getType();
                   strExprStack.push("");
                   attribCommandStack.push(new AttributeCommand(symbolTable.get(_input.LT(-1).getText()).getId()));
                 }
              OP_AT 
              expr {attribCommandStack.peek().setContent(strExprStack.pop());}
              PV
              {
                 if(leftType.getValue() < rightType.getValue()){
                    throw new UFABCSemanticException("Type Mismatchig on Assignment");
                 }
                 stack.peek().add(attribCommandStack.pop());
              }
			;			
			
cmdLeitura  : 'leia' AP 
               ID { if (!isDeclared(_input.LT(-1).getText())) {
                       throw new UFABCSemanticException("Undeclared Variable: "+_input.LT(-1).getText());
                    }
                    symbolTable.get(_input.LT(-1).getText()).setInitialized(true);
                    Command cmdRead = new ReadCommand(symbolTable.get(_input.LT(-1).getText()));
                    stack.peek().add(cmdRead);
                  } 
               FP 
               PV 
			;
			
cmdEscrita  : 'escreva' AP 
              ( termo  { Command cmdWrite = new WriteCommand(_input.LT(-1).getText());
                         stack.peek().add(cmdWrite);
                       } 
              ) 
              FP PV { rightType = null;}
			;			

			
expr		:  termo  { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText());} exprl 			
			;
			
termo		: ID  { if (!isDeclared(_input.LT(-1).getText())) {
                       throw new UFABCSemanticException("Undeclared Variable: "+_input.LT(-1).getText());
                    }
                    if (!symbolTable.get(_input.LT(-1).getText()).isInitialized()){
                       throw new UFABCSemanticException("Variable "+_input.LT(-1).getText()+" has no value assigned");
                    }
                    if (rightType == null){
                       rightType = symbolTable.get(_input.LT(-1).getText()).getType();
                       //System.out.println("Encontrei pela 1a vez uma variavel = "+rightType);
                    }   
                    else{
                       if (symbolTable.get(_input.LT(-1).getText()).getType().getValue() > rightType.getValue()){
                          rightType = symbolTable.get(_input.LT(-1).getText()).getType();
                          //System.out.println("Ja havia tipo declarado e mudou para = "+rightType);
                          
                       }
                    }
                  }   
			| NUM    {  if (rightType == null) {
			 				rightType = Types.NUMBER;
			 				//System.out.println("Encontrei um numero pela 1a vez "+rightType);
			            }
			            else{
			                if (rightType.getValue() < Types.NUMBER.getValue()){			                    			                   
			                	rightType = Types.NUMBER;
			                	//System.out.println("Mudei o tipo para Number = "+rightType);
			                }
			            }
			         }
			| TEXTO  {  if (rightType == null) {
			 				rightType = Types.TEXT;
			 				//System.out.println("Encontrei pela 1a vez um texto ="+ rightType);
			            }
			            else{
			                if (rightType.getValue() < Types.TEXT.getValue()){			                    
			                	rightType = Types.TEXT;
			                	//System.out.println("Mudei o tipo para TEXT = "+rightType);
			                	
			                }
			            }
			         }
			;
			
exprl		: ( OP { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } 
                termo { strExprStack.push(strExprStack.pop() + _input.LT(-1).getText()); } 
              ) *
			;	
			
OP			: '+' | '-' | '*' | '/' 
			;	
			
OP_AT	    : ':='
		    ;
		    
OPREL       : '>' | '<' | '>=' | '<= ' | '<>' | '=='
			;		    			
			
ID			: [a-z] ( [a-z] | [A-Z] | [0-9] )*		
			;
			
NUM			: [0-9]+ ('.' [0-9]+ )?
			;			
			
VIRG		: ','
			;
						
PV			: ';'
            ;			
            
AP			: '('
			;            
						
FP			: ')'
			;
									
DP			: ':'
		    ;
		    
TEXTO       : '"' ( [a-z] | [A-Z] | [0-9] | ',' | '.' | ' ' | '-' )* '"'
			;		    
		    			
WS			: (' ' | '\n' | '\r' | '\t' ) -> skip
			;