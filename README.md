# 🛣️ Buscador de Rutas - Prolog + Frontend

Este proyecto permite calcular rutas óptimas entre ciudades del estado de Michoacán, considerando múltiples criterios como **distancia**, **lugares de interés**, **tráfico** y **calidad de los caminos**. Está dividido en un backend desarrollado en **Prolog** y un frontend en tecnologías web básicas (HTML, CSS, JS).

---

## 📁 Estructura del Proyecto

```
RUTAS/
├── backend/
│   ├── rutas.pl         # Base de datos de caminos y lógica de rutas
│   └── server.pl        # Servidor que expone la lógica Prolog vía HTTP
├── frontend/
│   ├── index.html       # Interfaz gráfica para ingresar y consultar rutas
│   ├── script.js        # Lógica de interacción con el servidor
│   └── style.css        # Estilos de la interfaz
└── README.md            # Este documento
```

---

## 🎯 Objetivo

Desarrollar un sistema capaz de:

- Encontrar la **ruta más corta** entre dos ciudades.
- Calcular rutas que **pasen por lugares de interés**.
- Determinar la **ruta más rápida** considerando tráfico y calidad del camino.

---

## 🧠 Modelado

El sistema modela un mapa como un grafo donde cada **camino** tiene:

- Origen y destino
- Distancia
- Calidad del camino
- Nivel de tráfico
- Lugar de interés

Se utilizan **reglas lógicas** en Prolog para inferir rutas óptimas según distintos criterios.

---

## 🧪 Consultas principales (en Prolog)

1. **Ruta más corta (por distancia):**
```prolog
?- ruta_corta(zamora, jiquilpan, Ruta, Distancia).
```

2. **Ruta con lugares de interés obligatorios:**
```prolog
?- ruta_con_intereses(zamora, sahuayo, [ixtlan], Ruta, Distancia).
```

3. **Ruta más rápida (considerando calidad y tráfico):**
```prolog
?- ruta_rapida(zamora, sahuayo, Ruta, Tiempo).
```

---

## 🌐 Interfaz Web

El frontend permite que el usuario seleccione el tipo de búsqueda, las ciudades de origen/destino y los lugares de interés. Se comunica con el servidor Prolog (`server.pl`) mediante peticiones HTTP.

---

## 🚀 Cómo ejecutar

### Backend (Prolog con SWI-Prolog)

1. Instala [SWI-Prolog](https://www.swi-prolog.org/).
2. Abre la terminal en la carpeta `backend/`.
3. Ejecuta:

```bash
swipl server.pl
```

Esto inicia un servidor HTTP local que espera peticiones del frontend.

---

### Frontend

1. Abre `index.html` con tu navegador favorito.
2. Asegúrate de que el backend está corriendo para que pueda consultar rutas.

---

## 🔧 Tecnologías utilizadas

- **Prolog (SWI-Prolog)** – Backend lógico
- **HTML, CSS, JavaScript** – Frontend interactivo
- **HTTP con Prolog** – Comunicación entre frontend y lógica

---

## 📌 Conclusión

Este proyecto muestra el poder de la **programación lógica** para resolver problemas de rutas en grafos con restricciones y preferencias múltiples. La integración con una interfaz web lo hace accesible y escalable.

---

## 👤 Autor

**Said Piñones Ramírez**  
Estudiante de Ingeniería en Sistemas Computacionales  
