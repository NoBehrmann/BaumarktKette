import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

// insertet einen neuen artikel in die datenbank
public class Anwendungsfall1 {
    public static void anwendungsfall1(Connection conn) throws SQLException, ClassNotFoundException {
        try {

            conn.setAutoCommit(false);

            artikel artikel = new artikel(3, "Seiten Hammer", 22.3);
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO artikel (idArtikelTyp, artikelName, verkaufspreis) VALUES (?, ?, ?)");
            stmt.setInt(1, artikel.idArtikel);
            stmt.setString(2, artikel.artikelName);
            stmt.setDouble(3, artikel.verkaufspreis);
            stmt.executeUpdate();


            conn.commit();

            System.out.println("Success");

        } catch (SQLException e) {

            conn.rollback();
        }
    }
}