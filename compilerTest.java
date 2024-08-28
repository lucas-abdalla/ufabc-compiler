import java.util.Scanner;

public class compilerTest {
    public static void main(String[] args) {
        Scanner _scTrx = new Scanner(System.in);
        int a;
        int b;
        System.out.println("Hello World");
        System.out.println("Fim do programa");
        a = _scTrx.nextInt();
        b = _scTrx.nextInt();
        System.out.println(a);
        if (a > 5) {
            System.out.println("maior que 5");
        } else {
            System.out.println("menor que 5");
        }
        System.out.println("oi agora vamos testar outro");
        if (b >= 0) {
            System.out.println("b positivo");
        } else {
            System.out.println("b negativo");
        }
        _scTrx.close();
    }
}
