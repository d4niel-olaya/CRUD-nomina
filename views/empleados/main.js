const url = 'http://localhost:80/proyecto_nomina/api/empleados';


async function api(){
    const response = await fetch(url).then(res => res.json());
    return response;
}
const app = document.getElementById('app');
const listado = await api();
app.innerHTML = `<p>${listado[0].nombre}</p>`

console.log(listado);