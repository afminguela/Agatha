document.addEventListener('DOMContentLoaded', function() {
  const terminal = document.getElementById('Terminal');
  const input = document.getElementById('queryInput');
  const notebook = document.querySelector('.Notes');
  const enterButton = document.querySelector('.Enterbutton');
  const resetButton = document.querySelector('.Deletebutton');

  let commandHistory = [];
  let currentHistoryIndex = -1;
 
  function addToTerminal(text, isTable = false) {
  const screen = terminal.querySelector('.terminal-screen');
  if (isTable) {
    screen.innerHTML += `\n${text}`;
  } else {
    screen.innerHTML += `\n> ${text}`;
  }
  screen.scrollTop = screen.scrollHeight;
}

  function addToNotes(text) {
    notebook.innerHTML += `\n- ${text}`;
  }

  async function executeQuery() {
  const query = input.value;
  if (!query) return;

  commandHistory.push(query);
  currentHistoryIndex = commandHistory.length;

  try {
    const response = await fetch('/api/query', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ query: query })
    });

    const data = await response.json();
    if (response.ok) {
      addToTerminal(`Ejecutando: ${query}`);
      if (Array.isArray(data)) {
  if (data.length > 0) {
    const tableOutput = formatAsTable(data);
    addToTerminal(tableOutput, true);
  } else {
    addToTerminal("No se encontraron resultados.");
  }
  
  // Detectar pistas importantes
  data.forEach(row => {
    if (row.detalles && (
      row.detalles.includes('Digoxina') ||
      row.detalles.includes('manipulación') ||
      row.detalles.includes('documentos confidenciales')
    )) {
      addToNotes(`¡Pista encontrada!: ${row.detalles}`);
    }
  });
} else {
  addToTerminal(`Error: ${JSON.stringify(data)}`);
}
    }
  } catch (error) {
    addToTerminal(`Error: ${error.message}`);
  } finally {
    input.value = '';
  }
}

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

  enterButton.addEventListener('click', executeQuery);
  resetButton.addEventListener('click', resetTerminal);

  input.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
      executeQuery();
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