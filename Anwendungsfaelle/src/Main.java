import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main {
    private static final String url = "jdbc:mariadb://Data bank here";
    private static final String user = "UserName";
    private static final String password = "myPassword";
    // input for anwendungsfall2
    private static final String input = "Sheena";


    public static void main(String[] args) throws SQLException, ClassNotFoundException {
        Connection con = DriverManager.getConnection(url, user, password);
        Class.forName("org.mariadb.jdbc.Driver");

        Anwendungsfall1.anwendungsfall1(con);
        Anwendungsfall2.anwendungsfall3(con,input);

    }
}