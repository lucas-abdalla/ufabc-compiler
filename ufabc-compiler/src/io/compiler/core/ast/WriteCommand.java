package io.compiler.core.ast;

public class WriteCommand extends Command{
    private String content;

    @Override
    public String generateTargetC() {
        return "printf("+content+");\n";
    }

    @Override
    public String generateTargetJava() {
        return "System.out.println("+content+");\n";
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public WriteCommand(String content) {
        super();
        this.content = content;
    }

    public WriteCommand() {
        super();
    }

    
}
