let mapa = L.map('map').setView([19.99, -102.28], 9);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(mapa);

// Coordenadas de las ciudades (actualiza con todas tus ciudades del backend)
const coords = {
  zamora: [19.9897, -102.2832],
  jiquilpan: [20.0211, -102.7269],
  vistaH: [20.1064, -102.6644], // Coordenadas aproximadas para Vista Hermosa
  laPiedad: [20.3392, -102.0292], // Coordenadas aproximadas para La Piedad
  chilchota: [19.8667, -102.1667], // Coordenadas aproximadas para Chilchota
  sahuayo: [20.0603, -102.7231] // Coordenadas aproximadas para Sahuayo
};

function buscarRutaCorta() {
  const origen = document.getElementById('origen').value;
  const destino = document.getElementById('destino').value;

  fetch(`http://localhost:8000/ruta?origen=${origen}&destino=${destino}`)
    .then(resp => {
      // Verifica si la respuesta es OK (ej. 200) o un error (ej. 404)
      if (!resp.ok) {
          // Si hay un error HTTP, intenta leer el cuerpo como JSON para obtener el mensaje de error de Prolog
          return resp.json().then(errorData => {
              throw new Error(errorData.error || `Error HTTP: ${resp.status}`); // Lanza el error con el mensaje de Prolog o genérico
          }).catch(() => {
              // Si no se puede leer el JSON de error (ej. respuesta no JSON), lanza un error genérico
              throw new Error(`Error HTTP: ${resp.status}`);
          });
      }
      return resp.json(); // Si la respuesta es OK, procede a leer el JSON
    })
    .then(data => {
      // La lógica original para mostrar la ruta exitosa
      document.getElementById("resultado").innerText =
        `Ruta más corta de ${origen} a ${destino} (${data.distancia.toFixed(2)} km): ${data.ruta.join(' → ')}`;
      mostrarRutaEnMapa(data.ruta);
    })
    .catch(error => {
      // Captura errores de red (ej. servidor no disponible) o errores lanzados en el `.then()`
      console.error('Error al buscar ruta corta:', error);
      document.getElementById("resultado").innerText = `Error: ${error.message || "Error de conexión o del servidor."}`;
    });
}

function buscarRutaRapida() {
    const origen = document.getElementById('origen').value;
    const destino = document.getElementById('destino').value;

    fetch(`http://localhost:8000/rapida?origen=${origen}&destino=${destino}`)
        .then(resp => {
            if (!resp.ok) { // Si la respuesta no es OK (ej. 404)
                return resp.json().then(errorData => {
                    throw new Error(errorData.error || `Error HTTP: ${resp.status}`);
                }).catch(() => {
                    throw new Error(`Error HTTP: ${resp.status}`);
                });
            }
            return resp.json();
        })
        .then(data => {
            document.getElementById("resultado").innerText =
                `Ruta más rápida de ${origen} a ${destino} (Tiempo estimado: ${data.tiempo.toFixed(2)}): ${data.ruta.join(' → ')}`;
            mostrarRutaEnMapa(data.ruta);
        })
        .catch(error => {
            console.error('Error al buscar ruta rápida:', error);
            document.getElementById("resultado").innerText = `Error: ${error.message || "Error de conexión o del servidor."}`;
        });
}

function buscarRutaConIntereses() {
    const origen = document.getElementById('origen').value;
    const destino = document.getElementById('destino').value;
    const intereses = document.getElementById('intereses').value; // Los intereses ya vienen como string separado por comas

    fetch(`http://localhost:8000/intereses?origen=${origen}&destino=${destino}&intereses=${intereses}`)
        .then(resp => {
            if (!resp.ok) { // Si la respuesta no es OK (ej. 404)
                return resp.json().then(errorData => {
                    throw new Error(errorData.error || `Error HTTP: ${resp.status}`);
                }).catch(() => {
                    throw new Error(`Error HTTP: ${resp.status}`);
                });
            }
            return resp.json();
        })
        .then(data => {
            document.getElementById("resultado").innerText =
                `Ruta con intereses de ${origen} a ${destino} (${data.distancia.toFixed(2)} km, Intereses: ${data.intereses.join(', ')}): ${data.ruta.join(' → ')}`;
            mostrarRutaEnMapa(data.ruta);
        })
        .catch(error => {
            console.error('Error al buscar ruta con intereses:', error);
            document.getElementById("resultado").innerText = `Error: ${error.message || "Error de conexión o del servidor."}`;
        });
}

function mostrarRutaEnMapa(ruta) {
  // Limpiar capas existentes (líneas y marcadores)
  mapa.eachLayer((layer) => {
    if (layer instanceof L.Polyline || layer instanceof L.Marker) {
      mapa.removeLayer(layer);
    }
  });

  // Convertir nombres de ciudad a coordenadas
  const puntos = ruta.map(ciudad => {
    if (coords[ciudad]) {
      return coords[ciudad];
    } else {
      console.warn(`Coordenadas no encontradas para la ciudad: ${ciudad}`);
      return null; // O manejar el error de otra manera
    }
  }).filter(p => p !== null); // Filtrar cualquier punto nulo

  if (puntos.length > 0) {
    // Dibujar la polilínea
    L.polyline(puntos, { color: 'blue', weight: 4 }).addTo(mapa);

    // Añadir marcadores a cada ciudad de la ruta
    puntos.forEach((coord, index) => {
      let markerText = ruta[index];
      L.marker(coord).addTo(mapa).bindPopup(markerText).openPopup();
    });

    // Ajustar la vista del mapa para que se ajuste a la ruta
    mapa.fitBounds(L.polyline(puntos).getBounds());
  } else {
    document.getElementById("resultado").innerText = "No se pudo mostrar la ruta en el mapa (coordenadas faltantes).";
  }
}