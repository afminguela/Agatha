// URLs de la API
const API_URL = 'http://localhost:8080/api';
const CLIENTES_URL = `${API_URL}/clientes`;
const PRODUCTOS_URL = `${API_URL}/productos`;
const CPC_URL = `${API_URL}/cpc`;

// Funciones auxiliares
const getEl = id => document.getElementById(id);
const createEl = tag => document.createElement(tag);

// Función para realizar peticiones a la API
async function fetchAPI(url, method = 'GET', body = null) {
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (body) options.body = JSON.stringify(body);
    const response = await fetch(url, options);
    if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
    return response.json();
}

// Funciones CRUD para Clientes
async function getClientes() {
    try {
        const clientes = await fetchAPI(`${CLIENTES_URL}/listaAll`);
        const list = getEl('cliente-list');
        list.innerHTML = '';
        clientes.forEach(cliente => {
            const li = createEl('li');
            li.textContent = `${cliente.nombre} (${cliente.correo})`;
            li.innerHTML += ` <button onclick="editCliente(${cliente.id})">Editar</button>`;
            li.innerHTML += ` <button onclick="deleteCliente(${cliente.id})">Eliminar</button>`;
            list.appendChild(li);
        });
        updateClienteSelect();
    } catch (error) {
        console.error('Error al obtener clientes:', error);
    }
}

async function saveCliente(event) {
    event.preventDefault();
    const id = getEl('cliente-id').value;
    const cliente = {
        nombre: getEl('cliente-nombre').value,
        correo: getEl('cliente-correo').value
    };
    try {
        if (id) {
            await fetchAPI(`${CLIENTES_URL}/${id}`, 'PUT', cliente);
        } else {
            await fetchAPI(CLIENTES_URL, 'POST', cliente);
        }
        getEl('cliente-form').reset();
        getEl('cliente-id').value = '';
        getClientes();
    } catch (error) {
        console.error('Error al guardar cliente:', error);
    }
}