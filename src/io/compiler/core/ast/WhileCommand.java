package io.compiler.core.ast;

import java.util.List;

public class WhileCommand extends Command{

    private String expression;
    private List<Command> while_Commands;

    public String getExpression() {
        return expression;
    }

    public void setExpression(String expression) {
        this.expression = expression;
    }

    public List<Command> setCommands() {
        return while_Commands;
    }

    public void setCommands(List<Command> while_Commands) {
        this.while_Commands = while_Commands;
    }


    public WhileCommand(String expression, List<Command> while_Commands) {
        this.expression = expression;
        this.while_Commands = while_Commands;
  
    }

    public WhileCommand() {
    }

    @Override
    public String generateTargetJava() {
        StringBuilder str = new StringBuilder();
        str.append("while("+expression+"){");
        for (Command cmd : while_Commands) {
            str.append(cmd.generateTargetJava());
        }
        str.append("}");
        return str.toString();
    }

    @Override
    public String generateTargetC() {
        StringBuilder str = new StringBuilder();
        str.append("while("+expression+"){");
        for (Command cmd : while_Commands) {
            str.append(cmd.generateTargetC());
        }
        str.append("}");
        return str.toString();
    }

}
