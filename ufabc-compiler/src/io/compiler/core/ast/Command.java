package io.compiler.core.ast;

public abstract class Command {
    public abstract String generateTargetJava();
    public abstract String generateTargetC(); 
}
