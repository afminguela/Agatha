package home.afm.Agatha;

import java.util.*;
import java.util.regex.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcCall;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class QueryController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/query")
    public ResponseEntity<Object> executeQuery(@RequestBody QueryRequest request) {
        String query = request.getQuery();
        // Validación básica de seguridad mediante comparacion de palabras
        if (!isQuerySafe(query.toLowerCase())) {
            return ResponseEntity.badRequest().body("Query no permitida");
        }

        try {
             if (query.trim().toLowerCase().startsWith("select")) {
            List<Map<String, Object>> result = jdbcTemplate.queryForList(query);
            return ResponseEntity.ok(result);

            } else if (query.trim().toLowerCase().startsWith("call el_asesino_es")) {
                // Extraer el parámetro nombre
                Pattern pattern = Pattern.compile("call\\s+el_asesino_es\\s*\\(([^)]*)\\)", Pattern.CASE_INSENSITIVE);
                Matcher matcher = pattern.matcher(query.trim());
                if (matcher.find()) {
                    String nombre = matcher.group(1).trim().replaceAll("[\"']", "");
                    SimpleJdbcCall simpleJdbcCall = new SimpleJdbcCall(jdbcTemplate)
                            .withProcedureName("el_asesino_es");
                    Map<String, Object> params = new HashMap<>();
                    params.put("nombre", nombre);
                    Map<String, Object> result = simpleJdbcCall.execute(params);
                    // El ResultSet suele venir con la clave "#result-set-1"
                    Object data = result.get("#result-set-1");
                    return ResponseEntity.ok(data);

                } else {
                    return ResponseEntity.badRequest().body("CALL mal formado.");
                }
            } else {
                return ResponseEntity.badRequest().body("Tipo de query no soportada.");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error en la query: " + e.getMessage());
        }
    }

    
    private boolean isQuerySafe(String query) {
        // Lista blanca de comandos permitidos compara lo que pasa por la query y si tiene Select o Call lo deja pasar
       if (!query.startsWith("select") && !query.startsWith("call")) {
        return false;
    }

        

        // Lista negra de palabras clave peligrosas
        String[] blacklist = {"drop", "delete", "update", "insert", "alter",
                "truncate", "create", "exec", "union"};
        for (String banned : blacklist) {
            if (query.toLowerCase().contains(banned)) {
                return false;
            }
        }
        return true;
    }
}
