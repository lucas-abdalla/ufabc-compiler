package io.compiler.core.ast;

import java.util.List;

public class DoWhileCommand extends Command{
    private String expression;
    private List<Command> while_Commands;

    public String getExpression() {
        return expression;
    }

    public void setExpression(String expression) {
        this.expression = expression;
    }

    public List<Command> getCommands() {
        return while_Commands;
    }

    public void setCommands(List<Command> while_Commands) {
        this.while_Commands = while_Commands;
    }


    public DoWhileCommand(String expression, List<Command> while_Commands) {
        this.expression = expression;
        this.while_Commands = while_Commands;
  
    }

    public DoWhileCommand() {
    }

    @Override
    public String generateTargetJava() {
        StringBuilder str = new StringBuilder();
        str.append("do {");
        for (Command cmd : while_Commands) {
            str.append(cmd.generateTargetJava());
        }
        str.append("} while("+expression+"); \n");
        return str.toString();
    }

    @Override
    public String generateTargetC() {
        StringBuilder str = new StringBuilder();
        str.append("do {");
        for (Command cmd : while_Commands) {
            str.append(cmd.generateTargetC());
        }
        str.append("} while("+expression+"); \n");
        return str.toString();
    }
}
