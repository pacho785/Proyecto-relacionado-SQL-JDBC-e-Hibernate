# 📦 Proyecto Final – Módulo 4 (Working with Databases)

Proyecto desarrollado en Java utilizando **MySQL, Hibernate, Redis y Docker**.

## 🎯 Objetivo

Optimizar una consulta frecuente que generaba latencia en MySQL trasladando los datos más solicitados a Redis (cache en memoria tipo clave-valor).

Se implementa:

- Persistencia relacional con MySQL
- ORM con Hibernate (JPA)
- Cache con Redis
- Serialización JSON con Jackson
- Contenedores Docker
- Comparación de rendimiento MySQL vs Redis

---

## 🧱 Stack Tecnológico

- Java
- MySQL 8
- Hibernate 5.6
- Redis
- Docker
- Maven
- Lettuce (cliente Redis)
- Jackson
- P6Spy (monitoring SQL)

---

## 🗂️ Arquitectura

### Capa Dominio
- `Country`
- `City`
- `CountryLanguage`

### Capa DAO
- `CountryDAO`
- `CityDAO`

### Capa Redis
- `CityCountry`
- `Language`

---

## ⚙️ Funcionalidad Principal

1. Obtiene todas las ciudades desde MySQL
2. Optimiza consultas usando `JOIN FETCH` para evitar problema N+1
3. Transforma datos relacionales en modelo optimizado
4. Serializa a JSON
5. Guarda en Redis usando ID de ciudad como clave
6. Compara tiempos de respuesta entre:
   - MySQL
   - Redis

---

## 🚀 Ejecución con Docker

### MySQL

```bash
docker run --name mysql -d -p 3306:3306 \
-e MYSQL_ROOT_PASSWORD=root \
--restart unless-stopped \
-v mysql:/var/lib/mysql mysql:8
