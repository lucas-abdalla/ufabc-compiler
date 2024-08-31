// Generated from /home/cortes/Documents/UFABC/Compiladores/Compiler/ufabc-compiler/Grammar.g4 by ANTLR 4.13.1

	import java.util.ArrayList;
	import java.util.Stack;
	import java.util.HashMap;
	import io.compiler.types.*;
	import io.compiler.core.exceptions.*;
	import io.compiler.core.ast.*;

import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link GrammarParser}.
 */
public interface GrammarListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link GrammarParser#programa}.
	 * @param ctx the parse tree
	 */
	void enterPrograma(GrammarParser.ProgramaContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#programa}.
	 * @param ctx the parse tree
	 */
	void exitPrograma(GrammarParser.ProgramaContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#declaravar}.
	 * @param ctx the parse tree
	 */
	void enterDeclaravar(GrammarParser.DeclaravarContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#declaravar}.
	 * @param ctx the parse tree
	 */
	void exitDeclaravar(GrammarParser.DeclaravarContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#comando}.
	 * @param ctx the parse tree
	 */
	void enterComando(GrammarParser.ComandoContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#comando}.
	 * @param ctx the parse tree
	 */
	void exitComando(GrammarParser.ComandoContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#cmdIF}.
	 * @param ctx the parse tree
	 */
	void enterCmdIF(GrammarParser.CmdIFContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#cmdIF}.
	 * @param ctx the parse tree
	 */
	void exitCmdIF(GrammarParser.CmdIFContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#cmdAttrib}.
	 * @param ctx the parse tree
	 */
	void enterCmdAttrib(GrammarParser.CmdAttribContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#cmdAttrib}.
	 * @param ctx the parse tree
	 */
	void exitCmdAttrib(GrammarParser.CmdAttribContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#cmdLeitura}.
	 * @param ctx the parse tree
	 */
	void enterCmdLeitura(GrammarParser.CmdLeituraContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#cmdLeitura}.
	 * @param ctx the parse tree
	 */
	void exitCmdLeitura(GrammarParser.CmdLeituraContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#cmdEscrita}.
	 * @param ctx the parse tree
	 */
	void enterCmdEscrita(GrammarParser.CmdEscritaContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#cmdEscrita}.
	 * @param ctx the parse tree
	 */
	void exitCmdEscrita(GrammarParser.CmdEscritaContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExpr(GrammarParser.ExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExpr(GrammarParser.ExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#termo}.
	 * @param ctx the parse tree
	 */
	void enterTermo(GrammarParser.TermoContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#termo}.
	 * @param ctx the parse tree
	 */
	void exitTermo(GrammarParser.TermoContext ctx);
	/**
	 * Enter a parse tree produced by {@link GrammarParser#exprl}.
	 * @param ctx the parse tree
	 */
	void enterExprl(GrammarParser.ExprlContext ctx);
	/**
	 * Exit a parse tree produced by {@link GrammarParser#exprl}.
	 * @param ctx the parse tree
	 */
	void exitExprl(GrammarParser.ExprlContext ctx);
}