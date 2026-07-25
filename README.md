# Publicación Técnica: Análisis Post-Mortem Constructivo

**Autor:** Yazmin Trucido 
**Proyecto:** Proyecto Final - Módulo 11  

---

## El apagón silencioso de correos

> **El contexto del negocio**  
> Recientemente, una actualización inesperada por parte de un proveedor externo provocó que nuestro sistema de soporte dejara de registrar correos electrónicos de forma silenciosa, creando un punto ciego en nuestra atención. Para solucionarlo de raíz, el equipo no solo restauró el flujo de datos, sino que implementó una red de seguridad en nuestro código y elevó los estándares de nuestras pruebas automáticas para prever cambios externos. Como resultado, ahora contamos con un sistema resiliente que, ante cualquier anomalía futura, alertará inmediatamente al equipo, garantizando que ninguna solicitud crítica quede sin respuesta y protegiendo la confianza de nuestros usuarios.

---

## 1. Resumen del incidente
El pasado martes, experimentamos una interrupción en la integración de nuestro sistema de soporte. Durante un periodo de 4 horas, el sistema dejó de registrar los correos electrónicos entrantes en la plataforma sin emitir alertas, lo que generó un punto ciego temporal en la comunicación.

## 2. Impacto
* **Usuarios externos:** No experimentaron errores visibles; los correos se enviaban desde sus bandejas de salida sin recibir notificaciones de rebote.
* **Equipo interno (Soporte):** Perdieron visibilidad inmediata de aproximadamente 300 solicitudes críticas, lo que retrasó los tiempos de respuesta.
* **Sistema:** La clase principal encargada del manejo de *Email Messages* falló en silencio, interrumpiendo el flujo de trabajo sin disparar las alarmas de monitoreo estándar.

## 3. Causa Raíz (Análisis sin culpas)
El incidente se originó por un cambio en la estructura de los datos de una API de terceros, combinado con una falta de resiliencia en nuestro código:
* El proveedor de la API introdujo un nuevo campo anidado en el JSON de respuesta sin previo aviso.
* Nuestra lógica de deserialización en Apex estaba diseñada para una estructura estricta. Al recibir el nuevo formato dinámico, arrojó una excepción no controlada que detuvo el proceso.
* Aunque contábamos con una cobertura de pruebas del 77% en ese momento, la suite carecía de escenarios que simularan *payloads* malformados o cambios estructurales inesperados en las integraciones externas.

## 4. Acciones Correctivas
Para garantizar la estabilidad futura y mejorar la resiliencia de nuestro código, el equipo implementó las siguientes mejoras:
* **Manejo robusto de excepciones:** Refactorizamos el bloque de deserialización del JSON agregando un `try-catch` específico para capturar, registrar y alertar sobre cualquier error de formato en el futuro.
* **Flexibilidad en el procesamiento:** Ajustamos las clases de Apex para procesar las respuestas de forma dinámica, permitiendo que el sistema ignore campos no mapeados sin fallar.
* **Mejora del Unit Testing:** Aumentamos la cobertura de las pruebas unitarias al 80%, incorporando nuevos *mocks* que simulan respuestas de API fallidas, estructuras alteradas y datos incompletos.

---

## Detrás de escena: El factor humano y el trabajo en equipo

Lidiar con un error silencioso en producción puede generar bastante estrés. Cuando descubrimos que la falla se debía a un cambio externo y que nuestros tests estaban en un 77% sin cubrir este escenario, la frustración inicial fue alta. En ese momento, apliqué la técnica de **respiración 4-4-4** antes de sumergirme en el código; esta pausa fue clave para evitar tomar decisiones apresuradas y enfocarme en resolver la causa raíz con claridad mental.

Una vez calmadas las aguas, la solución técnica se gestionó bajo estrictas buenas prácticas. Creé una rama específica (feature branch) mediante nuestro sistema de **control de versiones** para aislar los cambios en la lógica de procesamiento y los nuevos tests unitarios. 

Antes de fusionar los cambios a la rama principal mediante un Pull Request, tuvimos una sesión de revisión de código. Allí, apliqué los principios de **Feedback Radicalmente Sincero**. Un compañero me señaló directamente que el primer bloque *try-catch* que propuse era demasiado genérico, pero lo hizo desde un lugar de genuina empatía por la calidad del proyecto. Lejos de tomarlo personal, ese feedback me permitió refinar la excepción en Apex y lograr que las pruebas unitarias superaran el 80% de cobertura de forma sólida.
