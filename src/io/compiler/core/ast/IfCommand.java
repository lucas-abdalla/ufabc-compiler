package io.compiler.core.ast;

import java.util.List;

public class IfCommand extends Command{

    private String expression;
    private List<Command> trueList;
    private List<Command> falseList;
    

    public String getExpression() {
        return expression;
    }

    public void setExpression(String expression) {
        this.expression = expression;
    }

    public List<Command> getTrueList() {
        return trueList;
    }

    public void setTrueList(List<Command> trueList) {
        this.trueList = trueList;
    }

    public List<Command> getFalseList() {
        return falseList;
    }

    public void setFalseList(List<Command> falseList) {
        this.falseList = falseList;
    }

    public IfCommand(String expression, List<Command> trueList, List<Command> falseList) {
        this.expression = expression;
        this.trueList = trueList;
        this.falseList = falseList;
    }

    public IfCommand() {
    }

    @Override
    public String generateTargetJava() {
        StringBuilder str = new StringBuilder();
        str.append("if("+expression+"){");
        for (Command cmd : trueList) {
            str.append(cmd.generateTargetJava());
        }
        if(falseList!= null){
            if(!falseList.isEmpty()){
                str.append("} else {");
                for (Command cmd : falseList) {
                    str.append(cmd.generateTargetJava());
                }
            }
        }
        str.append("}");
        return str.toString();
    }

    @Override
    public String generateTargetC() {
        StringBuilder str = new StringBuilder();
        str.append("if("+expression+"){");
        for (Command cmd : trueList) {
            str.append(cmd.generateTargetC());
        }
        if(falseList!= null){
            if(!falseList.isEmpty()){
                str.append("} else {");
                for (Command cmd : falseList) {
                    str.append(cmd.generateTargetC());
                }
            }
        }
        str.append("}");
        return str.toString();
    }

}
