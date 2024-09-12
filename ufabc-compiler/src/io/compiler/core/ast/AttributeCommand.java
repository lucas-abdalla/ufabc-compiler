package io.compiler.core.ast;

public class AttributeCommand extends Command{
    private String varId;
    private String content;

    public String getVarId() {
        return varId;
    }

    public void setVarId(String varId) {
        this.varId = varId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    

    public AttributeCommand(String varId, String content) {
        this.varId = varId;
        this.content = content;
    }

    public AttributeCommand(String varId) {
        this.varId = varId;
    }

    public AttributeCommand() {
    }

    @Override
    public String generateTargetJava() {
        return this.getVarId() + " = "+ this.getContent() + ";\n";
    }

    @Override
    public String generateTargetC() {
        return generateTargetJava();
    }
}
