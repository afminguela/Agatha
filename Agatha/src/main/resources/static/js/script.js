document.addEventListener('DOMContentLoaded', function() {
  const terminal = document.getElementById('Cuadro_de_entrada');
  const input = document.getElementById('queryInput');
  const notebook = document.querySelector('.Notas');
  const enterButton = document.querySelector('.Enterbutton');
  const resetButton = document.querySelector('.Deletebutton');

  let commandHistory = [];
  let currentHistoryIndex = -1;

  function addToTerminal(text) {
    const screen = terminal.querySelector('.terminal-screen');
    const lines = screen.innerHTML.split('\n');
  lines.push(`> ${text}`);
  
  // Limitar el número de líneas
  if (lines.length > MAX_LINES) {
    lines.splice(0, lines.length - MAX_LINES);
  }
  
  screen.innerHTML = lines.join('\n');
   
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
        data.forEach(row => {
          // Formatear la salida para mejor legibilidad
          const formattedRow = Object.entries(row)
            .map(([key, value]) => `${key}: ${value}`)
            .join(' | ');
          addToTerminal(formattedRow);
          
          // Detectar pistas importantes
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

  async function resetDatabase() {
    try {
      const response = await fetch('/api/reset', {
        method: 'POST'
      });
      const data = await response.text();
      addToTerminal(data);
      notebook.innerHTML = '';
    } catch (error) {
      addToTerminal(`Error al reiniciar: ${error.message}`);
    }
  }

  enterButton.addEventListener('click', executeQuery);
  resetButton.addEventListener('click', resetDatabase);

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