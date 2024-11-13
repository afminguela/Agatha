package home.afm.Agatha;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface QueryRepository  extends JpaRepository<QueryRequest, Long> {
    

}
