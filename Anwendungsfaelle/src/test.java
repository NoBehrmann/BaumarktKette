

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class test {

    private static final String host = "dmg.th-luebeck.de";
    private static final String port = "3306";
    private static final String database = "INF1_Gruppe02";
    private static final String username = "INF1_Gruppe02";
    private static final String password = "XxDKC9WOUKEJ";

    private static Connection conn;

    public static boolean isConnected() {
        return (conn != null);
    }

    public static void connect() throws ClassNotFoundException {

        if(!isConnected()) {

            try {

                Class.forName("org.mariadb.jdbc.Driver");

                conn = DriverManager.getConnection("jdbc:mariadb:// "+ host + ":" + port + "/" + database, username, password);
                System.out.println("[MySQL] Verbunden!");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void disconnect() {
        if(isConnected()) {
            try {
                conn.close();
                System.out.println("[MySQL] Verbindung geschlossen!");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void select(String artikel) {

        try {
            Statement stmt = conn.createStatement();
            String sql = "SELECT * FROM artikel WHERE artikelName like '%" + artikel + "%' GROUP BY idArtikel";
            ResultSet res = stmt.executeQuery(sql);
            System.out.format("%-15s%-20s%-40s%-15s%-25s%s\n", "idArtikel", "idArtikelTyp", "Artikelname", "Gewicht", "Material", "Preis");
            while (res.next()) {
                int id = res.getInt("idArtikel");
                int idTyp = res.getInt("idArtikelTyp");
                String artikelName = res.getString("artikelName");
                double gewicht = res.getDouble("gewichtInKilos");
                String material = res.getString("material");
                double preis = res.getDouble("verkaufspreis");
                System.out.format("%-15d%-20d%-40s%-15.2f%-25s%.2f\n", id, idTyp, artikelName, gewicht, material, preis);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }
}
