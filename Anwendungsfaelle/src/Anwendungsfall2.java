import java.sql.*;

// Zeigt wie viele einträge es über den input gibt.
public class Anwendungsfall2 {
    public static void anwendungsfall3(Connection con, String input) throws SQLException {
        try {
            CallableStatement call = con.prepareCall("{CALL stammkundenNamen(?,?)}");

            call.setString(1, input);

            call.registerOutParameter(2, Types.INTEGER);

            ResultSet st = call.executeQuery();

            st.next();

            int rs = call.getInt(2);

            System.out.println("Es gibt " + rs + " mit dem namen " + input + ".");

            call.close();

        } catch (SQLException e) {
            con.rollback();
        }
    }
}
