package io.compiler.main;

import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.CharStreams;
import io.compiler.core.GrammarLexer;
import io.compiler.core.GrammarParser;
import io.compiler.core.ast.Program;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

public class MainClass {
    public static void main(String[] args) {
        /*if (args.length != 1) {
            System.err.println("Usage: java MainClass <file-path>");
            System.exit(1);
        }

        String filePath = args[0];*/

        try {
            GrammarLexer lexer = new GrammarLexer(CharStreams.fromFileName("/home/lucasabdalla/Documentos/GitHub/ufabc-compiler/inputs/teste.in"));
            CommonTokenStream tokenStream = new CommonTokenStream(lexer);
            GrammarParser parser = new GrammarParser(tokenStream);

            System.out.println("UFABC Compiler");
            parser.programa();
            System.out.println("Compilation Successfully - Good Job");

            Program program = parser.getProgram();

            try {
                File javaFile = new File(program.getName() + ".java");
                FileWriter javaWriter = new FileWriter(javaFile);
                PrintWriter javaPrinter = new PrintWriter(javaWriter);
                javaPrinter.println(program.generateTargetJava());
                javaPrinter.close();

                File cFile = new File(program.getName() + ".c");
                FileWriter cWriter = new FileWriter(cFile);
                PrintWriter cPrinter = new PrintWriter(cWriter);
                cPrinter.println(program.generateTargetC());
                cPrinter.close();

            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (Exception ex) {
            System.err.println("Error: " + ex.getMessage());
        }
    }
}
