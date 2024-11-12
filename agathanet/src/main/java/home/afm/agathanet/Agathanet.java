/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package home.afm.agathanet;

/**
 *
 * @author mama
 */


import java.sql.*;
import java.util.Scanner;
import java.sql.SQLException;

public class Agathanet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/HOSPITAL";
    private static final String DB_USER ="root";
    private static final String DB_PASSWORD = "1234";

    public static void main(String[] args) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("¡Bienvenido al juego de detectives basado en SQL!");
            System.out.println("Ayuda a resolver el misterio de la muerte del Paciente Victor Montenegro, un empresario de 68 años que falleció por un aparente \"paro cardíaco\"..");

            
    
            // Comenzar el juego
            playGame(conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
    private static void playGame(Connection conn) {
        Scanner scanner = new Scanner(System.in);
        boolean gameOver = false;

        while (!gameOver) {
            System.out.println("\nSelecciona una opción:");
            System.out.println("1. Revisar visitas al paciente");
            System.out.println("2. Buscar tratamientos o medicaciones sospechosas");
            System.out.println("3. Descubrir un motivo oculto");
            System.out.println("4. Analizar inconsistencias");
            System.out.println("5. Resolver el misterio");
            System.out.println("6. Salir");

            int choice = scanner.nextInt();
            scanner.nextLine(); // Limpiar el buffer

            switch (choice) {
                case 1:
                    reviewVisits(conn);
                    break;
                case 2:
                    searchSuspiciousTreatments(conn);
                    break;
                case 3:
                    discoverHiddenMotives(conn);
                    break;
                case 4:
                    analyzeInconsistencies(conn);
                    break;
                case 5:
                    solveMystery(conn);
                    gameOver = true;
                    break;
                case 6:
                    System.out.println("¡Adiós!");
                    gameOver = true;
                    break;
                default:
                    System.out.println("Opción inválida. Intenta de nuevo.");
                    break;
            }
        }
    }


private static void reviewVisits(Connection conn) {
    try {
        String query = "SELECT visitante_nombre, relacion, fecha_visita " +
                       "FROM visitas " +
                       "WHERE idP = (SELECT idP FROM pacientes WHERE nombre = 'Victor Montenegro')";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("\nVisitas al paciente Paciente X:");
            System.out.println("Visitante\t Relación\t Fecha Visita");
            System.out.println("-----------------------------------------");

            while (rs.next()) {
                String visitante = rs.getString("visitante_nombre");
                String relacion = rs.getString("relacion");
                String fechaVisita = rs.getString("fecha_visita");
                System.out.printf("%-15s%-15s%s%n", visitante, relacion, fechaVisita);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

private static void searchSuspiciousTreatments(Connection conn) {
    try {
        String query = "SELECT personal_medico.nombre, tratamientos.tipo, tratamientos.fecha_tratamiento " +
                       "FROM tratamientos " +
                       "INNER JOIN personal_medico ON tratamientos.idPM = personal_medico.idPM " +
                       "WHERE idP = (SELECT idP FROM pacientes WHERE nombre = 'Victor Montenegro')";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("\nTratamientos y medicaciones del Paciente X:");
            System.out.println("Proveedor\t Tipo de Tratamiento\t Fecha");
            System.out.println("-----------------------------------------");

            while (rs.next()) {
                String proveedor = rs.getString("personal_medico.nombre");
                String tipoTratamiento = rs.getString("tratamientos.tipo");
                String fechaTratamiento = rs.getString("tratamientos.fecha_tratamiento");
                System.out.printf("%-15s%-20s%s%n", proveedor, tipoTratamiento, fechaTratamiento);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

private static void discoverHiddenMotives(Connection conn) {
    try {
        String query = "SELECT visitas.visitante_nombre, motivos_visitas.motivo " +
                       "FROM motivos_visitas " +
                       "INNER JOIN visitas ON motivos_visitas.idV = visitas.idV " +
                       "WHERE visitas.idP = (SELECT idP FROM pacientes WHERE nombre = 'Victor Montenegro')";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("\nMotivos de las visitas al Paciente X:");
            System.out.println("Visitante\t Motivo");
            System.out.println("-----------------------------------------");

            while (rs.next()) {
                String visitante = rs.getString("visitas.visitante_nombre");
                String motivo = rs.getString("motivos_visitas.motivo");
                System.out.printf("%-15s%s%n", visitante, motivo);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

private static void analyzeInconsistencies(Connection conn) {
    try {
        // Consultar si alguien del personal médico actuó fuera de su rol habitual
        String query = "SELECT personal_medico.nombre, personal_medico.tipo, tratamientos.tipo " +
                       "FROM tratamientos " +
                       "INNER JOIN personal_medico ON tratamientos.idPM = personal_medico.idPM " +
                       "WHERE idP = (SELECT idP FROM pacientes WHERE nombre = 'Victor Montenegro') " +
                       "AND personal_medico.tipo <> (CASE tratamientos.tipo " +
                                                    "WHEN 'Enfermería' THEN 'Enfermera' " +
                                                    "WHEN 'Médico' THEN 'Doctor' END)";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("\nPersonal médico con acciones fuera de su rol:");
            System.out.println("Nombre\tTipo\tTipo de Tratamiento");
            System.out.println("-----------------------------------------");

            while (rs.next()) {
                String nombre = rs.getString("personal_medico.nombre");
                String tipo = rs.getString("personal_medico.tipo");
                String tipoTratamiento = rs.getString("tratamientos.tipo");
                System.out.printf("%-15s%-10s%s%n", nombre, tipo, tipoTratamiento);
            }
        }

        // Consultar si alguien que no debía haber accedido al paciente lo hizo
        query = "SELECT visitas.visitante_nombre, visitas.relacion " +
                "FROM visitas " +
                "WHERE idP = (SELECT idP FROM pacientes WHERE nombre = 'Victor Montenegro') " +
                "AND visitas.relacion NOT IN ('Familiar', 'Doctor', 'Enfermera')";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            System.out.println("\nVisitantes sospechosos que no deberían haber accedido al paciente:");
            System.out.println("Visitante\tRelación");
            System.out.println("-----------------------------------------");

            while (rs.next()) {
                String visitante = rs.getString("visitas.visitante_nombre");
                String relacion = rs.getString("visitas.relacion");
                System.out.printf("%-15s%s%n", visitante, relacion);
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

private static void solveMystery(Connection conn) {
    try {
        // Consultar si el Doctor Y visitó al paciente y le administró una medicación no autorizada
        String query = "SELECT personal_medico.nombre, medicaciones.nombre_medicacion, medicaciones.dosis, medicaciones.fecha_administracion " +
                       "FROM medicaciones " +
                       "INNER JOIN personal_medico ON medicaciones.idPM = personal_medico.idPM " +
                       "WHERE medicaciones.idP = (SELECT idP FROM pacientes WHERE nombre = 'Victor Montenegro') " +
                       "AND personal_medico.nombre = 'Juan Diaz'";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                String nombreDoctor = rs.getString("personal_medico.nombre");
                String nombreMedicacion = rs.getString("medicaciones.nombre_medicacion");
                String dosis = rs.getString("medicaciones.dosis");
                String fechaAdministracion = rs.getString("medicaciones.fecha_administracion");

                System.out.println("\nEl enfermero Juan díaz administró una medicación no autorizada al Paciente: ");
                System.out.printf("Nombre: %s%nMedicación: %s%nDosis: %s%nFecha: %s%n",
                                 nombreDoctor, nombreMedicacion, dosis, fechaAdministracion);
            } else {
                System.out.println("\nNo se encontró evidencia de que el enfermero Juan díaz administrara una medicación no autorizada.");
            }
        }

        query = "SELECT motivos_visitas.motivo " +
                "FROM motivos_visitas " +
                "INNER JOIN visitas ON motivos_visitas.visita_id = visitas.id " +
                "WHERE visitas.paciente_id = (SELECT id FROM pacientes WHERE nombre = 'Victor Montenegro') ";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                String motivo = rs.getString("motivos_visitas.motivo");
                System.out.println("\nLa Enfermera Z descubrió un motivo oculto que pudo haber llevado al asesinato:");
                System.out.println(motivo);
            } else {
                System.out.println("\nNo se encontró evidencia de que la Enfermera Z tuviera un motivo oculto.");
            }
        }

        System.out.println("\n¡Felicidades, has resuelto el misterio!");
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
}