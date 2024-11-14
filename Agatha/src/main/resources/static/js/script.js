document.addEventListener('DOMContentLoaded', function() {   
    
    // algunas variables para guardar las entradas del DOM;
    
  const terminal = document.getElementById('Terminal');
  const input = document.getElementById('queryInput');
  const notebook = document.querySelector('.PistaEncontrada');
  const enterButton = document.querySelector('.Enterbutton');
  const resetButton = document.querySelector('.Deletebutton');

// Variables para crear una lista de comandos ya introducidos, para que se puedan volver a usar. 
  let commandHistory = [];
  let currentHistoryIndex = -1;
 
 
 // funcion que pinta en el terminal los datos que llegan desde BK 
  function addToTerminal(text, isTable = false) {
  const screen = terminal.querySelector('.terminal-screen');
  
      // si es una tabla, le da formato de tabla a la entrada, separando las columnas. 
  if (isTable) {
    screen.innerHTML += `\n${text}`;
  } else {
    screen.innerHTML += `\n> ${text}`;
  }
  screen.scrollTop = screen.scrollHeight;
}


// Funcion para pintar en el cuaderno de notas cuando hay alguna pista importante. 
  function addToNotes(text) {
    notebook.innerHTML += `\n- ${text}`;
  }


// Funcion que ejecuta la llamada al BK, cuando pulsamos Enter. 
  async function executeQuery() {
  const query = input.value; //guarda la query entrada en el input en una variable 
  if (!query) return;

  commandHistory.push(query); // la guarda para poder volver a usar dando a la tecla UP del teclado
  currentHistoryIndex = commandHistory.length;

  try {
    const response = await fetch('/api/query', {  // pasa la query al BK
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ query: query })
    });

    const data = await response.json();  // recibe la respuesta del BK 
    if (response.ok) {
      addToTerminal(`Ejecutando: ${query}`);
      if (Array.isArray(data)) {
  if (data.length > 0) {
    const tableOutput = formatAsTable(data);
    addToTerminal(tableOutput, true);        // 
  } else {
    addToTerminal("No se encontraron resultados.");
  }
  
  // ¡¡¡ PARA CAMBIAR EL MISTERIO ES AQUI!!!
  // 
  // Detectar pistas importantes y disparar la funcion addToNotes para verlas en el cuaderno.
  data.forEach(row => {
    if (row.detalles && (            // comprueba linea a linea si tiene las palabras clave.
      row.detalles.includes('Digoxina') ||  
      row.detalles.includes('manipulación') ||
      row.detalles.includes('documentos confidenciales')
    )) {
      addToNotes(`¡Pista encontrada!: ${row.detalles}`);  // printa el mensaje
    }
  });
} else {
  addToTerminal(`Error: ${JSON.stringify(data)}`);
}
    }
  } catch (error) {
    addToTerminal(`Error: ${error.message}`);
  } finally {
    input.value = '';  // limpia el Input cuando acaba. 
  }
}

// Funcion para formatear los datos como tabla, como los mapea los convierte en clave:valor

function formatAsTable(data) {
  if (data.length === 0) return "No se encontraron resultados.";

  // Obtener las claves (nombres de columnas) del primer objeto
  const keys = Object.keys(data[0]);

  // Calcular el ancho máximo para cada columna
  const columnWidths = keys.map(key => 
    Math.max(key.length, ...data.map(row => String(row[key]).length))
  );

  // Crear la línea de encabezado
  const header = keys.map((key, i) => key.padEnd(columnWidths[i])).join(' | ');
  const separator = columnWidths.map(width => '-'.repeat(width)).join('-+-');

  // Crear las filas de datos
  const rows = data.map(row =>
    keys.map((key, i) => String(row[key]).padEnd(columnWidths[i])).join(' | ')
  );

  // Combinar todo
  return `${header}\n${separator}\n${rows.join('\n')}`;
}

// funcion para limpiar el terminal de datos 
  async function resetTerminal() {
    try {
        const terminalScreen = terminal.querySelector('.terminal-screen');
    if (terminalScreen) {
      terminalScreen.innerHTML = '';
  
          }
    
         
    } catch (error) {
      addToTerminal(`Error al reiniciar: ${error.message}`);
    }
  }

// EVENT LISTENERS --- 
   
    //Botones de Enter y delete  
    
  enterButton.addEventListener('click', executeQuery);
  resetButton.addEventListener('click', resetTerminal);

    
   // Para accesibilidad y poder usar el teclado en caso de que el ratón no vaya bien para 
  input.addEventListener('keydown', function(e) {
      
      // enter dispara la funcion executeQuery()
    if (e.key === 'Enter') {
      executeQuery();            
      
         // las flechas del teclado nos navegan por los comandos introducidos 
    } else if (e.key === 'ArrowUp') {
        
       if (currentHistoryIndex > 0) {
        currentHistoryIndex--;
        this.value = commandHistory[currentHistoryIndex];
      }
    } else if (e.key === 'ArrowDown') {
      if (currentHistoryIndex < commandHistory.length - 1) {
        currentHistoryIndex++;
        this.value = commandHistory[currentHistoryIndex];
      } else {
        currentHistoryIndex = commandHistory.length;
        this.value = '';
      }
    }
  });
});