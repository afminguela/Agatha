
document.addEventListener('DOMContentLoaded', function() {
    const terminal = document.getElementById('Cuadro_de_entrada');
    const input = document.getElementById('Cuadro_de_entrada_0');
    const notebook = document.getElementById('notes');
    const enterButton = document.getElementById('enterButton');
    const resetButton = document.getElementById('enterButton_0');
    
    let commandHistory = [];
    let currentHistoryIndex = -1;

    terminal.innerHTML = `
        <div class="terminal-screen">
            > Sistema iniciado. Bienvenido a la base de datos del hospital.
            > Usa comandos SELECT para investigar el caso.
        </div>
    `;

    input.innerHTML = `
        <input type="text" id="queryInput" 
               placeholder="Ingresa tu comando SQL aquí..."
               class="w-full p-2 bg-black text-green-500 font-mono">
    `;

    function addToTerminal(text) {
        const screen = terminal.querySelector('.terminal-screen');
        screen.innerHTML += `\n> ${text}`;
        screen.scrollTop = screen.scrollHeight;
    }

    function addToNotes(text) {
        const noteArea = notebook.querySelector('#texturaCuaderno');
        noteArea.innerHTML += `\n- ${text}`;
    }

    async function executeQuery() {
        const queryInput = document.getElementById('queryInput');
        const query = queryInput.value;

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
                        addToTerminal(JSON.stringify(row));
                        
                        // Detectar pistas importantes
                        if (row.detalles && (
                            row.detalles.includes('Digoxina') ||
                            row.detalles.includes('manipulación') ||
                            row.detalles.includes('documentos confidenciales')
                        )) {
                            addToNotes(`¡Pista encontrada!: ${row.detalles}`);
                        }
                    });
                }
            } else {
                addToTerminal(`Error: ${data}`);
            }
        } catch (error) {
            addToTerminal(`Error: ${error.message}`);
        }

        queryInput.value = '';
    }

    async function resetDatabase() {
        try {
            const response = await fetch('/api/reset', {
                method: 'POST'
            });

            const data = await response.text();
            addToTerminal(data);
            notebook.querySelector('#texturaCuaderno').innerHTML = '';
        } catch (error) {
            addToTerminal(`Error al reiniciar: ${error.message}`);
        }
    }

    enterButton.addEventListener('click', executeQuery);
    resetButton.addEventListener('click', resetDatabase);

    document.getElementById('queryInput').addEventListener('keydown', function(e) {
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