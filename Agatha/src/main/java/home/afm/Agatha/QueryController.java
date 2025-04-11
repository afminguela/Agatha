package home.afm.Agatha;

import java.nio.file.Files;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
            List<Map<String, Object>> result = jdbcTemplate.queryForList(query);
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Error en la query: " + e.getMessage());
        }
    }

    
    private boolean isQuerySafe(String query) {
        // Lista blanca de comandos permitidos
        if (!query.startsWith("select")&& !query.startsWith("call") {
            return false;
        }

        // Lista negra de palabras clave peligrosas
        String[] blacklist = {"drop", "delete", "update", "insert", "alter",
                "truncate", "create", "exec", "union"};
        for (String banned : blacklist) {
            if (query.contains(banned)) {
                return false;
            }
        }
        return true;
    }
}
