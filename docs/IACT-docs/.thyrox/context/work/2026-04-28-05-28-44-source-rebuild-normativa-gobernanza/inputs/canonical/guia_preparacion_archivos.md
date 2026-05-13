---
id: DOC-SOL-SC00-ADP
estado: vigente
propietario: coordinacion-sc00
ultima_actualizacion: 2025-02-18
relacionados: ["DOC-SOL-INDEX", "SCP-SC00-DOCS", "SCP-SC00-INDEX"]
---
# Solicitud SC00 · Guía de preparación de archivos para arte y exhibición

Esta guía consolida los requisitos técnicos exigidos por el comité de SC00 para la entrega de materiales gráficos. Al
reubicarla en el espacio transversal de **solicitudes** aseguramos que esté disponible para otros eventos y campañas que
compartan criterios similares, manteniendo la trazabilidad con el frente operativo de SC00.

## Objetivo
- Establecer especificaciones de formato, color y resolución para los archivos de arte.
- Definir el flujo de revisión y aprobación previo al envío de materiales al proveedor.
- Documentar responsables y fechas clave para coordinar entregas dentro del cronograma general.

## Especificaciones técnicas
| Elemento | Requisito | Notas |
| --- | --- | --- |
| Formatos aceptados | `.ai`, `.eps`, `.pdf` (vectoriales); `.tiff`, `.png` (rasterizados) | Adjuntar fuentes y empaquetar imágenes vinculadas. |
| Resolución mínima | 300 DPI para impresos; 150 DPI para piezas de gran formato | Usar perfiles CMYK para impresión y RGB para pantallas. |
| Margen de seguridad | 5 mm para piezas impresas | Mantener textos y logos fuera del margen. |
| Sangrado | 3 mm por lado | Exportar archivos con marcas de corte visibles. |
| Paleta aprobada | Paleta corporativa `IACT-2025` | Disponible en `docs/anexos/diagramas/`. |

## Flujo de entrega
1. **Diseño inicial:** Equipo creativo genera bocetos y confirma dimensiones con Logística.
2. **Revisión técnica:** Coordinación SC00 verifica formatos, resolución y uso de paleta.
3. **Aprobación de contenido:** Gobernanza valida mensajes y disclaimers obligatorios.
4. **Envío al proveedor:** Se comparte paquete comprimido (`.zip`) con archivos finales y hoja de control.
5. **Validación de pruebas:** Se reciben pruebas impresas/digitales y se documentan ajustes en
   `docs/solicitudes/sc00/meeting_and_discussion_notes/readme.md`.

## Checklists
- [ ] Archivos vectoriales incluyen fuentes convertidas a contornos o adjuntas en carpeta `fonts/`.
- [ ] Versiones rasterizadas respetan la resolución mínima y modo de color indicado.
- [ ] Se adjunta hoja de control con nombre del archivo, responsable y fecha de última edición.
- [ ] Se suben respaldos al repositorio en `docs/solicitudes/sc00/sc00_documents/material_exhibicion/`.
- [ ] Se registra la fecha de envío al proveedor en el tablero de seguimiento SC00.

## Historial de cambios
| Fecha | Cambio | Responsable |
| --- | --- | --- |
| 2025-02-18 | Traslado desde `docs/sc00/sc00_documents/` a `docs/solicitudes/sc00/` con actualización de metadatos. | PMO Documentación |
